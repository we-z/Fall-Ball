//
//  CloudkitCrud.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 8/24/23.
//

import Foundation
import SwiftUI
import CloudKit
import Combine

struct CloudKitScoreModelNames {
    static let name = "name"
}

struct ScoreModel: Hashable, CloudKitableProtocol {
    let characterID: String
    let bestScore: Int
    let record: CKRecord
    
    init?(record: CKRecord) {
        guard let name = record[CloudKitScoreModelNames.name] as? String else { return nil }
        self.characterID = name
        let count = record["count"] as? Int
        self.bestScore = count ?? 0
        self.record = record
    }
    
    init?(characterID: String, bestScore: Int?) {
        let record = CKRecord(recordType: "Scores")
        record["name"] = characterID
        if let bestScore = bestScore {
            record["count"] = bestScore
        }
        self.init(record: record)
    }
    
    func update(newCharacterID: String, newScore: Int) -> ScoreModel? {
        let record = record
        record["name"] = newCharacterID
        record["count"] = newScore
        return ScoreModel(record: record)
    }
    
}

class CloudKitCrud: ObservableObject {
    
    @Published var text: String = ""
    @Published var scores: [ScoreModel] = []
    @Published var myScoreModel: ScoreModel = ScoreModel(characterID: "", bestScore: 0)!
    var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchItems()
    }
    
    func addButtonPressed() {
        guard !text.isEmpty else { return }
        let randomCount = Int(arc4random_uniform(1000))
        addItem(characterID: text, score: randomCount)
    }
    
    func addItem(characterID: String, score: Int) {
        guard let newScore = ScoreModel(characterID: characterID, bestScore: score) else { return }
        CloudKitUtility.update(item: newScore) { [weak self] result in
            print("Item added")
            print(result)
            self?.fetchItems()
        }

    }
    
    func fetchItems() {
        let predicate = NSPredicate(value: true)
        let recordType = "Scores"
        CloudKitUtility.fetch(predicate: predicate, recordType: recordType, sortDescriptions:  [NSSortDescriptor(key: "count", ascending: false)])
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] returnedItems in
                self?.scores = returnedItems
            }
            .store(in: &cancellables)
    }
    
    
    func updateItem(score: ScoreModel) {
        guard let newScore = score.update(newCharacterID: "Test Update", newScore: 696) else { return }
        CloudKitUtility.update(item: newScore) { [weak self] result in
            print("UPDATE COMPLETED")
            self?.fetchItems()
        }
    }
    
    func deleteItem(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let score = scores[index]
        
        CloudKitUtility.delete(item: score)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] success in
                print("DELETE IS: \(success)")
                self?.scores.remove(at: index)
            }
            .store(in: &cancellables)

    }
    
}

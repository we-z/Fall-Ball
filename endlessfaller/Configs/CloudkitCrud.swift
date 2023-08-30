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

struct LocalRecord {
    var recordID: CKRecord.ID
    // Add other properties that match your CKRecord's data fields

    // Custom initializer for CKRecord.ID
    init(recordID: CKRecord.ID) {
        self.recordID = recordID
    }
}

extension LocalRecord: Codable {
    enum CodingKeys: String, CodingKey {
        case recordID
        // Add coding keys for other properties
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let recordIDString = try container.decode(String.self, forKey: .recordID)
        recordID = CKRecord.ID(recordName: recordIDString)
        // Decode other properties here
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(recordID.recordName, forKey: .recordID)
        // Encode other properties here
    }
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

}

class CloudKitCrud: ObservableObject {
    
    @Published var scores: [ScoreModel] = []
    var record = CKRecord(recordType: "Scores") 
    var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchItems()
    }
    
    func updateRecord(newScore: Int, newCharacterID: String) {
        guard let localRecord = loadLocalRecord() else {
            print("Local record not found.")
            addItem(characterID: newCharacterID, score: newScore)
            return
        }

        // Fetch the record from CloudKit using the saved recordID
        CloudKitUtility.fetchRecord(withRecordID: localRecord.recordID) { [weak self] result in
            switch result {
            case .success(let recordToUpdate):
                // Update the relevant fields of the record
                recordToUpdate["count"] = newScore
                recordToUpdate["name"] = newCharacterID

                // Save the updated record to CloudKit
                if let updatedScoreModel = ScoreModel(record: recordToUpdate) {
                    CloudKitUtility.update(item: updatedScoreModel) { updateResult in
                        switch updateResult {
                        case .success:
                            print("Record updated successfully.")
                            self?.fetchItems() // Fetch updated records
                        case .failure(let error):
                            print("Record update failed with error: \(error)")
                        }
                    }
                } else {
                    print("Failed to update record: Invalid ScoreModel.")
                }

            case .failure(_):
                print("")
            }
        }
    }
    
    func addItem(characterID: String, score: Int) {
        guard let newScore = ScoreModel(characterID: characterID, bestScore: score) else { return }
        CloudKitUtility.update(item: newScore) { [weak self] result in
            self?.saveToLocal(record: newScore.record)
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
    
    func saveToLocal(record: CKRecord) {
        let localRecord = LocalRecord(recordID: record.recordID)
        // Map other fields from CKRecord to localRecord

        do {
            print("saveToLocal called")
            let encoder = JSONEncoder()
            let data = try encoder.encode(localRecord)
            
            let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("localRecord.json")
            try data.write(to: fileURL)
        } catch {
            print("Error encoding or saving: \(error)")
        }
    }
    
}

func loadLocalRecord() -> LocalRecord? {
    let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("localRecord.json")
    
    do {
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        let localRecord = try decoder.decode(LocalRecord.self, from: data)
        return localRecord
    } catch {
        print("Error loading or decoding: \(error)")
        return nil
    }
}

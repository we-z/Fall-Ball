//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI
import CloudKit
import Combine

struct CloudKitScoreModelNames {
    static let name = "name"
}

struct ScoreModel: Hashable, CloudKitableProtocol {
    let characterID: String
    let count: Int
    let record: CKRecord
    
    init?(record: CKRecord) {
        guard let name = record[CloudKitScoreModelNames.name] as? String else { return nil }
        self.characterID = name
        let count = record["count"] as? Int
        self.count = count ?? 0
        self.record = record
    }
    
    init?(name: String, count: Int?) {
        let record = CKRecord(recordType: "Scores")
        record["name"] = name
        if let count = count {
            record["count"] = count
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

class CloudKitCrudBootcampViewModel: ObservableObject {
    
    @Published var text: String = ""
    @Published var scores: [ScoreModel] = []
    var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchItems()
    }
    
    func addButtonPressed() {
        guard !text.isEmpty else { return }
        addItem(name: text)
    }
    
    private func addItem(name: String) {
        let randomCount = Int(arc4random_uniform(1000))
        guard let newScore = ScoreModel(name: name, count: randomCount) else { return }
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

struct CloudKitCrudBootcamp: View {
    
    @StateObject private var vm = CloudKitCrudBootcampViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                header
                textField
                addButton
                
                List {
                    ForEach(vm.scores, id: \.self) { score in
                        HStack {
                            Text(score.characterID)
                            Spacer()
                            Text(String(score.count))
                        }
                        .onTapGesture {
                            vm.updateItem(score: score)
                        }
                    }
                    .onDelete(perform: vm.deleteItem)
                }
                .listStyle(PlainListStyle())
                .refreshable {
                    vm.fetchItems()
                }
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}


extension CloudKitCrudBootcamp {
    
    private var header: some View {
        Text("CloudKit CRUD ☁️☁️☁️")
            .font(.headline)
            .underline()
    }
    
    private var textField: some View {
        TextField("Add something here...", text: $vm.text)
            .frame(height: 55)
            .padding(.leading)
            .background(Color.gray.opacity(0.4))
            .cornerRadius(10)
    }
    
    private var addButton: some View {
        Button {
            vm.addButtonPressed()
        } label: {
            Text("Add")
                .font(.headline)
                .foregroundColor(.white)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color.pink)
                .cornerRadius(10)
        }
    }
    
}


struct TempView: View {
    var body: some View {
        Text("hello")
    }
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitCrudBootcamp()
    }
}

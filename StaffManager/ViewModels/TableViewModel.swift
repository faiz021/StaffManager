//
//  TableViewModel.swift
//  StaffManager
//
//  Created by Faiz Mohideen on 04/02/2019.
//  Copyright © 2019 Faiz Mohideen. All rights reserved.
//

import Foundation
import RealmSwift
import ReactiveSwift
import ReactiveCocoa
import Result

class TableViewModel<Element: RealmSwift.Object> {
    var dataStore: DataStoreType
    var results: Results<Element>
    private var notificationToken: NotificationToken?
    
    init(dataStore: DataStoreType = try! Realm()) {
        self.dataStore = dataStore
        self.results = type(of: self).fetch(dataFrom: dataStore)
        
        print(results)
    }
    
    class func fetch (dataFrom dataStore : DataStoreType) -> Results<Element> {
        return dataStore.objects(Element.self)
    }

    func bind() -> (
        reloadData: Signal<(), NoError>,
        updateRows: Signal<TableRowChanges, NoError>,
        updateRowsError: Signal<Realm.Error, NoError>
        ) {
            let (initRows, initRowsObserver) = Signal<(), NoError>.pipe()
            let (updateRows, updateRowsObserver) = Signal<TableRowChanges, NoError>.pipe()
            let (updateRowsError, updateRowsErrorObserver) = Signal<Realm.Error, NoError>.pipe()
            
            notificationToken = results.observe { changes in
                switch changes {
                case .initial:
                    initRowsObserver.send(value: ())
                case .update(_, let deletions, let insertions, let modifications):
                    updateRowsObserver.send(value: (
                        deletions: deletions,
                        insertions: insertions,
                        modifications: modifications
                    ))
                case .error(let error):
                    updateRowsErrorObserver.send(value: error as! Realm.Error)
                }
            }
            
            let reloadData = Signal.merge([
                initRows
                ].compactMap { $0 })
            
            return (
                reloadData: reloadData,
                updateRows: updateRows,
                updateRowsError: updateRowsError
            )
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    func object(at index: Int) -> Element? {
        return results[index]
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        guard section == 0 else { return 0 }
        return results.count
    }
}

typealias TableRowChanges = (deletions: [Int], insertions: [Int], modifications: [Int])

extension Reactive where Base: UITableView {
    var updateRows: BindingTarget<TableRowChanges> {
        return makeBindingTarget { tableView, changes in
            tableView.beginUpdates()
            tableView.deleteRows(at: changes.deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
            tableView.insertRows(at: changes.insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
            tableView.reloadRows(at: changes.modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
            tableView.endUpdates()
        }
    }
}

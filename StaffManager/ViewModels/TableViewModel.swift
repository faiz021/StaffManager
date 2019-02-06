//
//  TableViewModel.swift
//  StaffManager
//
//  Created by Faiz Mohideen on 04/02/2019.
//  Copyright © 2019 Faiz Mohideen. All rights reserved.
//

import Foundation
import RealmSwift

class TableViewModel<Element: RealmSwift.Object> {
    var dataStore: DataStoreType
    
    
    init(dataStore: DataStoreType = try! Realm()) {
        self.dataStore = dataStore
    }
    
    class func fetch (dataFrom dataStore : DataStoreType) -> Results<Element> {
        return dataStore.objects(Element.self)
    }
}

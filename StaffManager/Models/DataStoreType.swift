//
//  DataStoreType.swift
//  StaffManager
//
//  Created by Faiz Mohideen on 04/02/2019.
//  Copyright © 2019 Faiz Mohideen. All rights reserved.
//

import Foundation

import Foundation
import RealmSwift

protocol DataStoreType {
    func objects<Element>(_ type: Element.Type) -> RealmSwift.Results<Element> where Element : RealmSwift.Object
    func object<Element, KeyType>(ofType type: Element.Type, forPrimaryKey key: KeyType) -> Element? where Element : RealmSwift.Object
    func add(_ object: RealmSwift.Object, update: Bool)
    func delete(_ object: RealmSwift.Object)
    func write(_ block: (() throws -> Void)) throws
}

extension Realm: DataStoreType {}

extension DataStoreType {
    func object<Element>(ofType type: Element.Type, forUUID uuid: UUID?) -> Element? where Element : IdentifiableObject {
        return object(ofType: type, forPrimaryKey: uuid?.uuidString)
    }
}

class IdentifiableObject: Object {
    @objc private dynamic var id = UUID().uuidString
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var uuid: UUID {
        return UUID(uuidString: id)!
    }
}

//
//  StaffTableViewModel.swift
//  StaffManager
//
//  Created by Faiz Mohideen on 06/02/2019.
//  Copyright © 2019 Faiz Mohideen. All rights reserved.
//

import Foundation
import RealmSwift

final class StaffTableViewModel: TableViewModel<Staff> {
    override class func fetch(dataFrom db : DataStoreType) -> Results<Staff> {
        return db.objects(Staff.self).sorted(byKeyPath: #keyPath(Staff.name))
    }
}

//
//  Staff.swift
//  StaffManager
//
//  Created by Faiz Mohideen on 01/02/2019.
//  Copyright © 2019 Faiz Mohideen. All rights reserved.
//

import Foundation
import RealmSwift

class Staff: IdentifiableObject {
    @objc dynamic var name: String = ""
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}

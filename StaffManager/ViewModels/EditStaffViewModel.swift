//
//  EditStaffViewModel.swift
//  StaffManager
//
//  Created by Faiz Mohideen on 01/02/2019.
//  Copyright © 2019 Faiz Mohideen. All rights reserved.
//

import Foundation
import Result
import RealmSwift
import ReactiveSwift

class EditStaffViewModel {
    private var staff: Staff
    private var staffUUID: UUID?
    private var dataStore: DataStoreType
    
    init(newStaff: Staff = Staff(), staffUUID: UUID? = nil, dataStore: DataStoreType = try! Realm()) {
        self.staff = newStaff
        self.staffUUID = staffUUID
        self.dataStore = dataStore
        
        if let personUUID = staffUUID, let existingPerson = self.dataStore.object(ofType: Staff.self, forUUID: personUUID) {
            self.staff = existingPerson
        } else {
            self.staff = newStaff
        }
    }
    
    func bind(
        viewDidLoad: Signal<(), NoError>,
        nameChanged: Signal<String, NoError>,
        saveButtonPressed: Signal<(), NoError>,
        deleteButtonPressed: Signal<(), NoError>
    ) -> (
        setNavBarTitle: Signal<String, NoError>,
        setTextForNameTextField: Signal<String, NoError>,
        nameTextFieldBecomeFirstResponder: Signal<(), NoError>,
        showError: Signal<String, NoError>,
        dismiss: Signal<(), NoError>
        ) {
            let navBarTitle = viewDidLoad.map { _ -> String in
                guard self.staffUUID != nil else { return "Add New Staff" }
                return "Edit \(self.staff.name)"
            }
            
            let newStaffName = viewDidLoad.map { data -> String in
                guard self.staffUUID != nil else { return "" }
                return self.staff.name
            }
            
            let name = Signal.merge(newStaffName, nameChanged)
        
            let submitName = name.sample(on: saveButtonPressed)
        
            let saveStaffName = submitName.filter({ !$0.isEmpty }).attemptMap({ name in
                try self.dataStore.write {
                    self.staff.name = name
                    self.dataStore.add(self.staff, update: true)
                }
            })
            
            let deleteStaff = deleteButtonPressed.attemptMap({
                try self.dataStore.write {
                    self.dataStore.delete(self.staff)
                }
            })
            
            let errorEmptyTextField = newStaffName.materialize().filterMap({ $0.error }).map({ _ in "Name field is empty"})
            let errorWritingToDatabase = saveStaffName.materialize().filterMap({ $0.error }).map({ _ in "Error saving staff name"})
            let errorDeletingStaff = deleteStaff.materialize().filterMap({ $0.error }).map({_ in "Error deleting staff name"})

            let showError = Signal.merge(errorEmptyTextField, errorWritingToDatabase, errorDeletingStaff)
            
            let submission = Signal.merge(saveStaffName, deleteStaff)
            
            let dismiss = submission.materialize().filterMap({$0.value})
            
        return (
            setNavBarTitle: navBarTitle,
            setTextForNameTextField: name,
            nameTextFieldBecomeFirstResponder: viewDidLoad,
            showError: showError,
            dismiss: dismiss
            )
    }
    
}



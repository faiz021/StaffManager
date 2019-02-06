//
//  EditStaffViewController.swift
//  StaffManager
//
//  Created by Faiz Mohideen on 01/02/2019.
//  Copyright © 2019 Faiz Mohideen. All rights reserved.
//

import UIKit
import Result
import ReactiveCocoa
import ReactiveSwift

class EditStaffViewController: UIViewController {
    @IBOutlet weak var addEditTextField: UITextField!
    @IBOutlet weak var btnSaveStaff: UIButton!
    @IBOutlet weak var btnDeleteStaff: UIButton!
    
    var staffUUID: UUID?
    var dispossible = CompositeDisposable()
    private let viewDidLoadProperty = MutableProperty(())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel(EditStaffViewModel(staffUUID: self.staffUUID))
        self.viewDidLoadProperty.value = ()
        self.btnDeleteStaff.isHidden = staffUUID == nil
    }
    
    func bindViewModel(_ viewModel: EditStaffViewModel) {
        let (setNavBarTitle,
            setTextForNameTextField,
            nameTextFieldBecomeFirstResponder,
            showError,
            dismiss) = viewModel.bind(
                viewDidLoad: viewDidLoadProperty.signal,
                nameChanged: addEditTextField.reactive.continuousTextValues.skipNil(),
                saveButtonPressed: btnSaveStaff.reactive.mapControlEvents(.touchUpInside) { _ in () },
                deleteButtonPressed: btnDeleteStaff.reactive.mapControlEvents(.touchUpInside) { _ in () })
        
        navigationItem.reactive.title <~ setNavBarTitle
        addEditTextField.reactive.text <~ setTextForNameTextField
        addEditTextField.reactive.becomeFirstResponder <~ nameTextFieldBecomeFirstResponder
        
        dispossible += dismiss
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        dispossible += showError
            .observe(on: UIScheduler())
            .observeValues { [weak self] text in
            self?.present(UIAlertController.alert(text), animated: true)
        }
        
    }
    
}

extension UIAlertController {
    static func alert(_ title: String? = nil,
                      message: String? = nil,
                      handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alertController.addAction(
            UIAlertAction(
                title: "OK",
                style: .cancel,
                handler: handler
            )
        )
        
        return alertController
    }
}

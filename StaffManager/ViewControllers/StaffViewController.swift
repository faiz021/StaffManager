//
//  StaffViewController.swift
//  StaffManager
//
//  Created by Faiz Mohideen on 01/02/2019.
//  Copyright © 2019 Faiz Mohideen. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class StaffViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var staffTableView: UITableView!
    var staffNameArray: [Staff] = [Staff]()
    private let staffTableViewModel = StaffTableViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel(viewModel: staffTableViewModel)
        staffTableView.delegate = self
        staffTableView.dataSource = self
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "EditStaffViewController", sender: self)
    }
    
    private func bindViewModel(viewModel: TableViewModel<Staff>) {
        let (
        reloadData,
            updateRows,
                _) = viewModel.bind()
        
        staffTableView.reactive.reloadData <~ reloadData
        staffTableView.reactive.updateRows <~ updateRows
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return staffTableViewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = staffTableView.dequeueReusableCell(withIdentifier: "StaffCell", for: indexPath) as! StaffTableViewCell
        let staff = staffTableViewModel.object(at: indexPath.row)
        cell.staffNameLabel.text = staff?.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let staff = staffTableViewModel.object(at: indexPath.row)
        if let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditStaffViewController") as? EditStaffViewController {
            destination.staffUUID = staff?.uuid
            navigationController?.pushViewController(destination, animated: true)
        }
    }
    
}


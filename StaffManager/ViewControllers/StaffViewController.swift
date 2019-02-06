//
//  StaffViewController.swift
//  StaffManager
//
//  Created by Faiz Mohideen on 01/02/2019.
//  Copyright © 2019 Faiz Mohideen. All rights reserved.
//

import UIKit

class StaffViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var staffTableView: UITableView!
    var staffNameArray: [Staff] = [Staff]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        staffTableView.delegate = self
        staffTableView.dataSource = self
        
//        let staff = Staff()
//        staff.name = "Faiz"
//        staffNameArray.append(staff)

    }
    

    @IBAction func goToEditView(_ sender: Any) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return staffNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = staffTableView.dequeueReusableCell(withIdentifier: "StaffCell", for: indexPath) as! StaffNameCell
        
        cell.staffNameLabel.text = staffNameArray[indexPath.row].name
        
        return cell
    }
    
    
}

class StaffNameCell: UITableViewCell {
    @IBOutlet weak var staffNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

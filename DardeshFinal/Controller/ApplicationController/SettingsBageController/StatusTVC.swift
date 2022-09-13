//
//  StatusTVC.swift
//  DardeshFinal
//
//  Created by MacOS on 02/02/2022.
//

import UIKit

protocol StatusTVCDelegate {
    func getTheState(name : String)
}

class StatusTVC: UITableViewController {

    
    //MARK: - Constant
    static let stateTVCellID = "StatusTVCell"
    let statusData = ["Happy","Sad","Veyr Sad","Vrey Vey Sad","Con't be more Sad","I don't know"]
    public var delegate : StatusTVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCell()
    }

    
    
    //MARK: - HelperFunctions
    private func setupCell(){
        self.title = "Choose Status"
        self.tableView.register(UINib(nibName: StatusTVC.stateTVCellID, bundle: nil), forCellReuseIdentifier: StatusTVC.stateTVCellID)
    }
    
    
    //MARK: - Table View func

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusData.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatusTVC.stateTVCellID, for: indexPath) as! StatusTVCell
        cell.textLabel?.text = statusData[indexPath.row]
        let userStatus = User.currentUser?.status
        cell.accessoryType = userStatus == statusData[indexPath.row] ? .checkmark : .none
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userStatus = tableView.cellForRow(at: indexPath)?.textLabel?.text
        tableView.reloadData()
        var user = User.currentUser
        user?.status = userStatus!
        saveUserLocally(user!)
        FUserListener.shared.saveUserToFirestore(user!)
        delegate.getTheState(name:user!.status)
        dismiss(animated: true, completion: nil)
    }

}
// when change the value from this bage make the func from other bage ????????

//
//  UserProfileTVC.swift
//  DardeshFinal
//
//  Created by MacOS on 08/02/2022.
//

import UIKit

class UserProfileTVC: UITableViewController {
    
    //MARK: - Constant
static let firstCellID = "firstUserProfileTVCell"
static let secondCellID = "secondUserProfileTVCell"
    //to but the information from the UsersTVC
    var user : User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = user?.username
        navigationItem.largeTitleDisplayMode = .never
        setupCells()
    }
    
    //MARK: - IBAction

    
    //MARK: - HelperFunctions
    private func setupCells(){
        self.tableView.register(UINib(nibName: UserProfileTVC.firstCellID, bundle: nil), forCellReuseIdentifier: UserProfileTVC.firstCellID)
        self.tableView.register(UINib(nibName: UserProfileTVC.secondCellID, bundle: nil), forCellReuseIdentifier: UserProfileTVC.secondCellID)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileTVC.firstCellID, for: indexPath) as! firstUserProfileTVCell
            cell.setupUI(user!)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileTVC.secondCellID, for: indexPath) as! secondUserProfileTVCell
            
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
        return 200
        }else{
          return 50
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            // it will equal the chatRoomId
            let ChatId = startChat(sender: User.currentUser!, recever: user!)
            let privateMSGView = MSGViewController(chatId: ChatId, recipientId: user!.id, recipientName: user!.username)
            navigationController?.pushViewController(privateMSGView, animated: true)
        }
    }
    
}

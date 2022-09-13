//
//  FollowChannelTVC.swift
//  DardeshFinal
//
//  Created by MacOS on 16/06/2022.
//

import UIKit

// we can make the refresh by using the protocol to tell the channle the the user make follow
protocol FollowChannelTVCDelegate{
    func didClickFollow()
}


class FollowChannelTVC: UITableViewController {
    
    
    //MARK: - Constant

    static let FollowChannelCell1 = "FollowChannelCell1"
    static let FollowChannelCell2 = "AddChannelCell2"
    
    var channelToEdit : Channel!
    
    var followDelegate : FollowChannelTVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCell()
        setupNavigation()
    }

    //MARK: - HelperFunctions
    
    private func setupCell(){
        self.tableView.register(UINib(nibName: FollowChannelTVC.FollowChannelCell1, bundle: nil), forCellReuseIdentifier: FollowChannelTVC.FollowChannelCell1)
        self.tableView.register(UINib(nibName: FollowChannelTVC.FollowChannelCell2, bundle: nil), forCellReuseIdentifier: FollowChannelTVC.FollowChannelCell2)
    }
    
    private func setupNavigation(){
        if channelToEdit != nil {
            self.title = channelToEdit!.name
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Follow", style: .plain, target: self, action: #selector(followAction))
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    //MARK: - IBAction
    @objc func followAction(){
        // to follow only append it on follow array ----> memberIds and this way he will be member of the channel
        channelToEdit?.memberIds.append(User.currentID)
        FChannelListener.shared.saveChannel(channelToEdit!)
        followDelegate?.didClickFollow()
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: FollowChannelTVC.FollowChannelCell1, for: indexPath) as! FollowChannelCell1
            if channelToEdit != nil{
                cell.channelName.text = channelToEdit!.name
                cell.members.text = "\(channelToEdit!.memberIds.count) members"
                if channelToEdit!.avatarLink != ""{
                    FileStorage.downloadImage(imageURL: channelToEdit!.avatarLink) { image in
                        DispatchQueue.main.async {
                            cell.avatarImage.image = image?.circleMasked
                        }
                    }
                }else{
                    cell.avatarImage.image = UIImage(named:"avatar")
                }
            }
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: FollowChannelTVC.FollowChannelCell2, for: indexPath) as! AddChannelCell2
            if channelToEdit != nil{
                cell.aboutChannel.text = channelToEdit!.aboutChannel
            }
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 80
        }else{
            return 200
        }
    }
}

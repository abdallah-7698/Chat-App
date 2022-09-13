//
//  ChannelsVC.swift
//  DardeshFinal
//
//  Created by MacOS on 28/01/2022.
//

import UIKit

class ChannelsVC: UITableViewController {
    
    //MARK: - IBOutlet
    // for the segment we must have three arrays one for each value
    lazy var channelSegment : UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Following","Not Following","My Channel"])
        segment.frame = CGRect(x: 50, y: 5, width: view.frame.width - 100, height: 35)
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(channelSegmentChanged), for: .valueChanged)
        return segment
    }()
    
    
    //MARK: - Constant
    
    static let ChannelVCCell = "ChannelVCCell"
    var subscribedAChannels : [Channel] = []
    var allChannels : [Channel] = []
    var myChannels : [Channel] = []
    
    //MARK: - ViewDiDLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCell()
        prepareNavigation()
        
        // download the channels and filll the array
        downloadAllChannels()
        downloadUserChannels()
        downloadSubscribedChannels()
        // but after the download the segment will not change because we dont make the data changable
        refreshControl = UIRefreshControl()
        self.refreshControl = refreshControl
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareNavigation()
    }
    
    
    //MARK: - HelperFunctions
    private func setUpCell(){
        self.tableView.register(UINib(nibName: ChannelsVC.ChannelVCCell, bundle: nil), forCellReuseIdentifier: ChannelsVC.ChannelVCCell)
    }
    private func prepareNavigation(){
        self.title = "Channels"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.addSubview(channelSegment)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pushAddTVC))
    }
    
    @objc func pushAddTVC(){
        let vc = AddChannelTVC()
        channelSegment.removeFromSuperview()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func channelSegmentChanged(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    //MARK: - Download Channels
    
    private func downloadAllChannels(){
        FChannelListener.shared.downloadAllChannels { allChannels in
            self.allChannels = allChannels
            if self.channelSegment.selectedSegmentIndex == 1{
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    private func downloadSubscribedChannels(){
        FChannelListener.shared.downloadSubscribedChannel { subscribedChannels in
            self.subscribedAChannels = subscribedChannels
            if self.channelSegment.selectedSegmentIndex == 0{
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func downloadUserChannels(){
        FChannelListener.shared.downloadUserChannel { userChannels in
            self.myChannels = userChannels
            if self.channelSegment.selectedSegmentIndex == 2{
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //MARK: - Refresh Controller
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl!.isRefreshing {
            self.downloadAllChannels()
            refreshControl!.endRefreshing()
        }
    }

    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if channelSegment.selectedSegmentIndex == 0{
            return subscribedAChannels.count
        }else if channelSegment.selectedSegmentIndex == 1{
            return allChannels.count
        }else{
            return myChannels.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChannelsVC.ChannelVCCell, for: indexPath) as! ChannelVCCell
        var channel = Channel()
        if channelSegment.selectedSegmentIndex == 0{
            channel = subscribedAChannels[indexPath.row]
        }else if channelSegment.selectedSegmentIndex == 1{
            channel = allChannels[indexPath.row]
        }else{
            channel = myChannels[indexPath.row]
        }
        cell.configure(channel: channel)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        // chane it from 1 to 0
        if channelSegment.selectedSegmentIndex == 0{
           // show chatting
            showChat(channel: subscribedAChannels[indexPath.row])
        }else if channelSegment.selectedSegmentIndex == 1{
            // shwo follow channels
            showFollowingChannel(channel: allChannels[indexPath.row])
        }else{
            showeditChannelView(channel : myChannels[indexPath.row])
            // show the edit channel view
        }
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if channelSegment.selectedSegmentIndex == 1 || channelSegment.selectedSegmentIndex == 2{
            return false
        }else{
            // only this channel you can edit if you are not the admin
            return subscribedAChannels[indexPath.row].adminId != User.currentID
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            /*
             -- if you make a follow to  channel and want to make unfollow (you are not the admin)
             1- remove it from your subscriebd channel --> the var you have on your app
             2- when you remove it from your app it still on the firebase and your id still on it so
             3- bafore you delete it make the changes and thin save the changes on the data base
             */
            var channelToUnfollow = subscribedAChannels[indexPath.row]
            subscribedAChannels.remove(at: indexPath.row)
            if let index = channelToUnfollow.memberIds.firstIndex(of: User.currentID){
                channelToUnfollow.memberIds.remove(at: index)
            }
            FChannelListener.shared.saveChannel(channelToUnfollow)
            // better than make refreshing to the all tqbleView
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    //MARK: - navigation functions
    
    private func showeditChannelView(channel : Channel){
        let channelVC = AddChannelTVC()
        channelSegment.removeFromSuperview()
        channelVC.channelToEdit = channel
        self.navigationController?.pushViewController(channelVC, animated: true)
    }
    private func showFollowingChannel(channel : Channel){
        let channelVC = FollowChannelTVC()
        channelVC.channelToEdit = channel
        channelSegment.removeFromSuperview()
        channelVC.followDelegate = self
        self.navigationController?.pushViewController(channelVC, animated: true)
    }
    
    private func showChat(channel : Channel){
        let channelChatVC = ChannelMSGVC(channel: channel)
        navigationController?.pushViewController(channelChatVC, animated: true)
    }
    
}

extension ChannelsVC : FollowChannelTVCDelegate{
    func didClickFollow() {
        self.downloadAllChannels()
    }
}

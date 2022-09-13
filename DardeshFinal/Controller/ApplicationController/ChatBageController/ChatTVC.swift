//
//  ChatTVC.swift
//  DardeshFinal
//
//  Created by MacOS on 09/02/2022.
//

import UIKit

class ChatTVC: UITableViewController {
     
    //MARK: - Constant

    static let chatCell = "ChatTVCell"
    var allChatRooms : [ChatRoom] = []
    var filterdChatRooms : [ChatRoom] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigation()
        setupCell()
        getAllChatRooms()
        prepareSearchController()
        setupNavigationButtom()
    }

    //MARK: - IBAction

    
    
    //MARK: - HelperFunctions
    func prepareNavigation(){
        self.title = "Chat"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    private func setupCell(){
        self.tableView.register(UINib(nibName: ChatTVC.chatCell, bundle: nil), forCellReuseIdentifier: ChatTVC.chatCell)
    }
    private func getAllChatRooms(){
        FChatRoomListner.shared.downloadChatRoom { allFBChatRooms in
            self.allChatRooms = allFBChatRooms
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private func prepareSearchController(){
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search User"
        definesPresentationContext = true   //<<----
        searchController.searchResultsUpdater = self
    }
    
    func setupNavigationButtom(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composeAction))
    }
    @objc func composeAction(){
        let vc = UsersTVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToMSG(chatRoom : ChatRoom){
        ///TODO : - you must be sure that the recever has the room and donot delete it
       // if any user deleta the chat room the app will create another one for him he check
        // you don't have the User objects in this case so donload it to call the start and (restart make it)
        restartChat(ChatRoomId: chatRoom.chatRoomId, memberIds: chatRoom.memberIds)
        let privateMSGView = MSGViewController(chatId: chatRoom.chatRoomId, recipientId: chatRoom.receiverId, recipientName: chatRoom.receiverName)
        navigationController?.pushViewController(privateMSGView, animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchController.isActive ? filterdChatRooms.count : allChatRooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatTVC.chatCell, for: indexPath) as! ChatTVCell
       
//        let chatRoom = ChatRoom(id: "123", chatRoomId: "465", senderId: "123", senderName: "ali", receiverId: "23", receiverName: "mazen", date: Date(), memberIds: [""], lastMassage: "Hello Ali ! How are you let's go to the zoo", unreadCounter:  12, avatarink: "")
        
        cell.configure(chatRoom: searchController.isActive ? filterdChatRooms[indexPath.row] : allChatRooms[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    // make you change on the table
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    // when you make the delete you must delete the value from the array and make reload for data the last line is for make a refrest after delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let chatRoom = searchController.isActive ? filterdChatRooms[indexPath.row] : allChatRooms[indexPath.row]
            FChatRoomListner.shared.deleteChatRoom(chatRoom: chatRoom )
            searchController.isActive ? filterdChatRooms.remove(at: indexPath.row) : allChatRooms.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatRoomObjec = searchController.isActive ? filterdChatRooms[indexPath.row] : allChatRooms[indexPath.row]
        goToMSG(chatRoom : chatRoomObjec)
    }
    
}
extension ChatTVC : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterdChatRooms = allChatRooms.filter({ ChatRoom -> Bool in
            return ChatRoom.receiverName.lowercased().contains(searchController.searchBar.text!.lowercased())
           
        })
            tableView.reloadData()
    }
}



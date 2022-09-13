

import UIKit

class UsersTVC: UITableViewController {
    //MARK: - IBOutlet
   
   
    //MARK: - Constant
static let UserTVCellID = "UsersTVCell"
    var allUsers = [User]()
    // creating the search controller
    let searchController = UISearchController(searchResultsController: nil)
    // to get the search result on it
    var filteredUsers : [User] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCell()
        prepareNavigation()
        // it only gets the corrent user not all users to get all users we make a func to make this
        //allUsers = [User.currentUser!]
        downloadUsers()
        prepareSearchController()
        prepareRefreshControl()
        
        //createDummyUsers()
    }

    //MARK: - IBAction

    
    

    //MARK: - HelperFunctions
    private func setUpCell(){
        self.tableView.register(UINib(nibName: UsersTVC.UserTVCellID, bundle: nil), forCellReuseIdentifier: UsersTVC.UserTVCellID)
    }
    func prepareNavigation(){
        self.title = "Users"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    private func downloadUsers(){
        FUserListener.shared.downloadAllUsers { users in
            self.allUsers = users
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }
    private func showUserProfile(_ user : User){
        let vc = UserProfileTVC()
        vc.user = user
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    //MARK: - Make a Search Controller

    private func prepareSearchController(){
        // to make the search on the top of the viewController
        // we made the searchController var on the coonstants
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search User"
        definesPresentationContext = true   //<<----
        // this is a delegate of the search Controller so you must make an extension and make the func on it
        searchController.searchResultsUpdater = self
    }
    
    //MARK: - Make the Refresh Control

    private func prepareRefreshControl(){
        self.refreshControl = UIRefreshControl()
        self.tableView.refreshControl = self.refreshControl
    }
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.refreshControl!.isRefreshing{
            self.downloadUsers()
            self.refreshControl!.endRefreshing()
        }
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filteredUsers.count : allUsers.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UsersTVC.UserTVCellID , for: indexPath) as! UsersTVCell
        let user = searchController.isActive ? filteredUsers[indexPath.row] : allUsers[indexPath.row]
        cell.configureCell(user: user)
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // here we get the user but the user may be on the filter array so we must check
        let user = searchController.isActive ? filteredUsers[indexPath.row] : allUsers[indexPath.row]
         showUserProfile(user)
    }
    
}
extension UsersTVC : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filteredUsers = allUsers.filter({ user -> Bool in
            return user.username.lowercased().contains(searchController.searchBar.text!.lowercased())
        })
        tableView.reloadData()
    }
    
    
}

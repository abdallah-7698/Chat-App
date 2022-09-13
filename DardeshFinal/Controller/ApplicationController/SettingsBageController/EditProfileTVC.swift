
import UIKit

class EditProfileTVC: UITableViewController {
    
    
    //MARK: - IBOutlet
    
    
    //MARK: - Constant
    static let firstCellIdentifire   = "EdetProfileFirstTVC"
    static let secondCellIdentifire  = "EditProfileSecondTVCell"
    static let therdCellIdentifire   = "EditProfileTherdTVCell"
    var statusName = ""
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // tableView.reloadData()
        //  showUserInfo()
        
    }
    
    //MARK: - HelperFunctions
    private func setupUI(){
        self.title = "Edit Profile"
        navigationItem.largeTitleDisplayMode = .never
        self.tableView.register(UINib(nibName: EditProfileTVC.firstCellIdentifire, bundle: nil), forCellReuseIdentifier: EditProfileTVC.firstCellIdentifire)
        self.tableView.register(UINib(nibName: EditProfileTVC.secondCellIdentifire, bundle: nil), forCellReuseIdentifier: EditProfileTVC.secondCellIdentifire)
        self.tableView.register(UINib(nibName: EditProfileTVC.therdCellIdentifire, bundle: nil), forCellReuseIdentifier: EditProfileTVC.therdCellIdentifire)
    }
    
    
    
    
}

//MARK: - TableView

extension EditProfileTVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 2
        }else{
            return 1
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: EditProfileTVC.firstCellIdentifire, for: indexPath) as! EdetProfileFirstTVC
                
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: EditProfileTVC.secondCellIdentifire, for: indexPath) as! EditProfileSecondTVCell
                
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: EditProfileTVC.therdCellIdentifire, for: indexPath) as! EditProfileTherdTVCell
            cell.showUserInfo(name: statusName)
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            if indexPath.row == 0{
                return 100
            }
            return 50
        }else{
            return 50
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 10.0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            let VC = StatusTVC()
            VC.delegate = self
            VC.modalPresentationStyle = .fullScreen
            self.present(VC, animated: true, completion: nil)
        }
    }
}
extension EditProfileTVC : StatusTVCDelegate {
    func getTheState(name: String) {
        print ("nameeeeeeeeee : " , name)
        statusName = name
        tableView.reloadData()
    }
}


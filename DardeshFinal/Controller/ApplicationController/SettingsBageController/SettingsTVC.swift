/*
 1- you should save the names in static to get it easly (or in enum) -> name of cell id
 2- the cell id should be the same of the cell name
 3- ------->>> it is better to make the code able to bhange very easy
 (like the array of the dataOnSecondCellsButton you should make the add of new cell very easy )
 */

import UIKit
import ProgressHUD
import Firebase


class SettingsTVC: UITableViewController {

    //MARK: - Constant
    static let firstCellIdentifire  = "firstSettingTVCell"
    static let secondCellIdentifire = "secondSettingTVCell"
    static let thirdCellIdentifire  = "thirdSettingTVCell"
    //don't forget tif you added any new bage you muct but it on the present
    let dataOnSecondCellsButton = ["Tell a Frind" , "Terms and Conditions"]
    let dataOnThirdCellsButton = ["Version"," "]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        prepareNavigation()
        //tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
        /*
        1-  when the func was in the cell this code doesn't work but when it is in the cell.showUserInfo() it works either when no asyc on the func ???
        2- when the table view runc the data is not found you wnat the data to get after the run so we but it on ViewDidAppear
        3- self.tableView.reloadData() is recreate the cells with the new data
         */
            self.tableView.reloadData()
        }
    }
    
    //MARK: - HelperFunctions
  
    func setupUI(){
        // make th nip name equal to ID
        self.tableView.register(UINib(nibName: SettingsTVC.firstCellIdentifire, bundle: nil), forCellReuseIdentifier: SettingsTVC.firstCellIdentifire)
        self.tableView.register(UINib(nibName: SettingsTVC.secondCellIdentifire, bundle: nil), forCellReuseIdentifier: SettingsTVC.secondCellIdentifire)
        self.tableView.register(UINib(nibName: SettingsTVC.thirdCellIdentifire, bundle: nil), forCellReuseIdentifier: SettingsTVC.thirdCellIdentifire)
    }
    
    func prepareNavigation(){
        self.title = "Settings"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}

//MARK: - TableView Extension
extension SettingsTVC{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1{
            return dataOnSecondCellsButton.count
        }else{
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // to make an id you must make register
        if indexPath.section == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTVC.firstCellIdentifire, for: indexPath) as! firstSettingTVCell
            // how to make sell gets the data when the view appear ---> by use the reload data
            cell.showUserInfo()
        cell.editingAccessoryType = .disclosureIndicator
        return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTVC.secondCellIdentifire, for: indexPath) as! secondSettingTVCell
            //we create two cells this func configet get the data from here and but it on the cell button
            cell.configure(with: dataOnSecondCellsButton[indexPath.row])
            // when click get the cell title and make the func but where is the func --- > on the button
            // may it be better on code <<<----
            cell.delegate = self
            cell.editingAccessoryType = .disclosureIndicator
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTVC.thirdCellIdentifire, for: indexPath) as! thirdSettingTVCell
            // but the data on the cell
            cell.prepareTheCells(title: dataOnThirdCellsButton[indexPath.row], in: indexPath.row)
            // could be better     <<<------- no because you cant present on the cell
            cell.delegate = self
            cell.editingAccessoryType = .disclosureIndicator
            return cell
            }
        }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 80
        }else{
            return 50
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            //why it is soooo slow at first time??????????????????? not smothhhhhhh
          let VC = EditProfileTVC()
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 1.0
    }
}

//MARK: - Cells Extension
extension SettingsTVC : secondSettingTVCellDelegate,thirdSettingTVCellDelegate{
    func makeFunc() {
           // print ("Logout done")
            logoutCurrentUser { error in
                if error == nil {
                    let VC = Login_Signup_Bage()
                    VC.modalPresentationStyle = .fullScreen
                    DispatchQueue.main.async {
                        self.present(VC, animated: true, completion: nil)
                    }
                }else{
                    ProgressHUD.showError(error?.localizedDescription)
                }
            }
    }
    
    func didTabButton(with title: String) {
        if title == dataOnSecondCellsButton[0]{
            let VC = tellFrinds()
            self.navigationController?.pushViewController(VC, animated: true)
        }else if title == dataOnSecondCellsButton[1]{
            let VC = termsAndConditions()
           // to make it faster ???
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }else{
            ProgressHUD.showError("Bage is not Found")
        }
    }
    
    //MARK: - Logout

    func logoutCurrentUser(complition : @escaping (_ error : Error?) -> Void){
        do{
       try Auth.auth().signOut()
            userDefault.removeObject(forKey: kCURRENTUSER)
            userDefault.synchronize()
            complition(nil)
        }catch let error as NSError{
                complition(error)
            }
    }

    
}

/*
 1- there is a problem --> some times when the appopen on the setting View the image and data don't appear
 bacause it comes from database but it take some time so the cell be made afer this the cell gets the data
 ---> but i make reload data but the problem still there
 */

import UIKit

class firstSettingTVCell: UITableViewCell {
    
    //MARK: - IBOutlet
    
    
    @IBOutlet weak var avatarImageOutlet: UIImageView!
    @IBOutlet weak var userNameOutlet: UILabel!
    @IBOutlet weak var statusOutlet: UILabel!
    
    
    
    override func awakeFromNib() {
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .none
         //showUserInfo()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // how to make it wait untill the
    //MARK: - HelperFunctions
    func showUserInfo(){
        if let user = User.currentUser{
            self.userNameOutlet.text = user.username
            self.statusOutlet.text = user.status
            if user.avatarLink != "" {
                FileStorage.downloadImage(imageURL: user.avatarLink) { avatarImage in
                    self.avatarImageOutlet.image = avatarImage?.circleMasked
                }
            }
        }else {
            print ("nooooooooooooooooooFound data")

        }
    }
}

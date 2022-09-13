
import UIKit

class UsersTVCell: UITableViewCell {
    //MARK: - IBOutlet

    @IBOutlet weak var avatarImageOutlet: UIImageView!
    @IBOutlet weak var userNameOutlet: UILabel!
    @IBOutlet weak var statusOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: - HelperFunctions
    func configureCell(user : User){
        userNameOutlet.text = user.username
        statusOutlet.text = user.status
        if user.avatarLink != "" {
            FileStorage.downloadImage(imageURL: user.avatarLink) { avatarImage in
                self.avatarImageOutlet.image = avatarImage?.circleMasked
            }
        }else{
            self.avatarImageOutlet.image = UIImage(named: "avatar")
        }
    }
    
}

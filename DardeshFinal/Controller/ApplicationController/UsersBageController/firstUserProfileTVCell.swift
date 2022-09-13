//
//  firstUserProfileTVCell.swift
//  DardeshFinal
//
//  Created by MacOS on 08/02/2022.
//

import UIKit

class firstUserProfileTVCell: UITableViewCell {

    //MARK: - IBOutlet
    
    
    @IBOutlet weak var avatarImageOutlet: UIImageView!
    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var statsOutlet: UILabel!
    
    //MARK: - Constant

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - HelperFunctions
    func setupUI(_ user : User){
        if user != nil{
            nameOutlet.text = user.username
            statsOutlet.text = user.status
            if user.avatarLink != ""{
                FileStorage.downloadImage(imageURL: user.avatarLink) { image in
                    self.avatarImageOutlet.image = image?.circleMasked
                }
            }
        }
    }
    
    
}

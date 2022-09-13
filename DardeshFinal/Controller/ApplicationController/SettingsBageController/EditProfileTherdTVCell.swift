//
//  EditProfileTherdTVCell.swift
//  DardeshFinal
//
//  Created by MacOS on 29/01/2022.
//

import UIKit

class EditProfileTherdTVCell: UITableViewCell {

    //MARK: - IBOutlet
    
    @IBOutlet weak var stateLableOutlet: UILabel!
    
    
    //MARK: - Constant

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showUserInfo(name : "")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - HelperFunction
// if you dont state changes it gets the data from the StatsTVC and send it by delegate and the second time you hav the information on the database
// the data update on the User.currentUser slow
    func showUserInfo(name : String){
        if name == ""{
        if let user = User.currentUser {
            stateLableOutlet.text = user.status
        }
        }else{
            stateLableOutlet.text = name
        }
    }
    
}


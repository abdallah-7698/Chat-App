//
//  EditProfileSecondTVCell.swift
//  DardeshFinal
//
//  Created by MacOS on 29/01/2022.
//

import UIKit

class EditProfileSecondTVCell: UITableViewCell {
   
    //MARK: - IBOutlet

    @IBOutlet weak var ChangeNameTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showUserInfo()
        configureTextField()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - HelperFunctions
    // you must get the values first and the change it
    private func showUserInfo(){
        if let user = User.currentUser {
            ChangeNameTextField.text = user.username
        }
    }
    private func configureTextField(){
        ChangeNameTextField.delegate = self
        ChangeNameTextField.clearButtonMode = .whileEditing
    }
}
extension EditProfileSecondTVCell : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // when we work here we use textfield
        //when finish the save in the if return true if not save return false
        if textField == ChangeNameTextField{
            if textField.text != ""{
                if var user = User.currentUser{
                    user.username = textField.text!
                    saveUserLocally(user)
                    FUserListener.shared.saveUserToFirestore(user)
                }
            }
            return false
        }
        // when done hide the keybord
        textField.resignFirstResponder()
        return true
    }
}

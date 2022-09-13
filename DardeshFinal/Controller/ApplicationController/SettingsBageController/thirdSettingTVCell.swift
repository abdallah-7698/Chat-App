//
//  thirdSettingTVCell.swift
//  DardeshFinal
//
//  Created by MacOS on 28/01/2022.
//

import UIKit
import Firebase

protocol thirdSettingTVCellDelegate:AnyObject{
    func makeFunc()
}

class thirdSettingTVCell: UITableViewCell {

    //MARK: - IBOutlet

    @IBOutlet weak var versionLable: UILabel!
    @IBOutlet weak var LogoutButton: UIButton!
    

    //MARK: - Constant
    weak var delegate : thirdSettingTVCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .none
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - IBAction

    @IBAction func logoutAction(_ sender: UIButton) {
        delegate?.makeFunc()
    }
    
    
    //MARK: - HelperFunctions
    func prepareTheCells(title : String,in index : Int){
        if index == 0 {
            versionLable.isEnabled = false
            versionLable.text = "App Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
            LogoutButton.isHidden = true
        }else{
            versionLable.isEnabled = true
            versionLable.text! = title
            LogoutButton.isHidden = false
        }
    }
    
}

//
//  secondSettingTVCell.swift
//  DardeshFinal
//
//  Created by MacOS on 28/01/2022.
//

import UIKit

protocol secondSettingTVCellDelegate:AnyObject{
    func didTabButton(with title:String)
}

class secondSettingTVCell: UITableViewCell {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var secodCellButtonOutlet: UIButton!
    
    
    //MARK: - Constant
     weak var delegate : secondSettingTVCellDelegate?
     private var title : String = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // make the color like a link
        secodCellButtonOutlet.setTitleColor(.link, for: .normal)
    }
    
    //MARK: - HelperFunctions

    func configure(with title : String){
        self.title = title
        secodCellButtonOutlet.setTitle(title, for: .normal)
    }
    
    //MARK: - IBAction

    @IBAction func doToNewBage(_ sender: UIButton) {
        delegate?.didTabButton(with: title)
    }
    
}

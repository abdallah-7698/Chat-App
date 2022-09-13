//
//  ChatTVCell.swift
//  DardeshFinal
//
//  Created by MacOS on 09/02/2022.
//

import UIKit

class ChatTVCell: UITableViewCell {
    //MARK: - IBOutlet
    @IBOutlet weak var avatarImageOutlet: UIImageView!
    @IBOutlet weak var userNameOutlet: UILabel!{
        didSet{
            userNameOutlet.minimumScaleFactor = 0.9
        }
    }
    @IBOutlet weak var lastMassageOutlet: UILabel!{
        didSet{
            lastMassageOutlet.minimumScaleFactor = 0.9
        }
    }
    @IBOutlet weak var massageDataOutlet: UILabel!
    @IBOutlet weak var numebrOfMassagesView: UIView!{
        didSet{
            numebrOfMassagesView.layer.cornerRadius = numebrOfMassagesView.frame.height / 2
        }
    }
    @IBOutlet weak var numberOfMassages: UILabel!
    
    
    
    //MARK: - Constant

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - IBAction

    
    
    //MARK: - HelperFunctions
     func configure(chatRoom : ChatRoom){
        userNameOutlet.text = chatRoom.receiverName
        lastMassageOutlet.text = chatRoom.lastMassage
        if chatRoom.unreadCounter > 0 {
            numebrOfMassagesView.isHidden = false
            numberOfMassages.isHidden = false
            numberOfMassages.text = "\(chatRoom.unreadCounter)"
        }else{
            numebrOfMassagesView.isHidden = true
            numberOfMassages.isHidden = true
        }
        if chatRoom.avatarink != ""{
            FileStorage.downloadImage(imageURL: chatRoom.avatarink) {image in
                self.avatarImageOutlet.image = image?.circleMasked
            }
        }else{
            self.avatarImageOutlet.image = UIImage(named: "avatar")
        }
        // if you dont find the date but the date of this day from phone
        massageDataOutlet.text = timeElapsed(chatRoom.date ?? Date())
        
    }
    
    
    
}

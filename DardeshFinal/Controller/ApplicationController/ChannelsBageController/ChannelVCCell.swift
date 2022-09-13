//
//  ChannelVCCell.swift
//  DardeshFinal
//
//  Created by MacOS on 14/06/2022.
//

import UIKit
import Firebase

class ChannelVCCell: UITableViewCell {

    //MARK: - IBOutlet

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var aboutChannel: UILabel!
    @IBOutlet weak var members: UILabel!
    @IBOutlet weak var messageTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = .disclosureIndicator
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - HelperFunctions
    func configure(channel : Channel){
        channelName.text = channel.name
        aboutChannel.text = channel.aboutChannel
        members.text = "\(channel.memberIds.count) members"
        messageTime.text = timeElapsed(channel.lastMessageDate ?? Date())
        
        if channel.avatarLink != ""{
            FileStorage.downloadImage(imageURL: channel.avatarLink) { image in
                DispatchQueue.main.async {
                    self.avatarImage.image = image != nil ? image?.circleMasked : UIImage(named: "avatar")
                }
            }
        }else{
            avatarImage.image = UIImage(named: "avatar")
        }
    }
    
    
}

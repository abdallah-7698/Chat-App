//
//  FollowChannelCell1.swift
//  DardeshFinal
//
//  Created by MacOS on 16/06/2022.
//

import UIKit

class FollowChannelCell1: UITableViewCell {

    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var channelName: UILabel!
    
    @IBOutlet weak var members: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

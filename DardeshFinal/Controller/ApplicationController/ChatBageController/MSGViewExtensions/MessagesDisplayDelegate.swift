// height for cell

import UIKit
import MessageKit


extension MSGViewController : MessagesDisplayDelegate{
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return .label
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        // this func get UIColor so you must get the color from the system as UIColor
        let bubbleColorOutgoing = UIColor(named: "colorOutGoing")
        let bubbleColorInComing = UIColor(named : "colorIncomming")
        return isFromCurrentSender(message: message) ? bubbleColorOutgoing as! UIColor : bubbleColorInComing as! UIColor
    }
    
    //MARK: - make message tail // bobble

    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let tail : MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(tail, .curved)
    }
    
}


// Channel

extension ChannelMSGVC : MessagesDisplayDelegate{
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return .label
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        // this func get UIColor so you must get the color from the system as UIColor
        let bubbleColorOutgoing = UIColor(named: "colorOutGoing")
        let bubbleColorInComing = UIColor(named : "colorIncomming")
        return isFromCurrentSender(message: message) ? bubbleColorOutgoing as! UIColor : bubbleColorInComing as! UIColor
    }
    
    //MARK: - make message tail // bobble

    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let tail : MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(tail, .curved)
    }
    
}

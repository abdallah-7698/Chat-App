// color for cell
import UIKit
import MessageKit

extension MSGViewController : MessagesLayoutDelegate {
   
    //MARK: - Cell top lable height
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.section % 3 == 0 {
            if (indexPath.section == 0) && (allLocalMessages.count > displayMessageCount){
                return 40
            }
            
        }
        return 10.0
    }
    
    //MARK: - Cell buttom lable height

    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
       // it will but the height on all the messages not only the last one
        return isFromCurrentSender(message: message) ? 17 : 0
    }
    
    //MARK: - message buttom lable height

    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return indexPath.section != mkMessages.count-1 ? 10 : 0
    }
    
    //MARK: - Avatar initials
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
       // we will not use the image ??? ---> i think because you will get the image from storage
    /// but the image not the avatar
        avatarView.set(avatar: Avatar(initials: mkMessages[indexPath.section].senderInitial))
    }

    
}


//Channel
extension ChannelMSGVC : MessagesLayoutDelegate {
   
    //MARK: - Cell top lable height
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.section % 3 == 0 {
            if (indexPath.section == 0) && (allLocalMessages.count > displayMessageCount){
                return 40
            }
            
        }
        return 10.0
    }
    
    //MARK: - Cell buttom lable height
//
//    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//       // it will but the height on all the messages not only the last one
//        return isFromCurrentSender(message: message) ? 17 : 0
//    }
    
    //MARK: - message buttom lable height

    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 10 
    }
    
    //MARK: - Avatar initials
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
       // we will not use the image ??? ---> i think because you will get the image from storage
    /// but the image not the avatar
        avatarView.set(avatar: Avatar(initials: mkMessages[indexPath.section].senderInitial))
    }

    
}


// prepare the table view  message and but the data from the view

import UIKit
import MessageKit


extension MSGViewController : MessagesDataSource{
    
    //MARK: - Constant

    
    
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return mkMessages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return mkMessages.count
    }
    
    //MARK: - cell top lable
    //MARK: - The value will Change Later to the different date on the day
    // this func will not appere nuless you give the top lable height from messageLayoutDelegates
    // the attributed -- >> it have a spicial attriputes like color or other things
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
       
//        var smallerDate : Date
//        if indexPath.section == 0{
//            smallerDate = mkMessages[indexPath.section].sentDate.tooLongDate().getDate()!
//        }else{
//            smallerDate = mkMessages[indexPath.section - 1].sentDate.tooLongDate().getDate()!
//        }
//        let biggerDate  = mkMessages[indexPath.section ].sentDate.tooLongDate().getDate()!
//        if smallerDate.distance(from: biggerDate, only: .day) >= 1{
//            let showLoadMore = false
//            let text = showLoadMore ? "pull to load more" : MessageKitDateFormatter.shared.string(from: message.sentDate)
//            let font = showLoadMore ? UIFont.systemFont(ofSize: 13) : UIFont.boldSystemFont(ofSize: 10)
//            let color = showLoadMore ? UIColor.systemBlue : UIColor.darkGray
//
//            // now we can return attriputed string with this changes
//            return NSAttributedString(string: text, attributes: [.font : font , .foregroundColor : color])
//        }

            if indexPath.section % 3 == 0 {
         //the show more is the limit of the showing messages and if you want to show mare make it true and it will show mroe messages
                let showLoadMore = (indexPath.section == 0) && (allLocalMessages.count > displayMessageCount)
            let text = showLoadMore ? "pull to load more" : MessageKitDateFormatter.shared.string(from: message.sentDate)
            let font = showLoadMore ? UIFont.systemFont(ofSize: 13) : UIFont.boldSystemFont(ofSize: 10)
            let color = showLoadMore ? UIColor.systemBlue : UIColor.darkGray

            // now we can return attriputed string with this changes
            return NSAttributedString(string: text, attributes: [.font : font , .foregroundColor : color])
        }
        return nil
    }
    
    //MARK: - Cell Button lable
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        // this func (isFromCurrentSender) inside the message kit
        // message is the func message (the loop on each message)
        if isFromCurrentSender(message: message){
            let message = mkMessages[indexPath.section]
            // if it is the last message but the date now --> the sent date
            let status = indexPath.section == mkMessages.count - 1 ? message.status+" "+message.readDate.time() : ""
            
            let font = UIFont.boldSystemFont(ofSize: 10)
            let color = UIColor.darkGray
            return NSAttributedString(string : status , attributes: [.font : font , .foregroundColor : color])
        }
        return nil
    }
    
    //MARK: - Message button Lable
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        // not the last message
        if indexPath.section != mkMessages.count-1 {
          
            let font = UIFont.boldSystemFont(ofSize: 10)
            let color = UIColor.darkGray
            
            // we but the sent date 
            return NSAttributedString(string: message.sentDate.time() , attributes: [.font : font , .foregroundColor : color])
        }
        return nil
    }
    
}


// Channel
extension ChannelMSGVC : MessagesDataSource{
    
    //MARK: - Constant

    
    
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return mkMessages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return mkMessages.count
    }
    
    //MARK: - cell top lable
    //MARK: - The value will Change Later to the different date on the day
    // this func will not appere nuless you give the top lable height from messageLayoutDelegates
    // the attributed -- >> it have a spicial attriputes like color or other things
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
       
//        var smallerDate : Date
//        if indexPath.section == 0{
//            smallerDate = mkMessages[indexPath.section].sentDate.tooLongDate().getDate()!
//        }else{
//            smallerDate = mkMessages[indexPath.section - 1].sentDate.tooLongDate().getDate()!
//        }
//        let biggerDate  = mkMessages[indexPath.section ].sentDate.tooLongDate().getDate()!
//        if smallerDate.distance(from: biggerDate, only: .day) >= 1{
//            let showLoadMore = false
//            let text = showLoadMore ? "pull to load more" : MessageKitDateFormatter.shared.string(from: message.sentDate)
//            let font = showLoadMore ? UIFont.systemFont(ofSize: 13) : UIFont.boldSystemFont(ofSize: 10)
//            let color = showLoadMore ? UIColor.systemBlue : UIColor.darkGray
//
//            // now we can return attriputed string with this changes
//            return NSAttributedString(string: text, attributes: [.font : font , .foregroundColor : color])
//        }

            if indexPath.section % 3 == 0 {
         //the show more is the limit of the showing messages and if you want to show mare make it true and it will show mroe messages
                let showLoadMore = (indexPath.section == 0) && (allLocalMessages.count > displayMessageCount)
            let text = showLoadMore ? "pull to load more" : MessageKitDateFormatter.shared.string(from: message.sentDate)
            let font = showLoadMore ? UIFont.systemFont(ofSize: 13) : UIFont.boldSystemFont(ofSize: 10)
            let color = showLoadMore ? UIColor.systemBlue : UIColor.darkGray

            // now we can return attriputed string with this changes
            return NSAttributedString(string: text, attributes: [.font : font , .foregroundColor : color])
        }
        return nil
    }
    
    //MARK: - Cell Button lable
//    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//        // this func (isFromCurrentSender) inside the message kit
//        // message is the func message (the loop on each message)
//        if isFromCurrentSender(message: message){
//            let message = mkMessages[indexPath.section]
//            // if it is the last message but the date now --> the sent date
//            let status = indexPath.section == mkMessages.count - 1 ? message.status+" "+message.readDate.time() : ""
//
//            let font = UIFont.boldSystemFont(ofSize: 10)
//            let color = UIColor.darkGray
//            return NSAttributedString(string : status , attributes: [.font : font , .foregroundColor : color])
//        }
//        return nil
//    }
    
    //MARK: - Message button Lable
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        // not the last message
     
          
            let font = UIFont.boldSystemFont(ofSize: 10)
            let color = UIColor.darkGray
            
            // we but the sent date
            return NSAttributedString(string: message.sentDate.time() , attributes: [.font : font , .foregroundColor : color])
    
    }
    
}

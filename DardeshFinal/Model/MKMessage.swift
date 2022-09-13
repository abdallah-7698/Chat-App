
import UIKit
import MessageKit
import CoreLocation


class MKMessage : NSObject, MessageType {
    
    
    
    var messageId: String
    var kind: MessageKind
    var sentDate: Date
    var mkSender : MKSender
    // to tell it get the value from the return of this var ------> I think
    var sender: SenderType {return mkSender}
    // if no avatar show the letters
    var senderInitial : String
    
    // to hold the image we want to sent (not all messages is photos so make it optional)
    var photoItem : PhotoMessage?
    var videoItem : VideoMessage?
    var locationItem : LocationItem?
    var audioItem : AudioMessage?
    
    var status : String
    var readDate : Date
    // to determine if send or receve
    var incoming : Bool
    
    init (message : LocalMessage){
        self.messageId = message.id
        self.mkSender = MKSender(senderId: message.senderId, displayName: message.senderName)
       
        self.status = message.status
        // he gets the kind by his own
        self.kind = MessageKind.text(message.message)
        
        switch message.type{
        case kTEXT :
            self.kind = MessageKind.text(message.message)
        case kPHOTO:
            let photoItem = PhotoMessage(path: message.pictureUrl)
            self.kind = MessageKind.photo(photoItem)
            // to get it out of the init
            self.photoItem = photoItem
        case kVIDEO:
            // why it is nil at the begining
            let videoItem = VideoMessage(url: nil)
            self.kind = MessageKind.video(videoItem)
            // to get it out of the init
            self.videoItem = videoItem
        case kLOCATION:
            // we get the coordinate from the message
            let locationItem = LocationMessage(location: CLLocation(latitude: message.latitude, longitude: message.longitude))
            self.kind = MessageKind.location(locationItem)
            self.locationItem = locationItem
        case kAUDIO:
            // 2.0 tell we pass the value
            let audioItem = AudioMessage(duration: 2.0)
            self.kind = MessageKind.audio(audioItem)
            self.audioItem = audioItem
        default:
            self.kind = MessageKind.text(message.message)
            print("unknown error")
        }
        
        self.senderInitial = message.senderIntials
        self.sentDate = message.date
        self.readDate = message.readDate
        // be sure that iam a sender or not if the condition is false you are the recever---> because mksender saved on the message data
        //false it is outgoign
        // dont under stand ???????????????????????
        self.incoming = User.currentID != mkSender.senderId
    }
}



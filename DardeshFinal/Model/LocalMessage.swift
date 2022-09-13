

import Foundation
import RealmSwift

// the object for realm and codable for JSON
//the primary key for the realm not in all classes for connect more than one table
class LocalMessage : Object , Codable{
    
    @objc dynamic var id = ""
    @objc dynamic var chatRoomId = ""
    @objc dynamic var date = Date()
    @objc dynamic var senderName = ""
    @objc dynamic var senderId = ""
    @objc dynamic var senderIntials = ""
    @objc dynamic var readDate = Date()
    @objc dynamic var type = ""
    @objc dynamic var status = ""
    // the text kind of the message 
    @objc dynamic var message = ""
    @objc dynamic var audioUrl = ""
    @objc dynamic var videoUrl = ""
    @objc dynamic var pictureUrl = ""
    // for location but why float it mmust be location
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    @objc dynamic var audioDuration = 0.0
    
    override class func primaryKey() -> String? {
        return "id"
    }
   
}




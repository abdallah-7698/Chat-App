

import Foundation
import FirebaseFirestoreSwift

struct ChatRoom : Codable {
    var id = ""
    var chatRoomId = ""
    var senderId = ""
    var senderName = ""
    var receiverId = ""
    var receiverName = ""
    // if the user doesn't give a date the firebase server does --> FirebaseFirestoreSwift
    // don't understant %100 ????????
    @ServerTimestamp var date = Date()
    // why do you want the member ids if you got the poth ids ????
    var memberIds = [""]
    var lastMassage = ""
    var unreadCounter = 0
    var avatarink = ""
}

// make the time now ot minuts or hours or gust the date
//call this func with the date valoe is the parameter
func timeElapsed(_ date : Date) -> String {
    let seconds = date.timeIntervalSince(date)
    var elapsed = ""
    if seconds < 60{
       elapsed = "Just Now"
    }else if seconds < 60 * 60{
        let minutes = Int(seconds/60)
        let minText = minutes > 1 ? "mins" : "mins"
        elapsed = "\(minutes) \(minText)"
    }else if seconds < 60*60*24 {
       let hours = Int(seconds / 60*60)
       let hourText = hours > 1 ? "hour" : "hours"
        elapsed = "\(hours) \(hourText)"
    }else{
        elapsed = "\(date.longDate())"
    }
    return elapsed
}

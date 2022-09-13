/*    To send the message
 1- crearte the locall Message
 2- Check the type of the message
 3- save the message locally
 4- save the message on the Firestore
 */

// when you send the message you create one and save it and when you want it get it from (storage)

import UIKit
import FirebaseFirestoreSwift
import Gallery

class Outgoing{
    
    class func sendMessage(chatId : String , text : String? , photo : UIImage? , video : Video? , audio : String? , audioDuration : Float = 0.0 , location : String? , memberIds : [String]){
    // 1- crearte the locall Message
        let currentUser = User.currentUser!
        
        let message = LocalMessage()
        message.id = UUID().uuidString
        message.chatRoomId = chatId
        message.senderId = currentUser.id
        message.senderName = currentUser.username
        message.senderIntials = String(currentUser.username.first!)
        message.date = Date()
        message.status = kSent
      // when you make send message you get the information from the info about users but only you don't know the message content or the type
        //so we check the type and then saved
        // what is memberIDS ?????????
    // 2- Check the type of the message
        if text != nil{
            sendText(message : message , text : text! , memberIds : memberIds)
        }
        if photo != nil{
            sendPhoto(message: message, photo: photo!, memberIds: memberIds)
        }
        if video != nil{
            sendVideo(message: message, video: video!, memberIds: memberIds)
        }
        if location != nil{
            sendLocation(message: message, memberIds: memberIds)
        }
        if audio != nil{
          sendAudio(message: message, audioFileName: audio!, audioDuration: audioDuration, memberIds: memberIds)
        }
    
        /// send push notification
        // update the message
        FChatRoomListner.shared.updateChatRooms(chatRoomId: chatId, lastMessage: message.message)
    }
    
    
    //MARK: - send Channel Message
    class func sendChannelMessage(channel : Channel , text : String? , photo : UIImage? , video : Video? , audio : String? , audioDuration : Float = 0.0 , location : String? ){
    // 1- crearte the locall Message
        let currentUser = User.currentUser!
        // the barameter is constant so we make var
        var channel = channel
        let message = LocalMessage()
        message.id = UUID().uuidString
        message.chatRoomId = channel.id
        message.senderId = currentUser.id
        message.senderName = currentUser.username
        message.senderIntials = String(currentUser.username.first!)
        message.date = Date()
        message.status = kSent
      // when you make send message you get the information from the info about users but only you don't know the message content or the type
        //so we check the type and then saved
        // what is memberIDS ?????????
    // 2- Check the type of the message
        if text != nil{
            sendText(message : message , text : text! , memberIds : channel.memberIds , channel : channel)
        }
        if photo != nil{
            sendPhoto(message: message, photo: photo!, memberIds: channel.memberIds , channel : channel)
        }
        if video != nil{
            sendVideo(message: message, video: video!, memberIds: channel.memberIds , channel : channel)
        }
        if location != nil{
            sendLocation(message: message, memberIds: channel.memberIds , channel : channel)
        }
        if audio != nil{
          sendAudio(message: message, audioFileName: audio!, audioDuration: audioDuration, memberIds: channel.memberIds , channel : channel)
        }
    
        /// send push notification
        // update the channel and date
        channel.lastMessageDate = Date()
        FChannelListener.shared.saveChannel(channel)
        
    }

    // 3- save the message locally to all kinds
    // 4- save the message on the Firestore to all kinds
      
    class func saveMessage(message : LocalMessage ,memberIds : [String]){
        RealmManager.shared.save(message)
        for memberId in memberIds {
            // save the message on th efireStore with the file name memberid
            FMessageListener.shared.addMessage(message, memberId: memberId)
        }
    }

    class func saveChannelMessage(message : LocalMessage ,channel : Channel){
        RealmManager.shared.save(message)
            FMessageListener.shared.addChannelMessage(message, channel: channel)
    }
    
}
// only for the text (each type has it's own func)
func sendText(message : LocalMessage , text : String , memberIds : [String] , channel : Channel? = nil){
    message.message = text
    message.type = kTEXT
    
    if channel != nil{
        Outgoing.saveChannelMessage(message: message, channel: channel!)
    }else{
    Outgoing.saveMessage(message: message, memberIds: memberIds)
    }
}

func sendPhoto(message : LocalMessage , photo : UIImage , memberIds : [String],channel : Channel? = nil){
    message.message = "Photo Message"
    message.type = kPHOTO
    // when we upload the image to the filre store we get the url that we connect the photo by
    // we want the name of the file to be unique
    let fileName = Date().stringDate()
    let fileDirectory = "MediaMessages/Photo/" + "\(message.chatRoomId)" + "\(fileName)" + ".jpg"
    // to save the image reduce the quality means less space and it must by NSDATA
    FileStorage.saveFileLocally(fileData: photo.jpegData(compressionQuality: 0.6)! as NSData, fileName: fileDirectory)
    FileStorage.UploadImage(photo, directory: fileDirectory) { imageURL in
        if imageURL != nil {
            message.pictureUrl = imageURL!
            if channel != nil{
                Outgoing.saveChannelMessage(message: message, channel: channel!)
            }else{
            Outgoing.saveMessage(message: message, memberIds: memberIds)
            }
        }
    }
}

func sendVideo(message : LocalMessage , video : Video , memberIds : [String],channel : Channel? = nil){
    message.message = "Video Message"
    message.type = kVIDEO
    let fileName = Date().stringDate()
    // we want two directories (for thumbnail) and (for video)
    let thumbnailDirectory = "MediaMessages/Photo/" + "\(message.chatRoomId)" + "\(fileName)" + ".jpg"
    let videoDirectory = "MediaMessages/Video/" + "\(message.chatRoomId)" + "\(fileName)" + ".mov"
// to get the sumbnail from the Video
   // var from the gullary to make process on video (to get the url)
    let editor = VideoEditor()
    editor.process(video: video) { processedVide, videoURL in
        if let tempPath = videoURL {
            let thumbnail = videoThumbnail(videoURL: tempPath)
            FileStorage.saveFileLocally(fileData: thumbnail.jpegData(compressionQuality: 0.7)! as NSData, fileName: fileName)
            FileStorage.UploadImage(thumbnail, directory: thumbnailDirectory) { imageLink in
                if imageLink != nil {
                    let videoData = NSData(contentsOfFile: tempPath.path)
                    FileStorage.saveFileLocally(fileData: videoData!, fileName: fileName + ".mov")
                    FileStorage.UploadVideo(videoData!, directory: videoDirectory) { videoLink in
                        message.videoUrl = videoLink ?? ""
                        message.pictureUrl = imageLink ?? ""
                        // you must make save afetr make any changes on message
                        if channel != nil{
                            Outgoing.saveChannelMessage(message: message, channel: channel!)
                        }else{
                            Outgoing.saveMessage(message: message, memberIds: memberIds)
                        }
                    }
                }
            }
        }
    }
}

func sendLocation(message : LocalMessage , memberIds : [String] , channel : Channel? = nil){
    let currentLocation = LocationManager.shard.currentLocation
    message.message = "Location Message"
    message.type = kLOCATION
    message.latitude = currentLocation?.latitude ?? 0
    message.longitude = currentLocation?.longitude ?? 0
    if channel != nil{
        Outgoing.saveChannelMessage(message: message, channel: channel!)
    }else{
    Outgoing.saveMessage(message: message, memberIds: memberIds)
    }
    
}

func sendAudio(message : LocalMessage , audioFileName : String , audioDuration : Float , memberIds : [String] , channel : Channel? = nil){
    message.message = "Audio Message"
    message.type = kAUDIO
    let fileDirectory = "MediaMessages/audio/" + "\(message.chatRoomId)" + "\(audioFileName)" + ".m4a"
    FileStorage.UploadAudio(audioFileName, directory: fileDirectory) { audioLink in
        if audioLink != nil{
            message.audioUrl = audioLink ?? ""
            message.audioDuration = Double(audioDuration)
            if channel != nil{
                Outgoing.saveChannelMessage(message: message, channel: channel!)
            }else{
            Outgoing.saveMessage(message: message, memberIds: memberIds)
            }
        }
    }
}

import Foundation
import MessageKit
import CoreLocation
// what is the Local message and wht is the MKMessage

class Incoming{
    /*
     Take the ViewController from type MessagesViewController on defing
     create the MKMessage message from MKMessage
     // When we make init to the MKMessage it init with local message so it will crete by it self
     */
    var messageViewController : MessagesViewController
    init(messageViewController : MessagesViewController){
        self.messageViewController = messageViewController
    }
    
    // take a localMessage  and make it mkMessage by taking info from it
    // the info comes when we declear the local message
    // we read the data from realmDB and get the local message then convet it into a MKMessage
    // by convert it to mkMessage i can show it on the MessagesViewController
    func createMKMessage(localMessage : LocalMessage) -> MKMessage{
        
        let mkMessage = MKMessage(message: localMessage)

        if localMessage.type == kPHOTO{
            let photoItem = PhotoMessage(path: localMessage.pictureUrl)
            mkMessage.photoItem = photoItem
            mkMessage.kind = MessageKind.photo(photoItem)
            
            // download the photo
            FileStorage.downloadImage(imageURL: localMessage.pictureUrl) { image in
                mkMessage.photoItem?.image = image
                self.messageViewController.messagesCollectionView.reloadData()
            }
        }
        
        if localMessage.type == kVIDEO {
            FileStorage.downloadImage(imageURL: localMessage.pictureUrl) { thumbnail in
                FileStorage.downloadVideo(videoURL: localMessage.videoUrl) { readyToPlay, fileName in
                    let videoLink = URL(fileURLWithPath: fileInDocumentDirectory(fileName: fileName))
                    let videoItem = VideoMessage(url: videoLink)
                    mkMessage.videoItem = videoItem
                    mkMessage.kind = MessageKind.video(videoItem)
                    mkMessage.videoItem?.image = thumbnail
                    self.messageViewController.messagesCollectionView.reloadData()
                }
            }
        }
        
        if localMessage.type == kLOCATION {
            let locationItem = LocationMessage(location: CLLocation(latitude: localMessage.latitude, longitude: localMessage.longitude))
            mkMessage.kind = MessageKind.location(locationItem)
            mkMessage.locationItem = locationItem
        }
        
        if localMessage.type == kAUDIO{
            let audioMessage = AudioMessage(duration: Float(localMessage.audioDuration))
            mkMessage.audioItem = audioMessage
            mkMessage.kind = MessageKind.audio(audioMessage)
            FileStorage.downloadaudio(audioUrl: localMessage.audioUrl) { fileName in
                let audioUrl = URL(fileURLWithPath: fileInDocumentDirectory(fileName: fileName))
                mkMessage.audioItem?.url = audioUrl
            }
            self.messageViewController.messagesCollectionView.reloadData()
        }
        
        return mkMessage
    }
    
    
    
    
}














// the selection of the cell tap select on the message

import Foundation
import MessageKit
import AVKit
import AVFoundation
import SKPhotoBrowser


extension MSGViewController :  MessageCellDelegate{
    func didTapImage(in cell: MessageCollectionViewCell) {
        // when you tap at the image get the index
        if let indexPath = messagesCollectionView.indexPath(for: cell){
            let mkMessage = mkMessages[indexPath.section]
            // the image is here and the item is here ??????
            if mkMessage.photoItem != nil && mkMessage.photoItem?.image != nil{
                // when you press on the image
                //SKPhoto to show the image on full of the screen with some special buttons
                var images = [SKPhoto]()
                var photo = SKPhoto.photoWithImage(mkMessage.photoItem!.image!)
                images.append(photo)
                let browser = SKPhotoBrowser(photos: images)
                present(browser, animated: true, completion: nil)
            }
            
            if mkMessage.videoItem != nil && mkMessage.videoItem!.url != nil{
                // when you press on the video
                // to play the video you have to got player controller and player
                // the player controller make play
                let playerController = AVPlayerViewController()
                let player = AVPlayer(url: mkMessage.videoItem!.url!)
                // add the player to playerController
                playerController.player = player
                // we have to make section to the audio and make it work on the speaker
                let section = AVAudioSession.sharedInstance()
                try! section.setCategory(.playAndRecord , mode : .default , options: .defaultToSpeaker)
                present(playerController, animated: true) {
                    // on click go and play
                    playerController.player!.play()
                }
            }
        }
    }
    // if you click on any type of messages
    func didTapMessage(in cell: MessageCollectionViewCell) {
        if let indexPath = messagesCollectionView.indexPath(for: cell){
            let mkMessage = mkMessages[indexPath.section]
            if mkMessage.locationItem != nil {
                let mapView = MapVC()
                mapView.location = mkMessage.locationItem?.location
                self.navigationController?.pushViewController(mapView, animated: true)
            }
        }
    }
    
    // to play the audio message this func is called when you tap the play button on audio
    func didTapPlayButton(in cell: AudioMessageCell) {
            guard let indexPath = messagesCollectionView.indexPath(for: cell),
                let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
                    print("Failed to identify message when audio cell receive tap gesture")
                    return
            }
            guard audioController.state != .stopped else {
                // There is no audio sound playing - prepare to start playing for given audio message
                audioController.playSound(for: message, in: cell)
                return
            }
            if audioController.playingMessage?.messageId == message.messageId {
                // tap occur in the current cell that is playing audio sound
                if audioController.state == .playing {
                    audioController.pauseSound(for: message, in: cell)
                } else {
                    audioController.resumeSound()
                }
            } else {
                // tap occur in a difference cell that the one is currently playing sound. First stop currently playing and start the sound for given message
                audioController.stopAnyOngoingPlaying()
                audioController.playSound(for: message, in: cell)
            }
        }
    
}

// Channel

extension ChannelMSGVC :  MessageCellDelegate{
    func didTapImage(in cell: MessageCollectionViewCell) {
        // when you tap at the image get the index
        if let indexPath = messagesCollectionView.indexPath(for: cell){
            let mkMessage = mkMessages[indexPath.section]
            // the image is here and the item is here ??????
            if mkMessage.photoItem != nil && mkMessage.photoItem?.image != nil{
                // when you press on the image
                //SKPhoto to show the image on full of the screen with some special buttons
                var images = [SKPhoto]()
                var photo = SKPhoto.photoWithImage(mkMessage.photoItem!.image!)
                images.append(photo)
                let browser = SKPhotoBrowser(photos: images)
                present(browser, animated: true, completion: nil)
            }
            
            if mkMessage.videoItem != nil && mkMessage.videoItem!.url != nil{
                // when you press on the video
                // to play the video you have to got player controller and player
                // the player controller make play
                let playerController = AVPlayerViewController()
                let player = AVPlayer(url: mkMessage.videoItem!.url!)
                // add the player to playerController
                playerController.player = player
                // we have to make section to the audio and make it work on the speaker
                let section = AVAudioSession.sharedInstance()
                try! section.setCategory(.playAndRecord , mode : .default , options: .defaultToSpeaker)
                present(playerController, animated: true) {
                    // on click go and play
                    playerController.player!.play()
                }
            }
        }
    }
    // if you click on any type of messages
    func didTapMessage(in cell: MessageCollectionViewCell) {
        if let indexPath = messagesCollectionView.indexPath(for: cell){
            let mkMessage = mkMessages[indexPath.section]
            if mkMessage.locationItem != nil {
                let mapView = MapVC()
                mapView.location = mkMessage.locationItem?.location
                self.navigationController?.pushViewController(mapView, animated: true)
            }
        }
    }
    
    // to play the audio message this func is called when you tap the play button on audio
    func didTapPlayButton(in cell: AudioMessageCell) {
            guard let indexPath = messagesCollectionView.indexPath(for: cell),
                let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
                    print("Failed to identify message when audio cell receive tap gesture")
                    return
            }
            guard audioController.state != .stopped else {
                // There is no audio sound playing - prepare to start playing for given audio message
                audioController.playSound(for: message, in: cell)
                return
            }
            if audioController.playingMessage?.messageId == message.messageId {
                // tap occur in the current cell that is playing audio sound
                if audioController.state == .playing {
                    audioController.pauseSound(for: message, in: cell)
                } else {
                    audioController.resumeSound()
                }
            } else {
                // tap occur in a difference cell that the one is currently playing sound. First stop currently playing and start the sound for given message
                audioController.stopAnyOngoingPlaying()
                audioController.playSound(for: message, in: cell)
            }
        }
    
}


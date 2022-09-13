// reed message from the input bar

import Foundation
import InputBarAccessoryView



extension MSGViewController : InputBarAccessoryViewDelegate {
    // when you start typing
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
      // make the mike appear when the text == "" other case make it send
        updateMicButtonStatus(show : text == "")
        
        // if he start to typing make the make the var isTyping true and if stop make it false
        if text != nil{
            startTypingIndecator()
        }
    }
    
    // when you sent
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
       
        send(text: text, photo: nil, video: nil, location: nil, audio: nil)
        messageInputBar.inputTextView.text = ""
        // hide the keyboard
        messageInputBar.invalidatePlugins()
    }
}


// Channel
extension ChannelMSGVC : InputBarAccessoryViewDelegate {
    // when you start typing
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
      // make the mike appear when the text == "" other case make it send
        updateMicButtonStatus(show : text == "")
        
        // if he start to typing make the make the var isTyping true and if stop make it false
//        if text != nil{
//            startTypingIndecator()
//        }
    }
    
    // when you sent
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
       
        send(text: text, photo: nil, video: nil, location: nil, audio: nil)
        messageInputBar.inputTextView.text = ""
        // hide the keyboard
        messageInputBar.invalidatePlugins()
    }
}

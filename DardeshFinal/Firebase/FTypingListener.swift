
import Foundation
import Firebase

class FTypingListener{
    
    static let shared = FTypingListener()
    
    var typingListener : ListenerRegistration!
    
    private init() {}
    
   // listen to the data
    func createTypingObserver (chatRoomId : String, completion : @escaping(_ isTyping : Bool)-> Void){
        typingListener =  FirestoreReference(.Typing).document(chatRoomId).addSnapshotListener({ documentSnapshot, error in
            guard let snapshot = documentSnapshot else {return}
            if snapshot.exists{
                for data in snapshot.data()!{
                    // not your state but the other one
                    if data.key != User.currentID {
                        completion(data.value as! Bool)
                    }
                }
            }else{
                completion(false)
                // make the indecatoer
                // if the data dont exist ????????
                FirestoreReference(.Typing).document(chatRoomId).setData([User.currentID : false])
            }
        })
    }
    
    // save the data on one file to you and other users
    class func saveTypingCounter(typing : Bool , chatRoomId : String){
        FirestoreReference(.Typing).document(chatRoomId).updateData([User.currentID : typing])
    }
    // remove the listener
    func removeTypingListener(){
        self.typingListener.remove()
    }
    
}

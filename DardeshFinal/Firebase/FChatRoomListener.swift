/*
 what we make the func we only make the templet to the func not the func so we can use it alot more
 EX ->
 if you want to make func to get the sum make the func reusable so if in time if you have two numbers you can use this func
 */


import Foundation
import Firebase


class FChatRoomListner {
    
    static let shared = FChatRoomListner()
    private init (){}
    
   // make it id not ChatRoomID ---> Chatroom if is the same
    
    //MARK: - save ChatRoom to fireStore

    func saveChatRoom(_ chatRoom : ChatRoom){
        do {
            try FirestoreReference(.Chat).document(chatRoom.id).setData(from: chatRoom)
        }catch{
            print ("not able to save document : " , error)
        }
        
        
    }
    
    //MARK: - Download ChatRoom from fireStore
// all chat rooms ths the sender has
    func downloadChatRoom(complition : @escaping (_ allFBChatRooms : [ChatRoom])-> Void){
        // why in this case he use addSnapshotListener to listen to any changes happen on the database
        // but the listener take from the device resources so we must stop listener at some point
        FirestoreReference(.Chat).whereField(kSENDERID, isEqualTo: User.currentID).addSnapshotListener { snapshot, error in
            var chatRooms : [ChatRoom] = []
            guard let documents = snapshot?.documents else {
                print ("no documents Found")
                return
            }
            // if cussess
            let allFBChatRooms = documents.compactMap { snapshot -> ChatRoom? in
                return try? snapshot.data(as: ChatRoom.self)
            }
            // if you start chat and do not send any massage not make the chat room
            for chatRoom in allFBChatRooms{
                if chatRoom.lastMassage != ""{
                    chatRooms.append(chatRoom)
                }
            }
            chatRooms.sort(by: {$0.date! > $1.date!})
            complition(chatRooms)
            
        }
    }
    
    //MARK: - Deleting Func

    func deleteChatRoom(chatRoom : ChatRoom){
        // we cna make a complitio but not too much important
        FirestoreReference(.Chat).document(chatRoom.id).delete()
    }
    //MARK: - reset nuread counter
    // make clearto unread messages
    func clearUnreadCounter(chatRoom : ChatRoom){
        var newChatRoom = chatRoom
        newChatRoom.unreadCounter = 0
        self.saveChatRoom(newChatRoom)
    }
    
    // if you have only the chat room id get the chat room from the firebase
    // the path is (chat->chatid->sender or recever -> ids)
    func clearUnreadCounterUsingId(chatRoomId : String){
        FirestoreReference(.Chat).whereField(kCHATROOMID, isEqualTo: chatRoomId).whereField(kSENDERID, isEqualTo: User.currentID).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {return}
            let allChatRooms = documents.compactMap { snapshot -> ChatRoom? in
                return try? snapshot.data(as : ChatRoom.self)
            }
            if allChatRooms.count > 0{
                self.clearUnreadCounter(chatRoom: allChatRooms.first!)
            }
        }
    }

    
    //MARK: - Update Chat Rooms with new messages
    // add the counter with one and change the lastmessage and make the date now
    // but this func get only one chat room and we want to make the changes on the both chatRooms
    private func updateChatRoomWithNewMessage(chatRoom : ChatRoom , lastMessage : String){
        var tempChatRoom = chatRoom
        // we make this because we will call it on the next func
        if tempChatRoom.senderId != User.currentID{
            tempChatRoom.unreadCounter += 1
        }
        tempChatRoom.lastMassage = lastMessage
        tempChatRoom.date = Date()
        
        self.saveChatRoom(tempChatRoom)
    }
// update the chat room to the sender and the recever
// we get the chatroom with the id because the poth have the same id the sender and the recever
    func updateChatRooms(chatRoomId : String,lastMessage : String){
        FirestoreReference(.Chat).whereField(kCHATROOMID, isEqualTo: chatRoomId).getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents else{return}
            let allChatRooms = documents.compactMap { querySnapshot -> ChatRoom? in
                return try? querySnapshot.data(as: ChatRoom.self)
            }
            for chatRoom in allChatRooms {
                self.updateChatRoomWithNewMessage(chatRoom: chatRoom, lastMessage: lastMessage)
            }
        }
        
    }
    
}
 


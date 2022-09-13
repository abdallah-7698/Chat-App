/*    This File only contains the func that will Help us
 1- we want to make a ChatRoom object so we must make a ChatRoomId
 2- get the sender id and the receever id and the names
 3- Check that the name not have a Chat room before because if he has a Chat Room get it
 4- we make more than Chat room one for sender and one for recever
 5- if the sender have chatRoom dont make a new one just get the old one
 
 if ali chat anas the two have chatRoom if one delete the chat room when the other send him a massage the FireStore will not make ather ChatRoom for them but get the Chat room for him
 
 */


import Foundation
import Firebase
import MessageKit



func restartChat(ChatRoomId : String , memberIds : [String]){
    //download users useing memberIds
    FUserListener.shared.downloadUsersFromFireStore(WithIds: memberIds) { allUsers in
        if allUsers.count > 0{
            createChatRoom(chatRoomId: ChatRoomId, users: allUsers)
        }
    }
}

// how I can get the recever id from my app ????????

func startChat(sender : User , recever : User) -> String {
    var chatRoomId = ""
    // you compare two Strng Values
    let value = sender.id.compare(recever.id).rawValue
    chatRoomId = value > 0 ? (sender.id + recever.id) : (recever.id+sender.id)
    createChatRoom(chatRoomId : chatRoomId , users : [sender , recever])
    return chatRoomId
}

// create Chat room for each one of the users if the user have a Chat room remove him from array

///---------------------------------------------------------------------------------

// from where i get the data (where I call it) -->  we get sender and recever only


func createChatRoom(chatRoomId : String , users : [User]){
    
    var usersToCreateChatsFor:[String]
    usersToCreateChatsFor = []
    for user in users{
        usersToCreateChatsFor.append(user.id)
    }
    
    
    FirestoreReference(.Chat).whereField(kCHATROOMID,isEqualTo : chatRoomId).getDocuments { snapshot, error in
        guard let snapshot = snapshot else{return}
        // there is data comes from documents --> (the Chats)
        if !snapshot.isEmpty{
            for chatData in snapshot.documents{
                let currentChat = chatData.data() as Dictionary
                // if we poth has the chatRoom he will not create any one
                if let currentUserId = currentChat[kSENDERID]{
                    if usersToCreateChatsFor.contains(currentUserId as! String){
                        usersToCreateChatsFor.remove(at: usersToCreateChatsFor.firstIndex(of: currentUserId as! String)!)
                        
                    }
                }
            }
        }
  // get the users from the parameter so he has poth in all cases
        for userId in usersToCreateChatsFor{
            
            let senderUser = userId == User.currentID ? User.currentUser! : getReceverFrom(users: users)
            let receverUser = userId == User.currentID ? getReceverFrom(users: users) : User.currentUser!
            
            let chatRoomObject = ChatRoom(id: UUID().uuidString, chatRoomId: chatRoomId, senderId: senderUser.id, senderName: senderUser.username, receiverId: receverUser.id, receiverName: receverUser.username, date: Date(), memberIds: [senderUser.id , receverUser.id], lastMassage: "", unreadCounter: 0, avatarink: receverUser.avatarLink)
            
            FChatRoomListner.shared.saveChatRoom(chatRoomObject)
        }
        
    }
    
}
///---------------------------------------------------------------------------------

func getReceverFrom(users : [User]) -> User{
    var allUsers = users
    // you must use Equatable because this is used for array and User is object
    // go to the objects on the arrar and if the bject has this id remove it
    //Wht id ->>>>> the Equatable func
    allUsers.remove(at: allUsers.firstIndex(of: User.currentUser!)!)
    return allUsers.first!
}

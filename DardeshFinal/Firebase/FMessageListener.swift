//
//  FMessageListener.swift
//  DardeshFinal
//
//  Created by MacOS on 23/02/2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import Network

class FMessageListener{
    
    //MARK: - Constant
    static let shared = FMessageListener()
    
    // Listener on firebase that listen to any changes on the firebase
    var newMessageListener : ListenerRegistration!
    // listen for the update
    var updatedMessageListener : ListenerRegistration!
    
    
    private init(){}
    
    func addMessage(_ message : LocalMessage , memberId : String){
       //to get all messagess go to the message -> memberid -> chatroom and get all messages yours and your frind
        do {
            try FirestoreReference(.Message).document(memberId).collection(message.chatRoomId).document(message.id).setData(from: message)
        }catch{
            print (error.localizedDescription)
        }
        
    }
    
    //MARK: - send Channel Message
    
    func addChannelMessage(_ message : LocalMessage , channel : Channel){
       //to get all messagess go to the message -> memberid -> chatroom and get all messages yours and your frind
        do {
            try FirestoreReference(.Message).document(channel.id).collection(channel.id).document(message.id).setData(from: message)
        }catch{
            print (error.localizedDescription)
        }
        
    }
    

    //MARK: - Check for old Messages
    // when you make sign in get all messages from the server and but it on Realm Database
    // to read the messages we need the document id and collection id (the files we make on Firebase to save the data in)    document -> collection -> messages
    
    // get the document and turn it into Local message and then sort it by date and save it into Realm
    func checkForOldMessages(_ documentId : String , collectionId : String){
        FirestoreReference(.Message).document(documentId).collection(collectionId).getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents else{return}
            var oldMessages = documents.compactMap { querySnapshot -> LocalMessage? in
                return try? querySnapshot.data(as : LocalMessage.self)
            }
            oldMessages.sort(by: { $0.date < $1.date })
            for message in oldMessages{
                RealmManager.shared.save(message)
            }
        }
    }

    //MARK: - Listen to Any Change on the Message on the FireStore
    // we want the date of the Last message Date from Local Database so we can get the next messages from the FireStore if there is new messages and no internet
    // the thing that helps us is that the app save the message on a class
    // why we make addSnapshotListener if we made the var newMessageListener ??????
    func listenForNewMessage(_ documentId : String , collectionId : String ,_ lastMessageDate : Date){
        newMessageListener = FirestoreReference(.Message).document(documentId).collection(collectionId).whereField(kDATE, isGreaterThan: lastMessageDate).addSnapshotListener({ querySnapshot, error in
           // make sure that there is Messages (but it is a snapShat not a regular snapshat)
            guard let snapshot = querySnapshot else {return}
           // make the loop on changes for the file ???? why loop???
           // The snapShot on the document because any change will be on the document not the data inside
           // if you add new messages save the data on the local storage
           // we get the data by the snapShot but not the document but the only the one that has been changed
           // we get them and loop for each one (turn it into a Local message if success save it on Realm)
            for change in snapshot.documentChanges{
               
                if change.type == .added{
                    let result = Result{
                        try? change.document.data(as: LocalMessage.self)
                    }
                    switch result {
                    case .success(let messageObject):
                        // to be more sure that the object turn on the wright way
                        if let message = messageObject{
                            // my data on Realm and when i open it downloads but the other user make a changes and i don't know about it
                            if message.senderId != User.currentID{
                                RealmManager.shared.save(message)
                            }
                        }
                    case .failure (let error):
                        print(error.localizedDescription)
                    }
                }
                
                
            }
            
        })
    }
    
    //MARK: - Update Message Status
    // get the message that we will save the data in and the is that we will update the message to
    func updateMessageStatus(_ message : LocalMessage , userId : String){
        
        // this is the data we will change
        let values = [kSTATUS : kRead , kREADDATE : Date()] as [String : Any]
        // in this case he will not create but he will get them so when he create and when he get into ?????????????
        FirestoreReference(.Message).document(userId).collection(message.chatRoomId).document(message.id).updateData(values)
    }

    //MARK: - Listen For Read Status Update
    // it will return the updated message so we will use the complition to ?
    func ListenForReadStatus(_ documentId : String , collectionId : String , completion : @escaping(_ updatedMessage : LocalMessage)->Void){
      
        updatedMessageListener = FirestoreReference(.Message).document(documentId).collection(collectionId).addSnapshotListener({ querySnapshot, error in
            guard let snapshot = querySnapshot else{return}
            for change in snapshot.documentChanges {
              // if the data has been changed from the last func updateMessageStatus take it and return it
                if change.type == .modified{
                    let result = Result{
                        try? change.document.data(as: LocalMessage.self)
                    }
                    switch result {
                    case .success(let messageObject):
                        if let message = messageObject {
                          completion(message)
                        }
                    case .failure(let error):
                        print("error decoding : ", error.localizedDescription)
                    }
                }
            }
        })
    
    }

    
    
    func removeMessageListener(){
        self.newMessageListener.remove()
        if updatedMessageListener != nil{
            self.updatedMessageListener.remove()
        }
    }

    
}

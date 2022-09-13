//
//  FChannelListener.swift
//  DardeshFinal
//
//  Created by MacOS on 14/06/2022.
//

import Foundation
import Firebase

class FChannelListener{
    
    static let shared = FChannelListener()
    var userChannelListener : ListenerRegistration!
    var subscribedChannelListener : ListenerRegistration!
    private init() {}
    
    //MARK: - Add Channel
    
    func saveChannel (_ channel : Channel){
        do{
         try  FirestoreReference(.Channel).document(channel.id).setData(from: channel)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    //MARK: - Download Channels
    // we will make 3 func to dowmload the Channels
    func downloadUserChannel(complition : @escaping (_ userChannels : [Channel])-> Void){
        userChannelListener = FirestoreReference(.Channel).whereField(kADMINID, isEqualTo: User.currentID).addSnapshotListener({ querySnapshot, error in
            guard let documents = querySnapshot?.documents else{return}
            var userChannels = documents.compactMap { queryDocumentSnapshot -> Channel? in
                return try? queryDocumentSnapshot.data(as: Channel.self)
            }
            userChannels.sort(by: {$0.memberIds.count > $1.memberIds.count})
            complition(userChannels)
        })
        
    }
    
/// if there is any error this will be because i don't but (-> Channel?) in compact map
    
    func downloadSubscribedChannel(comlition : @escaping (_ subscribedChannels : [Channel])->Void){
        subscribedChannelListener = FirestoreReference(.Channel).whereField(kMEMBERIDS, arrayContains: User.currentID).addSnapshotListener({ querySnapshot, error in
            guard let documents = querySnapshot?.documents else{return}
            var subscribedChannels = documents.compactMap { queryDocumentSnapshot in
                return try? queryDocumentSnapshot.data(as: Channel.self)
            }
            subscribedChannels.sort(by: {$0.memberIds.count > $1.memberIds.count})
            comlition(subscribedChannels)
        })
    }
    
    //because we will get all data we dont have to make it on listener
    
    func downloadAllChannels(complition : @escaping (_ allChannels : [Channel])->Void){
        FirestoreReference(.Channel).getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents else{return}
            var allChannels = documents.compactMap { queryDocumentSnapshot  -> Channel? in
                return try?  queryDocumentSnapshot.data(as : Channel.self)
            }
            allChannels = self.removeUserChannel(allChannels)
            allChannels.sort(by: {$0.memberIds.count > $1.memberIds.count})
            complition(allChannels)
        }
    }
    
    //MARK: - HelperFunctions

    func removeUserChannel(_ allChannel : [Channel])->[Channel]{
        var newCannels : [Channel] = []
        
        for channel in allChannel {
            if !channel.memberIds.contains(User.currentID){
                newCannels.append(channel)
            }
        }
       return newCannels
    }
    
    
}

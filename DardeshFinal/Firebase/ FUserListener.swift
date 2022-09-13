
/*
 this is the file that read and wright from firebase
 this bitter because if you want to make any update you will make it from this file
 this file will be call on the login controller
 ** each  collection has it's class to make read and write
 */

import UIKit
import Firebase


class FUserListener {
    // make singlton that make you only have one object from this class
    static let shared = FUserListener()
    
    private init(){}
    
    
    /*
     1- sign in by your email if the email is found (no error will be found ) and it means that the user is found
     2- if you find the user download his information from the frieStore
     // download is done by creating a file on the firestore with the UserId
     // only save if the email is varified
     */
    //MARK: - Login
    func loginUserWith(email : String , password : String, complition : @escaping (_ error : Error? ,_ isEmailVerified : Bool)-> Void ){
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error == nil && authResult!.user.isEmailVerified == true{
                complition(error,true)
                self.downloadUserFromFirestore(userid : authResult!.user.uid)
            }else{
                complition(error,false)
            }
        }
    }
    
    //MARK: - download User From Firestore
    
    /*
     1- to get the data you must get the document name  so in the func we get the userid
     2- guard let to be sure that we have the data and it != nil
     3- then we convert the data from [key:Value] into object but we not sure that it will be convert
     ---> so we must make it on result
     ** if the result success make sure that it have the data and if so save it locally
     .success(the result of the try)
     .failure(error)
    --> but we must make it on let name
     */
    
     private func  downloadUserFromFirestore(userid : String){
        FirestoreReference(.User).document(userid).getDocument { document, error in
            guard let  userDocument = document else{
                print ("no data found")
                return
            }
            // here we know that we have the document
            // turn the document into Object by result
            let result = Result {
                try? userDocument.data(as: User.self)
            }
            switch result{
            case .success(let userObject):
                if let user = userObject{
                    saveUserLocally(user)
                }else{
                    print ("Document does not exist")
                }
            case .failure(let error):
                print("Error on reuturn the document into object" , error.localizedDescription)
            }
        }
    }
    
    
    // download user by id but here more than user
    func downloadUsersFromFireStore(WithIds : [String],complition:@escaping (_ allUsers : [User])->Void){
        var count = 0
        var usersArray : [User] = []
        for userId in WithIds {
            FirestoreReference(.User).document(userId).getDocument { snapshot, error in
                guard let document = snapshot else {return}
                let user = try? document.data(as: User.self)
                usersArray.append(user!)
                count += 1
                if count == WithIds.count{
                    complition(usersArray)
                }
            }
        }
    }
    
    
    
    // download all users
    func downloadAllUsers(complition : @escaping (_ users : [User])-> Void){
        var users : [User] = []
        FirestoreReference(.User).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("no documents on the file")
                return
            }
            // the compact map because the user may = nil it make unwrap
            let allUsers = documents.compactMap { snapshot -> User? in
                return try? snapshot.data(as: User.self)
            }
            for user in allUsers  {
                if User.currentID != user.id{
                    users.append(user)
                }
            }
            complition(users)
            
        }
    }
    
    //MARK: - Register
    
    /*    error can be = nil
     1- if there is no error on creating the email send varification and the email is created
     2- if user is created you get authResult.user that let you get any information about user
     3- make an object from the struct user and give it the data about uset
     ** the error here is the user dont confirm so database create the and you take an object and he may not confirm if so you have an object that not used.
     ** you save the object with no confirm ?????????
     (---> if you not make the error on complition from type (Error?) it will be error
     ---> the complition let you get the error and app some code on it but after the content of class is done so it will create a user and then if the creation got error it will send the error se the error will be send after the creation not before so it will wait untill the creation and then get the error
     ---> when we save user we save it on the sahpe of the Model (User) the information at firs doesn't important
     */
    
    func RegisterUserWith(email : String , password : String, complition : @escaping (_ error : Error?) ->Void){
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            complition(error)
            if error == nil{
                authResult!.user.sendEmailVerification { error in
                    complition(error)
                }
            }
            if authResult?.user != nil{
                let user = User(id: authResult!.user.uid, username: email, email: email , pushId: "", avatarLink: "", status: "Hay Iam using app")
                self.saveUserToFirestore(user)
                saveUserLocally(user)
            }
        }
    }
    
    
    // make a collection then document with the name of the uid and save data with set data
    //MARK: - saveUserToFirestore
     func saveUserToFirestore(_ user : User){
        do {
            try FirestoreReference(.User).document(user.id).setData(from:user)
        }catch{
            print (error.localizedDescription)
        }
    }

    //MARK: - Resend Varification
    
    /*
     the reload to redo the function
    and then we send the varification
     he dont take the email why????? ---> it sent to the last User
     not good it will send the email to the last user and it dont need the email
    */
    func resendVarification(email : String,complition : @escaping (_ error : Error?) -> Void){
        Auth.auth().currentUser?.reload(completion: { error in
            Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                complition(error)
            })
        })
    }
    
    //MARK: - Reset Password
    func  resetPasswordFor(email:String,complition : @escaping (_ error : Error?)-> Void){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            complition(error)
        }
    }
    
}






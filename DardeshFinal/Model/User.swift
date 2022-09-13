

///the only thig this func does it the model user and get and set its data

import Firebase
import UIKit
import FirebaseFirestoreSwift




struct User : Codable , Equatable{
    
    var id = ""
    var username : String
    var email : String
    var pushId = "" // للاشعارات
    var avatarLink = ""
    var status : String
    
    // when you init the User you can dont but value to the static var because it has return
    static var currentID : String {
        return Auth.auth().currentUser!.uid
    }
    
    // current user to get the data from the UserDefault not from database but the user must be login
    //the current user will have the value of the user so if we use it will return userobject or nil
    static var currentUser : User? {
        if Auth.auth().currentUser != nil {
            if let data = userDefault.data(forKey: kCURRENTUSER){
                let decoder = JSONDecoder()
                do {
                    let userObject = try decoder.decode(User.self, from: data)
                    return userObject
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
        // if the user not login will return nil
        return nil
    }
    // to make the comopare betweent two objects
    static func == (lhs : User , rhs : User) -> Bool{
        lhs.id == rhs.id
    }
    
}



// to save the user on our device (encoded)
func saveUserLocally (_ user : User){
    let encoder = JSONEncoder()
    do {
        let data = try encoder.encode(user)
        userDefault.set(data,forKey: kCURRENTUSER)
    }catch{
        print(error.localizedDescription)
    }
}

//run it for one time to create the users
// to create the user upload the image to fileStorage and thin make user on fireStore
//func createDummyUsers() {
//    print("creating dummy users...")
//
//    let names = ["Iron Man", "Alaa Najmi", "Nawaf Mansour", "Keanu Reeves", "Smeagol"]
//    // what is this vars do ????
//    var imageIndex = 1
//    var userIndex = 1
//
//    for i in 0..<5 {
//        //it creates a random ids to but it on userid we don't user the Auth id because the are not signin these are other accounts
//        let id = UUID().uuidString
//
//        let fileDirectory = "Avatars/" + "_\(id)" + ".jpg"
//
//        FileStorage.UploadImage(UIImage(named: "user\(imageIndex)")!, directory: fileDirectory) { (avatarLink) in
//
//            let user = User(id: id, username: names[i], email: "user\(userIndex)@mail.com", pushId: "", avatarLink: avatarLink ?? "", status: "No Status")
//
//            userIndex += 1
//            FUserListener.shared.saveUserToFirestore(user)
//        }
//        imageIndex += 1
//
//        // why he made this condition??????? I think to be sure that if you runn it more than one time not make an error
//        if imageIndex == 5 {
//            imageIndex = 1
//        }
//    }
//
//}

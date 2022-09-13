
// only make the creation of the collection easyer and make the name in the enum to till the next user the collection names if there is more than one collection in app

import Foundation
import Firebase

enum FCollectionReference : String {
    case User = "User"
    case Chat
    case Message
    case Typing
    case Channel
}

func FirestoreReference(_ collectionReference : FCollectionReference) -> CollectionReference{
    return Firestore.firestore().collection(collectionReference.rawValue)
}


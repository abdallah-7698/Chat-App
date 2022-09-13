
import Foundation
import RealmSwift

class RealmManager{
    
    static let shared = RealmManager()
    let realm = try! Realm()
    private init(){}
    
    
    // save the data locally
    func save(_ object : Object){
        do{
           try realm.write{
                realm.add(object, update: .all)
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    
    
}


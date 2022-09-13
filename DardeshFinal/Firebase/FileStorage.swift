
/// To make files and read or write files from (fileStorage)

import UIKit
import FirebaseStorage
import ProgressHUD

//MARK: - Constant
let storage = Storage.storage()

class FileStorage {
    // to save the image on FileStorage
    /*
     1- create a file on fileStorage
     //reference is the link you get from the fileStorage to make the child (folder) on
     -get the link from Storage because we are going to use it alot and make it a constant
     2- convert the image into data to be able to but it on file
     3- but the data on the file and get the link
     and after finish remove all Observers and dismiss the progressHud
     --> you still don't make the observer
     4- observe the precentage update on the task you made
     */
    
    class func UploadImage (_ image : UIImage , directory : String , complition : @escaping (_ documentLink : String?)-> Void){
        //crete the file
        let storageRef = storage.reference(forURL: kFILEreference).child(directory)
        // image to data
        let imageData = image.jpegData(compressionQuality: 0.5)
        // upload image
        // task must be var
        var task : StorageUploadTask!
        /// the task happen paralle with the opserve
        task = storageRef.putData(imageData!, metadata: nil, completion: { metaData, error in
            /*
             1- when the upload of data if done we want the progressHud to be removed and we want the observe the watch the progress to be removed
             2- if any error on upload happens we want to print it
             3- if no error we want do get the link of the file that downloaded and put it into the fireStore
             --->> why we make the remove after the complition and then make task.observe on the StorageTaskStatus
             */
            task.removeAllObservers()
            ProgressHUD.dismiss()
            
            //if error happen print it
            if error != nil {
                print ("Error uploading image : \(error!.localizedDescription)")
                return
            }
            
            // get the url when it is done
            storageRef.downloadURL { url, error in
                guard let downloadURL = url else{
                    complition(nil)
                    return
                }
                complition(downloadURL.absoluteString)
            }
            
        })
        
        
        // observe the status of the Storage not only the download but in this code it look at download
        task.observe(StorageTaskStatus.progress) { snapshot in
            let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
            ProgressHUD.showProgress(CGFloat(progress))
        }
        
    }
    
    // fileNameFrom is a func that get the file name from URL
    /*
     1- look at the fileManager first if is here get it if no download it from internet
     */
    //MARK: - Download Image from storage
    class func downloadImage(imageURL : String , complition : @escaping (_ image : UIImage?)->Void){
        let imageFileName = fileNameFrom(fileURL: imageURL)
        // if the image on the fileManager
        if fileExistAtPath(path: imageFileName){
            if let contenentOfFile = UIImage(contentsOfFile: fileInDocumentDirectory(fileName: imageFileName)){
                complition(contenentOfFile)
            }else{
                print ("could not convert the Local Image")
                complition(UIImage(named: "avatar")!)
            }
        }else{
            // get the image from the URL
            if imageURL != ""{
                let documentURL = URL(string: imageURL)
                // because download happens on the background
                let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
                downloadQueue.async {
                    let data = NSData(contentsOf: documentURL!)
                    if data != nil{
                        // when save make the complition and don't wait (the download my take some time)
                        FileStorage.saveFileLocally(fileData: data!, fileName: imageFileName)
                        DispatchQueue.main.async{
                            complition(UIImage(data: data! as Data))
                        }
                    }else{
                        print("no document found in data base")
                        complition(nil)
                    }
                }
            }
        }
    }
    
    //MARK: - Video Upload
    class func UploadVideo (_ video : NSData , directory : String , complition : @escaping (_ videoLink : String?)-> Void){
        //crete the file
        let storageRef = storage.reference(forURL: kFILEreference).child(directory)
        // don't convert the video because it is data already
        // task must be var
        var task : StorageUploadTask!
        /// the task happen paralle with the opserve
        task = storageRef.putData(video as Data, metadata: nil, completion: { metaData, error in

            task.removeAllObservers()
            ProgressHUD.dismiss()
            
            //if error happen print it
            if error != nil {
                print ("Error uploading image : \(error!.localizedDescription)")
                return
            }
            // get the url when it is done
            storageRef.downloadURL { url, error in
                guard let downloadURL = url else{
                    complition(nil)
                    return
                }
                complition(downloadURL.absoluteString)
            }            
        })
        // observe the status of the Storage not only the download but in this code it look at download
        task.observe(StorageTaskStatus.progress) { snapshot in
            let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
            ProgressHUD.showProgress(CGFloat(progress))
        }
        
    }

    //MARK: - Download Video
    // same to image but with some modifies because the video is saved by it's URL 
    class func downloadVideo(videoURL : String , complition : @escaping (_ isReadyToPlay : Bool , _ videoFileName : String)->Void){
        let videoFileName = fileNameFrom(fileURL: videoURL)+".mov"
        // if the image on the fileManager
        if fileExistAtPath(path: videoFileName){
            complition(true , videoFileName)
        }else{
            // get the image from the URL
            if videoURL != ""{
                let documentURL = URL(string: videoURL)
                // because download happens on the background
                let downloadQueue = DispatchQueue(label: "videoDownloadQueue")
                downloadQueue.async {
                    let data = NSData(contentsOf: documentURL!)
                    if data != nil{
                        // when save make the complition and don't wait (the download my take some time)
                        FileStorage.saveFileLocally(fileData: data!, fileName: videoFileName)
                        DispatchQueue.main.async{
                            complition(true , videoFileName)
                        }
                    }else{
                        print("no document found in data base")
                    }
                }
            }
        }
    }
    
    //MARK: - upload audio
    class func UploadAudio (_ audioFileName : String , directory : String , complition : @escaping (_ audioLink : String?)-> Void){
        //crete the file
        let fileName  = audioFileName + ".m4a"
        let storageRef = storage.reference(forURL: kFILEreference).child(directory)
        // don't convert the video because it is data already
        // task must be var
        var task : StorageUploadTask!
        
        if fileExistAtPath(path: fileName){
            if let audioData = NSData(contentsOfFile: fileInDocumentDirectory(fileName: fileName)){
                /// the task happen paralle with the opserve
                task = storageRef.putData(audioData as Data, metadata: nil, completion: { metaData, error in

                    task.removeAllObservers()
                    ProgressHUD.dismiss()
                    
                    //if error happen print it
                    if error != nil {
                        print ("Error uploading audio : \(error!.localizedDescription)")
                        return
                    }
                    // get the url when it is done
                    storageRef.downloadURL { url, error in
                        guard let downloadURL = url else{
                            complition(nil)
                            return
                        }
                        complition(downloadURL.absoluteString)
                    }
                })
                // observe the status of the Storage not only the download but in this code it look at download
                task.observe(StorageTaskStatus.progress) { snapshot in
                    let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
                    ProgressHUD.showProgress(CGFloat(progress))
                }
            }
                
        }else{
            // not exist on the path
            print("file is not exist")
        }
        
    }
    
    //MARK: - download audio
    class func downloadaudio(audioUrl : String , complition : @escaping ( _ audioFileName : String)->Void){
        let audioFileName = fileNameFrom(fileURL: audioUrl)+".m4a"
        // if the image on the fileManager
        if fileExistAtPath(path: audioFileName){
            complition(audioFileName)
        }else{
            // get the image from the URL
            if audioUrl != ""{
                let documentURL = URL(string: audioUrl)
                // because download happens on the background
                let downloadQueue = DispatchQueue(label: "audioDownloadQueue")
                downloadQueue.async {
                    let data = NSData(contentsOf: documentURL!)
                    if data != nil{
                        // when save make the complition and don't wait (the download my take some time)
                        FileStorage.saveFileLocally(fileData: data!, fileName: audioFileName)
                        DispatchQueue.main.async{
                            complition(audioFileName)
                        }
                    }else{
                        print("no document found in data base")
                    }
                }
            }
        }
    }


    
    //MARK: - Save Image locally on the FileManager
    
    class func saveFileLocally (fileData : NSData,fileName : String){
        let docURL = getDocumentURL().appendingPathComponent(fileName, isDirectory: false)
        fileData.write(to: docURL, atomically: true)
    }
    
}

//MARK: - HelperFunctions
func getDocumentURL()->URL{
    // documentDirectory --> the place in your iphone you want to save the image in
    // userDomainMask    --> the access is from this account in this device not from other device even in the same account
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
}
// getv the file path by name
func fileInDocumentDirectory(fileName : String) -> String {
    return getDocumentURL().appendingPathComponent(fileName).path
}
// see if the file exist in the path
func  fileExistAtPath(path : String)->Bool{
    return FileManager.default.fileExists(atPath: fileInDocumentDirectory(fileName: path ))
}

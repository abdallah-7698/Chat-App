//
//  EdetProfileFirstTVC.swift
//  DardeshFinal
//
//  Created by MacOS on 29/01/2022.
//

import UIKit
import Gallery
import ProgressHUD


class EdetProfileFirstTVC: UITableViewCell {

    //MARK: - IBOutlet

    @IBOutlet weak var avatarImageProfileOutlet: UIImageView!
        
    
    
    //MARK: - Constant

    var gallery : GalleryController!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showUserInfo()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: - IBAction
    
    private func showUserInfo(){
        if let user = User.currentUser {
            if user.avatarLink != ""{
                FileStorage.downloadImage(imageURL: user.avatarLink) { avatarImage in
                    self.avatarImageProfileOutlet.image = avatarImage?.circleMasked
                }
            }
        }
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        showImageGallery()
    }
    
    //MARK: - HelperFunctions
    private func showImageGallery(){
        self.gallery = GalleryController()
        self.gallery.delegate = self
        Config.tabsToShow = [.imageTab,.cameraTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        gallery.modalPresentationStyle = .fullScreen
        self.window?.rootViewController!.present(gallery, animated: true, completion: nil)
    }
    
    private func uploadAvatarImage(_ image : UIImage){
        let fileDirectory = "Avatars/" + "_\(User.currentID)"+".jpg"
        FileStorage.UploadImage(image, directory: fileDirectory) { documentLink in
            if var user = User.currentUser{
                user.avatarLink = documentLink ?? ""
                saveUserLocally(user)
                FUserListener.shared.saveUserToFirestore(user)
            }
            //TODO save Image Locallty because we only saved the link on the User not the image (done)
            FileStorage.saveFileLocally(fileData: image.jpegData(compressionQuality: 0.5)! as NSData, fileName: User.currentID)
        }
    }
    
}
extension EdetProfileFirstTVC : GalleryControllerDelegate{
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        if images.count > 0{
            // it is used only in Gallery to get the actulat image as (UIImage)
            images.first!.resolve { avatarImage in
                if avatarImage != nil{
                    // to do save the image
                    self.uploadAvatarImage(avatarImage!)
                    self.avatarImageProfileOutlet.image = avatarImage?.circleMasked
                }else{
                    ProgressHUD.showError("Could not select Image")
                }
            }
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}

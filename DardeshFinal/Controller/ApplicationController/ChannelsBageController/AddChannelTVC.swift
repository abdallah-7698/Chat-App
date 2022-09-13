//
//  AddChannelTVC.swift
//  DardeshFinal
//
//  Created by MacOS on 14/06/2022.
//

import UIKit
import Gallery
import ProgressHUD

class AddChannelTVC: UITableViewController {
    
    //MARK: - IBOutlet

        
    
    //MARK: - Constant

    static let AddChannelCell1 = "AddChannelCell1"
    static let AddChannelCell2 = "AddChannelCell2"
    
    var channelId = UUID().uuidString
    var gallery : GalleryController!
    var avatarLink = ""
    var tapGesture = UITapGestureRecognizer()
    var imageAvatar = UIImageView(image: UIImage(named: "avatar")!)
    // if the view is add new channel there will not be any data int his variable
    // but if in edit mode there will be a data to show in and you will get the channel
    var channelToEdit : Channel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        prepareNavigation()
        setUpCell()
        tapGesture.addTarget(self, action: #selector(avatarImageTap))
        if channelToEdit != nil{
            configureEditView()
        }
    }
    
    
    //MARK: - HelperFunctions

    private func prepareNavigation(){
        self.title = "New Channel"
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveChannel))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonPressed))
    }
    
    private func setUpCell(){
        self.tableView.register(UINib(nibName: AddChannelTVC.AddChannelCell1, bundle: nil), forCellReuseIdentifier: AddChannelTVC.AddChannelCell1)
        self.tableView.register(UINib(nibName: AddChannelTVC.AddChannelCell2, bundle: nil), forCellReuseIdentifier: AddChannelTVC.AddChannelCell2)
    }
    
    private func showGallery(){
        self.gallery = GalleryController()
        gallery.delegate = self
        Config.tabsToShow = [.imageTab , .cameraTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        present(gallery, animated: true)
    }
    //MARK: - IBAction

    
    @objc func avatarImageTap(){
        showGallery()
    }
    
    @objc func saveChannel(){

        tableView.reloadData()
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! AddChannelCell1
        if cell.channelName.text != "" {
            // save the channle
            saveChannelToFireStore()
        }else{
            ProgressHUD.showFailed("Channle name is required")
        }
    }
    
    @objc func backButtonPressed(){
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Avatar
    
    private func uploadAvatarImage(_ image : UIImage){
        let fileDirectory = "Avatar/" + "_\(channelId)" + ".jpg"
        FileStorage.saveFileLocally(fileData: image.jpegData(compressionQuality: 0.7)! as NSData, fileName: self.channelId)
        FileStorage.UploadImage(image, directory: fileDirectory) { documentLink in
            self.avatarLink = documentLink ?? ""
        }
    }

    // you must make  listener on fireStore
    private func saveChannelToFireStore(){
        
        /// why when i make edit dont save ??????????????
        
        let indexPath1 = IndexPath(row: 0, section: 0)
        let cell1 = tableView.cellForRow(at: indexPath1) as! AddChannelCell1
        let indexPath2 = IndexPath(row: 1, section: 0)
        let cell2 = tableView.cellForRow(at: indexPath2) as! AddChannelCell2
        
        let channel = Channel(id: channelId, name: cell1.channelName.text!, adminId: User.currentID, memberIds: [User.currentID], avatarLink: avatarLink, aboutChannel:cell2.aboutChannel.text ?? "")
    //save channel to fireStore
        FChannelListener.shared.saveChannel(channel)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Configure edit view
    // if we call this func and we hase no object it will crash and the channelToEdit is optional
    // so in view didLoad we must Check if it is found or not
    private func configureEditView(){
        
        self.channelId = channelToEdit!.id
        self.avatarLink = channelToEdit!.avatarLink
        self.title = "Edit Channel"

    }
    
    
    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: AddChannelTVC.AddChannelCell1, for: indexPath) as! AddChannelCell1
            cell.avatarImage.isUserInteractionEnabled = true
            cell.avatarImage.addGestureRecognizer(tapGesture)
            cell.avatarImage.image = imageAvatar.image!
            if channelToEdit != nil{
                cell.channelName.text = channelToEdit!.name
                
                if channelToEdit?.avatarLink != "" {
                    FileStorage.downloadImage(imageURL: channelToEdit!.avatarLink) { image in
                        DispatchQueue.main.async {
                            cell.avatarImage.image = image?.circleMasked
                        }
                    }
                }else{
                    cell.avatarImage.image = UIImage(named: "avatar")
                }
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: AddChannelTVC.AddChannelCell2, for: indexPath) as! AddChannelCell2
            if channelToEdit != nil{
            cell.aboutChannel.text = channelToEdit!.aboutChannel
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 80
        }else{
            return 200
        }
    }
    
}


extension AddChannelTVC : GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        if images.count > 0{
            images.first!.resolve { icon in
                if icon != nil{
                    // upload image
                    self.uploadAvatarImage(icon!)
                    // set Avatar image
                    self.imageAvatar.image = icon!.circleMasked
                    self.tableView.reloadData()
                }else{
                    ProgressHUD.showFailed("Could not select image")
                }
            }
        }
        controller.dismiss(animated: true , completion: nil)
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

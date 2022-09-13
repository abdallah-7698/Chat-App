/*
 ---> We get the message from realm not from the Firebase and convert it from local message into MKMessage to show it on the MSGTableView
 but from where it get these messages ????? it is incoming not out
 */

import UIKit
import MessageKit
import InputBarAccessoryView
import Gallery
import RealmSwift

//we make the class inheret from MassageViewController
class ChannelMSGVC: MessagesViewController {
    
    //MARK: - IBOutlet
    let leftBarButtonView : UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        
        return view
    }()
    
//    let titleLable : UILabel = {
//        let lable = UILabel(frame: CGRect(x: 5, y: 0, width: 100, height: 25))
//        lable.textAlignment = .left
//        lable.font = UIFont.systemFont(ofSize: 16,weight: .medium)
//        lable.adjustsFontSizeToFitWidth = true
//        return lable
//    }()
//
//    let subTitleLable : UILabel = {
//        let lable = UILabel(frame: CGRect(x: 5, y: 22, width: 100, height: 24))
//        lable.textAlignment = .left
//        lable.font = UIFont.systemFont(ofSize: 13,weight: .medium)
//        lable.adjustsFontSizeToFitWidth = true
//        return lable
//    }()
    
    //MARK: - Constant
    
    var displayMessageCount = 0
    var maxMessageNumber = 0
    var minMessageNumber = 0
    
//    var typingCounter = 0
    
    var gallery : GalleryController!
    
    //gesture
    private var longPressGesture: UILongPressGestureRecognizer!
    var audioFileName : String = ""
    var audioStartTime : Date = Date()
    
    var channel : Channel!
    
    // you make the var lazy if you want to init it if the app want it only
    open lazy var audioController = BasicAudioController(messageCollectionView: messagesCollectionView)
    
    //MARK: - Constant Of the MassagesView
    //these var are necessary for the massage kit
    // when move from other class pass data by init
    private var chatId = ""
    private var recipientId = ""
    private var recipientName = ""
    let refreshController = UIRefreshControl()
    let attachButton = InputBarButtonItem()
    let micButton =  InputBarButtonItem()
    let currentUser = MKSender(senderId: User.currentID, displayName: User.currentUser!.username)
    
    // contains the messages that we save and deal with
    var mkMessages : [MKMessage] = []
    // why it is Results ????????? why we dont make a normal array ????????
    var allLocalMessages : Results<LocalMessage>!
    // make class from RealmDB
    let realm = try! Realm()
    // this var on the realm DB and works as Listener to any changes
    var notificationToken : NotificationToken?
    //MARK: - init
    init(channel : Channel){
        super.init(nibName: nil, bundle: nil)
        self.chatId = channel.id
        self.recipientId = channel.id
        self.recipientName = channel.name
        
        self.channel = channel
        
    }
    
    // the init for the massage kit
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMSGCV()
        configureGestureRecognizer()
        configureMessageInputBar()
        configureCustomTitle()
        
        loadMessages()
        
        listenForNewMessages()
//        listenerForeReadStatusUpdate()
//        createTypingObserver()
        navigationItem.largeTitleDisplayMode = .never
        
    }
    
    
    //MARK: - IBAction
    
    
    //MARK: - HelperFunctions
    // long press configure
    private func configureGestureRecognizer(){
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(recordAndSend))
        
    }
    
    
    private func configureMSGCV(){
        //message protocols to show the message and use properties
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        
        // when edit go to the end of the message
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        messagesCollectionView.refreshControl = refreshController
    }
    
    private func configureMessageInputBar(){
        messageInputBar.isHidden = channel.adminId != User.currentID
        messageInputBar.delegate = self
        // make a button on the constants apove
        // make the picture inside the buttom bigger
        attachButton.image = UIImage(systemName: "paperclip",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        // make the buttom bigger but if you make it on storyBoard you can set the constraints to do that
        attachButton.setSize(CGSize(width: 30, height: 30), animated: false)
        // make the action on the buttom
        attachButton.onTouchUpInside { item in
            self.actionAttachMessage()
        }
        
        // make another button to the mic on the constants
        micButton.image = UIImage(systemName: "mic.fill" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        micButton.setSize(CGSize(width: 30, height: 30), animated: false)
        // Add gesture recognizer
        micButton.addGestureRecognizer(longPressGesture)
        // to add the item
        messageInputBar.setStackViewItems([attachButton], forStack: .left, animated: false)
        // change the width to the left button on the input bar
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        // add and update the mic button but we dont tell any this to change the value ????
        updateMicButtonStatus(show : true)
        
        // you cant make copy to the image ot paste
        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.backgroundView.backgroundColor = .systemBackground
        messageInputBar.inputTextView.backgroundColor = .systemBackground
    }
    
    //MARK: - MicroPhone
    func updateMicButtonStatus(show : Bool){
        if show == true {
            messageInputBar.setStackViewItems([micButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 30, animated: false)
        }else{
            messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 55, animated: false)
        }
    }
    
    //MARK: - Configuration
    private func configureCustomTitle(){
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(self.backButtonPressed))]
        
//        leftBarButtonView.addSubview(titleLable)
//        leftBarButtonView.addSubview(subTitleLable)
//
//        // make button item using this view
//        // the element name is bar button item but it is not buttom
//        let leftBarButtonItem = UIBarButtonItem(customView: leftBarButtonView)
//        self.navigationItem.leftBarButtonItems?.append(leftBarButtonItem)
//
//        titleLable.text = self.recipientName
//        subTitleLable.text = "Tuping..."
        self.title = channel.name
        
    }
    
    @objc func backButtonPressed(){
        //Remove listeners from firestore and Realm
        removeListener()
        FChatRoomListner.shared.clearUnreadCounterUsingId(chatRoomId: chatId)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Mark the message as read
    // we don't want to modify the message of the current id
    // the hard part is where to call the func because will the user sending the messages this func must be called
    // so we should but it while insert the message
    private func markMessageAsRead(_ localMessage : LocalMessage){
        if localMessage.senderId != User.currentID{
            // it will make the message read and will change the read date
            FMessageListener.shared.updateMessageStatus(localMessage, userId: recipientId)
        }
    }
    
    
    //MARK: - Update typing indecator
//
//    func updateTypingIndecator(_ show : Bool){
//        subTitleLable.text = show ? "Typing..." : ""
//    }
//    // if the user start to tping make it true and if he stops make it false but to the current user
//    func startTypingIndecator(){
//        typingCounter += 1
//        FTypingListener.saveTypingCounter(typing: true, chatRoomId: chatId)
//        //Sotp typing after 1.5 seconds
//        DispatchQueue.main.asyncAfter(deadline: .now()+1.5){
//            self.stopTypingIndecator()
//        }
//    }
//
//    func stopTypingIndecator(){
//        typingCounter -= 1
//        if typingCounter == 0 {
//            FTypingListener.saveTypingCounter(typing: false, chatRoomId: chatId)
//        }
//    }
//
//    // why it doesn't work ??????
//    func createTypingObserver(){
//        FTypingListener.shared.createTypingObserver(chatRoomId: chatId) { isTyping in
//            DispatchQueue.main.async {
//                self.updateTypingIndecator(isTyping)
//            }
//        }
//    }
//
    
    //MARK: - Action
    func send(text : String? , photo : UIImage? , video : Video? , location : String? , audio : String? , audioDuration : Float = 0.0){
        //Outgoing.sendMessage(chatId: chatId, text: text, photo: photo, video: video, audio: audio, location: location, memberIds: [User.currentID , recipientId])
        Outgoing.sendChannelMessage(channel: channel, text: text, photo: photo, video: video, audio: audio,audioDuration: audioDuration, location: location)
    }
    
    // record and send func
    @objc func recordAndSend(){
        // to know if he is still press or not
        switch longPressGesture.state{
        case .began:
            audioFileName = Date().stringDate()
            audioStartTime = Date()
            AudioRecorder.shared.startRecording(fileName: audioFileName)
            // record and start recordign
        case .ended:
            // stop and send the messaeg
            AudioRecorder.shared.finishRecording()
            //be sure that file exist
            // we must calculate the duration of the audio
            let audioDuration = audioStartTime.interval(component: .second, to: Date())
            if fileExistAtPath(path: audioFileName + ".m4a") {
                send(text: nil, photo: nil, video: nil, location: nil, audio: audioFileName,audioDuration: audioDuration)
                
            }else{
                print("no file found")
            }
            
        @unknown default:
            print("unknown")
        }
    }
    
    //MARK: - Action Sheet
    
    private func actionAttachMessage(){
        
        // you must hide the keybord first
        messageInputBar.inputTextView.resignFirstResponder()
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        // we will use the guallery
        let takePhotoOrVideo = UIAlertAction(title: "Camera", style: .default) { alert in
            self.showImageGllery(camera : true)
        }
        let shareMedia = UIAlertAction(title: "Library", style: .default) { alert in
            self.showImageGllery(camera : false)
        }
        let shareLocation = UIAlertAction(title: "Show Location", style: .default) { alert in
            if let _ = LocationManager.shard.currentLocation{
                // there is no need fot the kLOCATION because we don't give the location
                self.send(text: nil, photo: nil, video: nil, location: kLOCATION, audio: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // to give the action Images (the key not important)
        takePhotoOrVideo.setValue(UIImage(systemName: "camera"), forKey: "image")
        shareMedia.setValue(UIImage(systemName: "photo.fill"), forKey: "image")
        shareLocation.setValue(UIImage(systemName: "mappin.and.ellipse"), forKey: "image")
        
        
        optionMenu.addAction(takePhotoOrVideo)
        optionMenu.addAction(shareMedia)
        optionMenu.addAction(shareLocation)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    //MARK: - UIScrolViewDelegate
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshController.isRefreshing{
            // we have messages
            if displayMessageCount < allLocalMessages.count {
                self.insertMoreMKMessages()
                messagesCollectionView.reloadDataAndKeepOffset()
            }
        }
        refreshController.endRefreshing()
    }
    
    
    //MARK: - loadMessages
    // we get the message only from realm not from firebase
    // firebase but it on the realm and the device get it from realm
    // we have A class that convert the local message into mkMessage we use it to convert the array we have into MKMessage to show it on the MSGtableView
    private func loadMessages(){
        
        // the condition if the message have the chatID get it (%@ is the next var on realm DB)
        let predicate = NSPredicate(format: "chatRoomId = %@" , chatId)
        
        // get all local messages but only on this chatRoom and sort it by date from small to bit
        allLocalMessages = realm.objects(LocalMessage.self).filter(predicate).sorted(byKeyPath: kDATE,ascending: true)
        
        if allLocalMessages.isEmpty {
            checkForOldMessage()
        }
        
        // after getting all messages we convert them all into MKMessages but if any change happen on the database
        // by useing the change from RealmCollectionChange we can make the code in case of these changes
        notificationToken = allLocalMessages.observe({(change : RealmCollectionChange) in
            switch change {
                // At the beginning insert and make refresh and go to the button of the list
            case .initial(_):
                self.insertMKMessages()
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem(animated: false)
                // don't fix it because the new one has a problem and not work well
                self.messagesCollectionView.scrollToBottom(animated: false)
                // there is many changes or update if you don't want any one of thes you but _ in this case we only want the insertion
                // in the case of insert it return array of insertions so more than one value
            case .update(_, _, let insertions, _):
                // you can insert more than one
                for index in insertions{
                    self.insertMKMessage(localMessage: self.allLocalMessages[index])
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToLastItem(animated: true)
                }
            case .error(let error):
                print ("error in new incertion : ", error.localizedDescription)
            }
        })
        
    }
    
    // convart the message and but it on the var mkMessages
    private func insertMKMessage(localMessage : LocalMessage){
        // it will change the message status from send to read and the listener listen to the changes
      //  markMessageAsRead(localMessage)
        let incoming = Incoming(messageViewController: self)
        let mkMessage = incoming.createMKMessage(localMessage: localMessage)
        self.mkMessages.append(mkMessage)
        displayMessageCount += 1
    }
    // but on the top of the array
    private func insertOldelMKMessage(localMessage : LocalMessage){
        let incoming = Incoming(messageViewController: self)
        let mkMessage = incoming.createMKMessage(localMessage: localMessage)
        self.mkMessages.insert(mkMessage, at: 0)
        displayMessageCount += 1
    }
    
    // loop for the above func to convert and incert all
    private func insertMKMessages(){
        
        // we don't want all messages to load
        maxMessageNumber = allLocalMessages.count - displayMessageCount
        minMessageNumber = maxMessageNumber - kNUMBEROFMESSAGES
        
        if minMessageNumber < 0 {
            minMessageNumber = 0
        }
        
        for i in minMessageNumber ..< maxMessageNumber {
            insertMKMessage(localMessage: allLocalMessages[i])
        }
    }
    
    private func insertMoreMKMessages(){
        
        // we don't want all messages to load
        maxMessageNumber = minMessageNumber - 1
        minMessageNumber = maxMessageNumber - kNUMBEROFMESSAGES
        
        if minMessageNumber < 0 {
            minMessageNumber = 0
        }
        
        for i in (minMessageNumber ... maxMessageNumber).reversed() {
            insertOldelMKMessage(localMessage: allLocalMessages[i])
        }
    }
    
    //get the messages from the Eirebase when you make sign in
    // we call this func if the local message is empty only then we will make an observer to see if there is any changes on the database it will make the download but not all time to save the device resources
    // what is chat id ????
    
    private func checkForOldMessage(){
        FMessageListener.shared.checkForOldMessages(User.currentID, collectionId: chatId)
    }
    
    // to get the data (new messages) that the other user made
    // we don't have the last message date so i will make a func to get it
    // but it on ViewDidLoad because if any change happens it will be called
    // but to run this func we must have two devices
    private func listenForNewMessages(){
        FMessageListener.shared.listenForNewMessage(User.currentID, collectionId: chatId, lastMessageDate())
    }
    
    //MARK: - Update Read Status
    // get the updated message and make the update on the mkMessages
    // we will call this func inside the listener
//    private func updateReadStatus(_ updatedLocalMessage: LocalMessage){
//        for index in 0 ..< mkMessages.count {
//            let tempMessage = mkMessages[index]
//            if updatedLocalMessage.id == tempMessage.messageId{
//                mkMessages[index].status = updatedLocalMessage.status
//                mkMessages[index].readDate = updatedLocalMessage.readDate
//
//                // make it on Realm
//                RealmManager.shared.save(updatedLocalMessage)
//                // update the UI
//                if mkMessages[index].status == kRead {
//                    self.messagesCollectionView.reloadData()
//                }
//            }
//        }
//    }
//    private func listenerForeReadStatusUpdate(){
//        FMessageListener.shared.ListenForReadStatus(User.currentID, collectionId: chatId) { updatesMessage in
//            self.updateReadStatus(updatesMessage)
//        }
//    }
    
    //MARK: - Helpers Functions
    // when we deal with the date (add or any operation) we use Calendar
    private func lastMessageDate()->Date{
        let lastMessageDate = allLocalMessages.last?.date ?? Date()
        return Calendar.current.date(byAdding: .second,value: 1 ,to: lastMessageDate) ?? lastMessageDate
    }
    
    
    // when you leav remove all listeners
    private func removeListener(){
       // FTypingListener.shared.removeTypingListener()
        FMessageListener.shared.removeMessageListener()
    }
    
    //MARK: - Gallery
    
    private func showImageGllery(camera : Bool){
        // you must make the delegate func if not the buttons will not work
        gallery = GalleryController()
        gallery.delegate = self
        
        Config.tabsToShow = camera ? [.cameraTab] : [.imageTab, .videoTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        Config.VideoEditor.maximumDuration = 30
        
        self.present(gallery, animated: true, completion: nil)
    }
    
}

extension ChannelMSGVC : GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            // convert the image into  UIImage
            images.first!.resolve { image in
                self.send(text: nil, photo: image, video: nil, location: nil, audio: nil)
            }
        }
        
        print("we have \(images.count) image")
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        
        self.send(text: nil, photo: nil, video: video, location: nil, audio: nil)
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}

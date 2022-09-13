import Foundation
 import MessageKit
import SwiftUI


class VideoMessage : NSObject, MediaItem{
    var url: URL?
    
    var image: UIImage?
    
    var placeholderImage: UIImage
    
    var size: CGSize
    
    init(url : URL?){
        // on video you dont have to convert to url it is on URL
        self.url = url
        // the imptyt image
        self.placeholderImage = UIImage(named: "photoPlaceholder")!
        self.size = CGSize(width: 240, height: 240)
    }
}

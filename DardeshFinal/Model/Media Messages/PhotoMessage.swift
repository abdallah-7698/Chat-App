/*
 after create the model go to the mkMessage and create the var to hold the image
 */

import Foundation
 import MessageKit
import SwiftUI


class PhotoMessage : NSObject, MediaItem{
    var url: URL?
    
    var image: UIImage?
    
    var placeholderImage: UIImage
    
    var size: CGSize
    
    init(path : String){
        self.url = URL(fileURLWithPath: path)
        // the imptyt image
        self.placeholderImage = UIImage(named: "photoPlaceholder")!
        self.size = CGSize(width: 240, height: 240)
    }
}

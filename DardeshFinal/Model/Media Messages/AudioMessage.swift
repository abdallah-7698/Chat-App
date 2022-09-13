//
//  AudioMessage.swift
//  DardeshFinal
//
//  Created by MacOS on 11/05/2022.
//

import UIKit
import MessageKit


class AudioMessage : NSObject , AudioItem{
  
    var url: URL
    
    var duration: Float
    
    var size: CGSize
    
    init(duration : Float){
        self.url = URL(fileURLWithPath: ""  )
        self.size = CGSize(width: 200, height: 40)
        self.duration = duration
    }
    
}




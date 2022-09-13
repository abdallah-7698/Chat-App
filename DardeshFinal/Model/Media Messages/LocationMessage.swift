//
//  LocationMessage.swift
//  DardeshFinal
//
//  Created by MacOS on 27/04/2022.
//

import Foundation
import MessageKit
import CoreLocation
import UIKit


class LocationMessage : NSObject ,LocationItem{
    var location: CLLocation
    
    var size: CGSize
    
    init(location : CLLocation){
        self.location = location
        self.size = CGSize(width: 240, height: 240)
    }
}


//
//  MapAnnotation.swift
//  DardeshFinal
//
//  Created by MacOS on 27/04/2022.
//

import Foundation
import RealmSwift
import MapKit
import CoreLocation

class MapAnnotation : NSObject , MKAnnotation{
    let title : String?
    let coordinate : CLLocationCoordinate2D
    
    init(title : String , coordinate : CLLocationCoordinate2D){
        self.title = title
        self.coordinate = coordinate
    }
}




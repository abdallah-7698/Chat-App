//
//  Date.swift
//  DardeshFinal
//
//  Created by MacOS on 10/02/2022.
//

import Foundation




extension Date {
   
    func longDate ()-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    func stringDate ()-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMMyyyyHHmmss"
        return dateFormatter.string(from: self)
    }
    
    // get only the houres and ments
    func time ()-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }

    func interval(component : Calendar.Component , to date : Date)->Float{
        let currentCalender = Calendar.current
        guard let end = currentCalender.ordinality(of: component, in: .era, for: date)else{return 0}
        guard let start = currentCalender.ordinality(of: component, in: .era, for: self)else{return 0}
        return Float( end - start )
    }
    
}



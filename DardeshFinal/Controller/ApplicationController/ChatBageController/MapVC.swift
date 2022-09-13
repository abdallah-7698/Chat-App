//
//  MapVC.swift
//  DardeshFinal
//
//  Created by MacOS on 27/04/2022.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController {
    
    //MARK: - Constant
    var location : CLLocation?
    var mapView : MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
        configureLeftBarButton()
        self.title = "Map View"
        // Do any additional setup after loading the view.
    }
    
    //MARK: - HelperFunctions
    private func configureMapView(){
        mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        mapView.showsUserLocation = true
        if location != nil{
            mapView.setCenter(location!.coordinate, animated: true)
            // add annotation
            mapView.addAnnotation(MapAnnotation(title: "User Location", coordinate: location!.coordinate))
        }
        view.addSubview(mapView)
    }

    private func configureLeftBarButton(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chvron.left"), style: .plain, target: self, action: #selector(self.backButtonPressed))
    }
    
    @objc func backButtonPressed(){
        self.navigationController?.popViewController(animated: true)
    }
    
}

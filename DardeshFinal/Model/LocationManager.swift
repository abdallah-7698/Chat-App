

import Foundation
import CoreLocation

class LocationManager : NSObject , CLLocationManagerDelegate {
    
    static let shard = LocationManager()

    var locationManager : CLLocationManager?
    var currentLocation : CLLocationCoordinate2D?
    
    
    private override init(){
        super.init()
        self.requestLocationAccess()
    }
    
    // ask for the access
    func requestLocationAccess(){
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
           // we on the message app so we don't the location to be always open
            locationManager?.requestWhenInUseAuthorization()
        }else{
            print("we have already the access to the location")
        }
    }
    //listen to the location
    func startUpdating(){
        locationManager!.startUpdatingLocation()
    }
    // stop listen
    func stopUpdating(){
        if locationManager != nil{
        locationManager!.stopUpdatingLocation()
        }
    }
    
    //MARK: - delegate func
    // will call it when start the update of the location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // get the last location
        currentLocation = locations.last!.coordinate
    }
// if fail to get the location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("faild to get location" , error.localizedDescription)
    }
    // if the user didChange the aurherization
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .notDetermined {
            self.locationManager?.requestWhenInUseAuthorization()
        }
    }
    
}

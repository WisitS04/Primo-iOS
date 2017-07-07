import UIKit
import CoreLocation

class LandingPageVC: UIViewController
{
    /****
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         MARK: Get Location
         For use in foreground
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestLocation()
        let locValue: CLLocationCoordinate2D = self.locationManager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
         Dispose of any resources that can be recreated.
    }
}

extension LandingPageVC: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.authorizedWhenInUse
            || status == CLAuthorizationStatus.authorizedAlways) {
            print("The user accepted authorization")
        } else if (status == CLAuthorizationStatus.denied) {
            print("The user denied authorization")
        }
    }
    ****/
}

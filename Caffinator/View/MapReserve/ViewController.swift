

import UIKit
import MapKit
import CoreLocation
import Firebase

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var map: MKMapView!
    let manager = CLLocationManager()
    static var bikes = [Bike]()
    //hello
    
    var selectedBike : Bike? = nil;
    
    // pass this user ID into the functions in FirebaseDataManager
    let userID = "saurabhv"

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        map.setRegion(region, animated: true)
        self.map.showsUserLocation = true
        manager.stopUpdatingLocation()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self;
        self.hideKeyboardWhenTappedAround() 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ViewController.bikes = [];
        map.removeAnnotations(map.annotations)
        manager.delegate = self;
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        
        FirebaseDataManager.pullObjects {[weak self] (bike) in
            //make markers
            if (!ViewController.bikes.contains(bike)) {
                ViewController.bikes.append(bike)
                let annotation = MKPointAnnotation()
                
                //get coordinate from address
                
                let geoCoder = CLGeocoder()
                geoCoder.geocodeAddressString(bike.address) { (placemarks, error) in
                    if ((error) != nil) {
                        return;
                    } else {
                        let location = placemarks?.first?.location
                        annotation.coordinate = (location?.coordinate)!
                        annotation.title = bike.name
                        
                        if (bike.reserved == "0") {
                            annotation.subtitle = String(bike.hourly)
                        } else {
                            annotation.subtitle = "Reserved"
                        }
                        self?.map.addAnnotation(annotation)
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // TIP: read up on MKAnnotationView, and figure out the best way to display the Favorite button in the annotation view's callout view.
        if annotation is MKPointAnnotation {
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "place")
            MKPinAnnotationView.redPinColor()
            annotationView.rightCalloutAccessoryView = ViewController.reserveButton();
            annotationView.animatesDrop = true
            annotationView.canShowCallout = true;
            return annotationView
        }
        return nil
    }
    
    /*
     * This MKMapViewDelegate method will be triggered when the user taps on the Reserve button in the annotation callout view.
     */
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let nameofbike = view.annotation?.title;
        
        for bike in ViewController.bikes {
            //check if user already reserved a bike
            if (bike.reserved == Auth.auth().currentUser?.uid) {
                //alert that bike has been reserved already!
                let alertController = UIAlertController(title: "Error", message: "You already have an item reserved", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
            }
        }
        
        for bike in ViewController.bikes {
            if (bike.name == nameofbike!) {
                
                //check if this is your bike
                if (bike.ownersid == Auth.auth().currentUser?.uid) {
                    let alertController = UIAlertController(title: "Error", message: "This is your bike!", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    present(alertController, animated: true, completion: nil)
                }
                
                //pass this bike to next view
                selectedBike = bike
                
                if (selectedBike?.reserved == "0") {
                    performSegue(withIdentifier: "reserve", sender: view)
                } else {
                    //alert that bike has been reserved already!
                    let alertController = UIAlertController(title: "Error", message: "This item is already reserved.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    present(alertController, animated: true, completion: nil)
                }
                
            }
        }
        
    }
    
    /*
     * The "Favorite" button
     */
    static func reserveButton() -> UIButton {
        let resButton = UIButton(type: .system)
        resButton.setTitle("Reserve", for: .normal)
        resButton.sizeToFit()
        return resButton
    }
    
    
    
    //pass bike to reserve screen, or pass member to add bike screen
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "reserve") {
            let vc = segue.destination as! ReserveViewController
            vc.bike = selectedBike
        }
     }
    
}


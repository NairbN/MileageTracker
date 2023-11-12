//
//  TrackerCellVC.swift
//  MileageTracker
//
//  Created by Brian Nguyen on 6/29/23.
//

import UIKit
import CoreData
import CoreLocation
import MapKit

class TrackerCellVC: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var totalMilesLabel: UILabel!
    @IBOutlet weak var myMap: MKMapView!
    @IBOutlet weak var directions: UITextView!
    
    var myLocMgr = CLLocationManager()
    var myGeoCoder = CLGeocoder()
    var fromPlacemark : CLPlacemark?
    var toPlacemark : CLPlacemark?
    
    var fromAddress : String!
    var toAddress : String!
    var dateAndTime : Date!
    var totalMiles : Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myLocMgr.delegate = self
        myLocMgr.requestWhenInUseAuthorization()
        myMap.delegate = self
        myMap.showsUserLocation = true
        
        fromLabel.text = fromAddress
        toLabel.text = toAddress
        dateAndTimeLabel.text = dateAndTime.description
        
        myGeoCoder.geocodeAddressString(fromAddress, completionHandler: {
            placemarks,error in
            
            if error != nil {
                print(error!)
                return
            }
            
            if placemarks != nil && placemarks!.count > 0 {
                let placemark = placemarks![0] as CLPlacemark
                self.fromPlacemark = placemark
                
                let annotation = MKPointAnnotation()
                annotation.title = placemark.name
                annotation.coordinate = placemark.location!.coordinate
                self.myMap.addAnnotation(annotation)
                self.myMap.showAnnotations([annotation], animated: true)
            }
        })
        
        myGeoCoder.geocodeAddressString(toAddress, completionHandler: {
            placemarks,error in
            
            if error != nil {
                print(error!)
                return
            }
            
            if placemarks != nil && placemarks!.count > 0 {
                let placemark = placemarks![0] as CLPlacemark
                self.toPlacemark = placemark
                
                let annotation = MKPointAnnotation()
                annotation.title = placemark.name
                annotation.coordinate = placemark.location!.coordinate
                self.myMap.addAnnotation(annotation)
                self.myMap.showAnnotations([annotation], animated: true)
            }
        })
        
        let dirReq = MKDirections.Request()
        let transType = MKDirectionsTransportType.automobile
        var myRoute : MKRoute?
        var showRoute = self.directions.text! + "\n"
        
        dirReq.source = MKMapItem(placemark: MKPlacemark(placemark: self.fromPlacemark!))
        dirReq.destination = MKMapItem(placemark: MKPlacemark(placemark: self.toPlacemark!))
//        dirReq.source = MKMapItem.forCurrentLocation()
//        dirReq.destination = MKMapItem.forCurrentLocation()
        dirReq.transportType = transType
        
        let myDirections = MKDirections(request: dirReq) as MKDirections
        myDirections.calculate(completionHandler: {
            routeResponse, routeError in
            
            if routeError != nil {
                print(routeError!)
                return
            }
            
            myRoute = routeResponse?.routes[0] as MKRoute?

            self.myMap.removeOverlays(self.myMap.overlays)
            self.myMap.addOverlay((myRoute?.polyline)!, level: MKOverlayLevel.aboveRoads)
            
            let rect = myRoute?.polyline.boundingMapRect
            self.myMap.setRegion(MKCoordinateRegion(rect!), animated: true)
            
            if let steps = myRoute?.steps as! [MKRoute.Step]? {
                for step in steps {
                    showRoute = showRoute + step.instructions + "\n"
                }
                self.directions.text = showRoute
            }
        })
        totalMilesLabel.text = myRoute?.distance.description

        
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 2.0
        return renderer
    }
    
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

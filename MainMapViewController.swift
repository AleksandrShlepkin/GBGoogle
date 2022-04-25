//
//  ViewController.swift
//  GBGoogleMap
//
//  Created by Mac on 24.04.2022.
//

import UIKit
import GoogleMaps

class MainMapViewController: UIViewController {
    
    
    @IBOutlet weak var mainMap: GMSMapView!
    var marker: CLLocationCoordinate2D?
    var manualMarker: GMSMarker?
    var geoCoder: CLGeocoder?
    var localManager: CLLocationManager?
    let defaultCoordinate = CLLocation(latitude: 55.7522, longitude: 37.6156)
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    var defaultZoom: Float = 18.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        configMap()
        delegateManager()
    }
    
    
    @IBAction func plusButton(_ sender: Any) {
        mainMap.animate(toZoom: defaultZoom + 1.5 )
    }
    
    @IBAction func minusButton(_ sender: Any) {
        mainMap.animate(toZoom: defaultZoom - 1.5 )
    }
    

    
    private func configMap() {
        let camera = GMSCameraPosition.camera(withTarget: defaultCoordinate.coordinate, zoom: defaultZoom)
        
        mainMap.camera = camera
        mainMap.delegate = self
        mainMap.isMyLocationEnabled = true
        mainMap.settings.myLocationButton = true
        
        
    }
    private func delegateManager() {
        
        localManager = CLLocationManager()
        localManager?.delegate = self
        localManager?.requestAlwaysAuthorization()
        localManager?.allowsBackgroundLocationUpdates = true
        localManager?.startUpdatingLocation()
    }
    
    
    
}

extension MainMapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        let  manualMarker = GMSMarker(position: coordinate)
        manualMarker.map = mainMap
        self.mainMap.animate(toLocation: coordinate)
        if geoCoder == nil {
            geoCoder = CLGeocoder()
        }
        geoCoder?.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), completionHandler: { places, err in
            print(places?.last as Any)
        })
        
    }
}

extension MainMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        routePath?.add(location.coordinate)
        route?.path = routePath
        
        let selfPosition = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: defaultZoom)
        mainMap.animate(to: selfPosition)
        
    }
}

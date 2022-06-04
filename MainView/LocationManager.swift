//
//  LocationManager.swift
//  GBGoogleMap
//
//  Created by Mac on 03.06.2022.
//

import Foundation
import GoogleMaps
import CoreLocation
import RxSwift
import RxCocoa
import RxRelay

final class LocationManager: NSObject {
    static let instance = LocationManager()
    let locationManager = CLLocationManager()
    let location = BehaviorRelay<CLLocation?>(value: nil)
    
    
    private override init() {
        super.init()
        
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    private func startLocationManager() {
        locationManager.delegate = self
        locationManager.activityType = .automotiveNavigation
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.requestAlwaysAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.location.accept(locations.last)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

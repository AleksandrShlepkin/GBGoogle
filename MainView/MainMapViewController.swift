//
//  ViewController.swift
//  GBGoogleMap
//
//  Created by Mac on 24.04.2022.
//

import UIKit
import GoogleMaps
import RxSwift
import RxCocoa
import RxRelay

class MainMapViewController: UIViewController {
    //Ссылка на appCoordinator
    weak var mainView: MainView?
    
    let disponseBag = DisposeBag()
    
    @IBOutlet weak var mainMap: GMSMapView!
    
    var marker: GMSMarker?
    var manualMarker: GMSMarker?
    var geoCoder: CLGeocoder?
    let locationManager = LocationManager.instance
    let defaultCoordinate = CLLocation(latitude: 55.7522, longitude: 37.6156)
    
    let distance = BehaviorSubject<Double>(value: 0.0)
    let track = BehaviorRelay<Bool>(value: false)
    
    
    var route: GMSPolyline?
    var routePath = GMSMutablePath()
    var defaultZoom: Float = 18.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configMap()
        configLocationManager()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        mainMap.clear()
    }
    
    
    @IBAction func plusButton(_ sender: Any) {
        plusZoom()
    }
    
    @IBAction func minusButton(_ sender: Any) {
        minusZoom()
    }
    
    
    //Two funcs for zoom, later I will invent something better
    func plusZoom() {
        defaultZoom += Float(0.5)
        mainMap.animate(toZoom: defaultZoom )
        
    }
    func minusZoom() {
        defaultZoom -= Float(0.5)
        mainMap.animate(toZoom: defaultZoom )
    }
    
    func initTrack() {
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        distance.onNext(-1)
    }
    
    func addMarker(newCoordinate: CLLocationCoordinate2D) {
        marker = GMSMarker(position: newCoordinate)
        marker?.icon = UIImage.init(systemName: "figure.wave")
        marker?.map = mainMap
    }
    
    func removeMarker() {
        marker?.map = nil
        marker = nil
    }
    
    func viewTrack() {
        route?.strokeColor = .red
        route?.strokeWidth = 3.0
        route?.geodesic = true
        route?.map = mainMap
        let pathLen = GMSGeometryLength(routePath)
        distance
            .asObserver()
            .onNext(round(pathLen))
    }
    
    @IBAction func locationButton(_ sender: UIButton) {
        
        locationManager.startUpdatingLocation()
        initTrack()
        track.accept(true)
        
    }
    
    private func configMap() {
        let camera = GMSCameraPosition.camera(withTarget: defaultCoordinate.coordinate, zoom: defaultZoom)

        mainMap.camera = camera
        mainMap.isMyLocationEnabled = true
        mainMap.settings.myLocationButton = true
        mainMap.delegate = self

        
    }
    
    func configLocationManager() {
        locationManager.location
            .asObservable()
            .bind { [weak self] location in
                guard let location = location else { return }
                self?.routePath.add(location.coordinate)
                self?.route?.path = self?.routePath
                let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
                self?.mainMap.animate(to: position)
                self?.removeMarker()
                self?.addMarker(newCoordinate: location.coordinate)
                self?.viewTrack()
            }
            .disposed(by: disponseBag)
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





//extension MainMapViewController: CLLocationManagerDelegate {
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        if flag == true {
//        guard let location = locations.last else { return }
//        routePath?.add(location.coordinate)
//        route?.path = routePath
//
//        let selfPosition = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: defaultZoom)
//        mainMap.animate(to: selfPosition)
//        let  manualMarker = GMSMarker(position: location.coordinate)
//
//        manualMarker.map = mainMap
//        if route?.map == nil {
//            localManager?.requestLocation()
//            route?.map = nil
//            route = GMSPolyline()
//            routePath =  GMSMutablePath()
//            route?.map = mainMap
//            localManager?.startUpdatingLocation()
//
//        } else {
//            route?.map = nil
//        }
//
//        } else {
//            return
//        }
//
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error)
//    }
//}

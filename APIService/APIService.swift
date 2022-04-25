//
//  APIService.swift
//  GBGoogleMap
//
//  Created by Mac on 25.04.2022.
//

import Foundation
import GoogleMaps
import Alamofire
import SwiftyJSON


struct APIService {
    
    
    private static var routesArray: [Route] = []
    private static var durationArray: [Duration] = []
    
    
    static func duration(src: String, dst: String) {
        
        let url =
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=\(src),DC&destinations=\(dst)&key=\(APIKey.apiKey)"
        
        
        AF.request(url).responseJSON { (reseponse) in
            guard let data = reseponse.data else {
                return
            }
            
            do {
                let jsonData = try JSON(data: data)
                let rows = jsonData["rows"].arrayValue
                
                for row in rows {
                    let elements = row["elements"].arrayValue
                    for element in elements {
                        let duration = element["duration"].dictionary
                        
                        if let text = duration?["text"]?.string {
                            let duration = Duration(text: text)
                            self.durationArray += [duration]
                        }
                    }
                }
                    
                self.durationArray.forEach {
                    print($0)
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    //draw path
    static func draw(src: CLLocationCoordinate2D, dst: CLLocationCoordinate2D){
        
        // source location and destination
        let sourceLocation = "\(src.latitude),\(src.longitude)"
        let destinationLocation = "\(dst.latitude),\(dst.longitude)"
        
        // Create URL
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(sourceLocation)&destination=\(destinationLocation)&mode=driving&key=\(APIKey.apiKey)"
        
        // request
        AF.request(url).responseJSON { (reseponse) in
            guard let data = reseponse.data else {
                return
            }
            
            do {
                let jsonData = try JSON(data: data)
                let routes = jsonData["routes"].arrayValue
                
                //convert route into our Route model
                for route in routes {
                    let overview_polyline = route["overview_polyline"].dictionary
                    let points = overview_polyline?["points"]?.string
                    let r = Route(points: points)
                    self.routesArray += [r]
                }
                
                // asyn update ui
                DispatchQueue.main.async {
                    for route in self.routesArray {
                        let path = GMSPath.init(fromEncodedPath: route.points ?? "")
                        let polyline = GMSPolyline.init(path: path)
                        polyline.strokeColor = .systemBlue
                        polyline.strokeWidth = 5
//                        polyline.map = self.mainMap
                    }
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
        
        // test data for source Marker
        let sourceMarker = GMSMarker()
        sourceMarker.position = src
        var data = [String : String]()
        data["name"] = "meng"
        sourceMarker.userData = data
//        sourceMarker.map = self.mapView
        
        //customize icon
//        let pin = UIImage(named: "car.png")!.resize(targetSize: CGSize(width: 40, height: 40))
//        sourceMarker.icon = pin
        
        // test data for destinatio Marker
        let destinationMarker = GMSMarker()
        destinationMarker.position = dst
        destinationMarker.title = "Gurugram"
        destinationMarker.snippet = "The hub of industries"
//        destinationMarker.map = self.mapView
        
        let camera = GMSCameraPosition(target: sourceMarker.position, zoom: 10)
//        self.mapView.animate(to: camera)
    }
}

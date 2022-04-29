//
//  RealmModel.swift
//  GBGoogleMap
//
//  Created by Mac on 27.04.2022.
//

import Foundation
import RealmSwift
import GoogleMaps

//protocol DB {
//    func save(marker: RealmModel, coordinats: RealmModel)
//    func getObject() -> [RealmModel]
//}
//
//final class RealmModel: Object {
//    @objc dynamic var markers = GMSMarker()
//    @objc dynamic var coordinats =  CLLocationCoordinate2D()
//    
//}
//
//
//final class ManagerDB: DB {
//    
//    fileprivate lazy var mainRealm = try! Realm(configuration: .defaultConfiguration, queue: .global())
//    
//    func save(marker: RealmModel, coordinats: RealmModel) {
//        
//      try! mainRealm.write {
//          mainRealm.add(marker)
//          mainRealm.add(coordinats)
//        }
//    }
//    
//    func getObject() -> [RealmModel] {
//        
//        let models = mainRealm.objects(RealmModel.self)
//        return Array(models)
//    }
//    
//    
//}

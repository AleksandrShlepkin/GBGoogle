//
//  CoordinatorProtocol.swift
//  GBGoogleMap
//
//  Created by Mac on 22.05.2022.
//

import Foundation
import UIKit

protocol Coordinator {
    var parentCoordinator: Coordinator? { get set }
    var childCoordinator: [Coordinator] { get set }
    var navigation: UINavigationController { get set }
    func start()
}

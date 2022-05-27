//
//  AppCoordinator.swift
//  GBGoogleMap
//
//  Created by Mac on 22.05.2022.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinator: [Coordinator] = []
    var navigation: UINavigationController
    var storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    
    init(navigator: UINavigationController) {
        self.navigation = navigator
    }
    
    func start() {
        goToLogin()
    }
    
    func goToLogin() {
        guard let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                as? LoginViewController else { return }
        let loginViewModel = LoginViewModel()
        loginViewModel.appCoordinator = self
        loginVC.viewModel = loginViewModel
        navigation.pushViewController(loginVC, animated: true)
        
    }
    
    func goToRegister() {
        guard let regVc = storyboard.instantiateViewController(withIdentifier: "RegistrationViewController")
                as? RegistrationViewController else { return }
        let registerModel = RegistrationViewModel()
        registerModel.appCoordinator = self
        regVc.viewModel = registerModel
        navigation.pushViewController(regVc, animated: true)
        
    }
    
    func goToMainView() {
        guard let mainVC = storyboard.instantiateViewController(withIdentifier: "MainMapViewController") as? MainMapViewController else { return }
        let mainView = MainView()
        mainView.appCoordinator = self
        mainVC.mainView = mainView
        navigation.pushViewController(mainVC, animated: true)
        
        
    }
    
}

//
//  LoginViewController.swift
//  GBGoogleMap
//
//  Created by Mac on 22.05.2022.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    //MARK: Не понимаю почему если делаешь ссылку на view weak то координатор не работает?
   var viewModel: LoginViewModel?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBOutlet weak var loginTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func logInButton(_ sender: UIButton) {
        singUp()
    }
    @IBAction func registerbutton(_ sender: UIButton) {
        viewModel?.appCoordinator?.goToRegister()
    }
    
    func singUp() {
        guard let login = loginTextField.text, loginTextField.hasText,
              let password = passwordTextField.text, passwordTextField.hasText  else {
                  return showAlert(title: "Упс!", text: "Не все поля заполнены")
              }
        Auth.auth().signIn(withEmail: login, password: password) { authResult , error in
            if error != nil {
                self.showAlert(title: "Неверный логин/пароль",
                               text: "Возможно Вы не прошли регистрацию?")
            } else {
                self.viewModel?.appCoordinator?.goToMainView()
            }
        }
    }
    
    
    
    func showAlert(title: String?, text: String?) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let okControl = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okControl)
        self.present(alert, animated: true, completion: nil)
    }

}

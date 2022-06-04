//
//  RegistrationViewController.swift
//  GBGoogleMap
//
//  Created by Mac on 23.05.2022.
//

import UIKit
import Firebase
import FirebaseAuth

class RegistrationViewController: UIViewController {

    var viewModel: RegistrationViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var replayPswwordTextField: UITextField!
    
    
    @IBAction func registrationButton(_ sender: UIButton) {
        registrationUser()
    }
    
    func registrationUser() {
        
        guard let login = loginTextField.text, loginTextField.hasText,
              let name = nameTextField.text, nameTextField.hasText,
              let password = passwordTextField.text, passwordTextField.hasText else {
                  return self.showAlert(title: "Ошибка",
                                        text: "Не все поля заполнены")
              }
        
        guard let replayPassword = replayPswwordTextField.text,
              replayPassword == password else {
                  return self.showAlert(title: "Ошибка",
                                        text: "Пароли не совпадают")
              }
        Auth.auth().createUser(withEmail: login, password: password) { authResult , error  in
            if error != nil {
                print(error ?? "")
                self.showAlert(title: "Ошибка", text: "Упс, что то пошло не так ")
            } else {
                let db = Firestore.firestore()
                db.collection("Users").addDocument(data: ["login": login,
                                                          "name": name,
                                                          "password": password]) { error  in
                    if error != nil {
                        self.showAlert(title: "Something went wrong", text: "Ooop's")
                    }
                }
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

//
//  LoginViewController.swift
//  GBGoogleMap
//
//  Created by Mac on 22.05.2022.
//

import UIKit
import Firebase
import FirebaseAuth
import RxSwift
import RxCocoa


class LoginViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    //MARK: Не понимаю почему если делаешь ссылку на view weak то координатор не работает?
   var viewModel: LoginViewModel?
    
    
    @IBOutlet weak var loginOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configLoginButton()

    }
    @IBOutlet weak var loginTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    

    @IBAction func registerbutton(_ sender: UIButton) {
        viewModel?.appCoordinator?.goToRegister()
    }
    
    
    func configLoginButton() {
        Observable.combineLatest(
            loginTextField.rx.text,
            passwordTextField.rx.text)
            .map { _ in
                //TODO: Как настроить так, что б кнопка не отрабатывала сама, а только по нажатию? Сейчас получается как только вводишь 6 символов в пароль, она автоматом нажимается.
                return self.singUp()
            }
            .bind { [weak loginOutlet] inputFilled in
                loginOutlet?.isEnabled = inputFilled
            }
            .disposed(by: disposeBag)
    }
    
    func singUp() -> Bool {
        guard let login = loginTextField.text, loginTextField.hasText,
              let password = passwordTextField.text, passwordTextField.hasText,
              password.count >= 6  else {
                  return false
              }
        Auth.auth().signIn(withEmail: login, password: password) { authResult , error in
            if error != nil {
                self.showAlert(title: "Неверный логин/пароль",
                               text: "Возможно Вы не прошли регистрацию?")
            } else {
                self.viewModel?.appCoordinator?.goToMainView()
            }
        }
        return true
    }
    
    
    
    func showAlert(title: String?, text: String?) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let okControl = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okControl)
        self.present(alert, animated: true, completion: nil)
    }

}

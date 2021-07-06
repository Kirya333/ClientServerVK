//
//  LoginFormController.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 05.07.2021.
//

import UIKit

class LoginFormController: UIViewController {
        
        @IBOutlet weak var scrollView: UIScrollView!
        
        @IBOutlet weak var loginTextField: UITextField!
        
        @IBOutlet weak var passwordTextField: UITextField!
        
        @IBOutlet weak var enterButton: UIButton!
        
        @IBOutlet weak var nameNetwork: UILabel!
        
        @IBOutlet weak var loginLabel: UILabel!
        
        @IBOutlet weak var passwordLabel: UILabel!
        
       
        
        
        
        let fromLoginToTabBar = "fromLoginToTabBar"
        
        
        
        func animateTitlesAppearig() {
            let offset = view.bounds.width
            loginLabel.transform = CGAffineTransform(translationX: -offset, y: 0)
            passwordLabel.transform = CGAffineTransform(translationX: offset, y: 0)
            
            UIView.animate(withDuration: 1,
                           delay: 1,
                           options: .curveEaseOut,
                           animations: {[weak self] in
                            self?.loginLabel.transform = .identity
                            self?.passwordLabel.transform = .identity
                           },
                           completion: nil)
        }
        
        
        func animateTitleAppearing() {
            self.nameNetwork.transform = CGAffineTransform(translationX: 0, y: -self.view.bounds.height/2)
            
            UIView.animate(withDuration: 1,
                           delay: 1,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0,
                           options: .curveEaseOut,
                           animations: {[weak self] in
                            self?.nameNetwork.transform = .identity
                           },
                           completion: nil)
        }
        
        
        func animateFieldsAppearing() {
            let fadeInAnimate = CABasicAnimation(keyPath: "opacity")
            fadeInAnimate.fromValue = 0
            fadeInAnimate.toValue = 1
            fadeInAnimate.duration = 1
            fadeInAnimate.beginTime = CACurrentMediaTime() + 3
            fadeInAnimate.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            fadeInAnimate.fillMode = CAMediaTimingFillMode.backwards
            
    //        guard let self = self else { return }
            self.loginTextField.layer.add(fadeInAnimate, forKey: nil)
            self.passwordTextField.layer.add(fadeInAnimate, forKey: nil)
        }
        
        
        func animateEnterButton() {
            let animation = CASpringAnimation(keyPath: "transform.scale")
            animation.fromValue = 0
            animation.toValue = 1
            animation.stiffness = 200
            animation.mass = 2
            animation.duration = 2
            animation.beginTime = CACurrentMediaTime() + 2
            animation.fillMode = CAMediaTimingFillMode.backwards
            
            self.enterButton.layer.add(animation, forKey: nil)
        }
        
        
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            animateTitlesAppearig()
            animateTitleAppearing()
            animateFieldsAppearing()
            animateEnterButton()
        }
        
        
        
        @objc func hideKeyboard() {
            self.scrollView?.endEditing(true)
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            let hideKeyboardGesture = UITapGestureRecognizer (target: self, action: #selector(hideKeyboard))
            scrollView?.addGestureRecognizer(hideKeyboardGesture)
        }
        
        
        func alertInfo(answer: String, message: String, button: String) {
            let alert = UIAlertController(title: answer, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: button, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
        
        
        @IBAction func enterButtonPressed(_ sender: Any) {

            let login = loginTextField.text!

            let password = passwordTextField.text!

            if login == "admin" && password == "123456" {
                print("Successful authorization")
    //            alertInfo(answer: "Successful authorization", message: "Welcome", button: "OK")
                
                performSegue(withIdentifier: fromLoginToTabBar, sender: nil)
                
            } else {
                print("Failed authorization")
                alertInfo(answer: "Failed authorization", message: "Check your login or password", button: "OK")
            }
        }
        
    }


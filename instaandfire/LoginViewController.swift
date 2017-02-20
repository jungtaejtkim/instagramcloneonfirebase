//
//  LoginViewController.swift
//  instaandfire
//
//  Created by KimJungtae on 2017. 2. 20..
//  Copyright © 2017년 Jungtae Kim. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var activityIndicator = UIActivityIndicatorView()
    
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }

    
    
    
    @IBAction func loginButton(_ sender: Any) {
        
        if emailField.text == "" || passwordField.text == "" {
            
            createAlert(title: "Log-in error", message: "You should input your email and password")
            
            
        } else {
            
            print("signin button")
            
        }
        
        
    }
    
    @IBAction func signUpButton(_ sender: Any) {
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
}

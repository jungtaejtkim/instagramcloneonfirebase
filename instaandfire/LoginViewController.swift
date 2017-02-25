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
    
    
    
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = FIRAuth.auth()?.currentUser {
        print(FIRAuth.auth()!.currentUser!.uid)
        }
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if user != nil {
                print(user!)
                self.shiftVC()
            } else {
                
                print("unauthorized")
                
            }
        })
    }

    
    
    
    @IBAction func loginButton(_ sender: Any) {
        
        if emailField.text == "" || passwordField.text == "" {
            
            self.createAlert(title: "Log-in error", message: "You should input your email and password")
            
            
        } else {
            
        
            
            FIRAuth.auth()?.signIn(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: { (user, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    self.createAlert(title: "Error", message: "Something wrong with Log-in Try again.")
                
                } else {
                    print("signin success")
                    
                    
                    self.shiftVC()
    
                }
                
            })
            
        }
        
        
    }
    
    func shiftVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let userVC = storyboard.instantiateViewController(withIdentifier: "userVC") as! UIViewController
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        
        appdelegate.window?.rootViewController = userVC
        
    }
    
    @IBAction func signUpButton(_ sender: Any) {
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
}

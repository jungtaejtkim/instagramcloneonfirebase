//
//  SignUpViewController.swift
//  instaandfire
//
//  Created by KimJungtae on 2017. 2. 20..
//  Copyright © 2017년 Jungtae Kim. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nextButtonOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    
    var activityIndicator = UIActivityIndicatorView()
    
    
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func selectButton(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()

        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImage.image = image
            self.activityIndicator.stopAnimating()
            
            UIApplication.shared.endIgnoringInteractionEvents()
    
        }
        
        self.dismiss(animated: true, completion: nil)
        self.nextButtonOutlet.isHidden = false
    }
    
    
    
    @IBAction func nextButton(_ sender: Any) {
        
        
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

}

//
//  SignUpViewController.swift
//  instaandfire
//
//  Created by KimJungtae on 2017. 2. 20..
//  Copyright © 2017년 Jungtae Kim. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class SignUpViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nextButtonOutlet: UIButton!
    
    var userStorage : FIRStorageReference!
    var userRef : FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let storage = FIRStorage.storage().reference()
        userStorage = storage.child("users")
        
        let dataBase = FIRDatabase.database().reference()
        userRef = dataBase.child("userInfo")
        
        
    }

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
        
    
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImage.image = image
    
        }
        
        self.dismiss(animated: true, completion: nil)
        self.nextButtonOutlet.isHidden = false
    }
    
    
    
    @IBAction func nextButton(_ sender: Any) {
        
        guard emailField.text != "", nameField.text != "", passwordField.text != "", confirmField.text != "" else {
            return createAlert(title: "Error", message: "You put wrong input")
        }
        
        if passwordField.text == confirmField.text {
            FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
                
                if error != nil {
                    self.createAlert(title: "Error", message: "Something wrong, try again")
                    print((error?.localizedDescription)!)
                    
                } else {
                    
                    let chageRequest = FIRAuth.auth()!.currentUser!.profileChangeRequest()
                    chageRequest.displayName = self.nameField.text!
                    chageRequest.commitChanges(completion: nil)
                    
                    let metaData = FIRStorageMetadata()
                    metaData.contentType = "image/jpg"
                    let data = UIImageJPEGRepresentation(self.profileImage.image!, 0.1)
                    let filePath = "\(user!.uid)"
                    let imageStorage = self.userStorage.child(filePath).put(data!, metadata: metaData, completion: { (metaData, error) in
                        if error != nil {
                            print((error?.localizedDescription)!)
                            
                            
                        }
                        let fileUrl = metaData?.downloadURLs![0].absoluteString
                        
                        let newuserRef = self.userRef.child(user!.uid)
                        let newuserContents : [String: Any] = ["uid":user!.uid, "photo" : fileUrl, "fullname" : self.nameField.text!]
                        
                        newuserRef.setValue(newuserContents)
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        
                        let userVC = storyboard.instantiateViewController(withIdentifier: "userVC") as! UIViewController
                        
                        let appdelegate = UIApplication.shared.delegate as! AppDelegate
                        
                        appdelegate.window?.rootViewController = userVC

                            
                            
                        
                    })
                    imageStorage.resume()
                    
                }
            })
            
            
        } else {
            
            createAlert(title: "Error", message: "Your password does not match")
        }
        
        
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

}

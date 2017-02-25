//
//  PostViewController.swift
//  instaandfire
//
//  Created by KimJungtae on 2017. 2. 24..
//  Copyright © 2017년 Jungtae Kim. All rights reserved.
//

import UIKit
import Firebase

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imagetoPost: UIImageView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var postButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
    @IBAction func selectPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imagetoPost.image = image
            
        }
        
        self.dismiss(animated: true, completion: nil)
        self.postButton.isHidden = false
        self.selectButton.isHidden = true
    }
    

    
    @IBAction func postPressed(_ sender: Any) {
        AppDelegate.instance().showActivityIndicator()
        let uid = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference()
        let storage = FIRStorage.storage().reference()
        let key = ref.child("posts").childByAutoId().key
        let imageRef = storage.child("posts").child(uid!).child("\(key).jpg")
        
        let data = UIImageJPEGRepresentation(self.imagetoPost.image!, 0.2)
        
        let uploadtask = imageRef.put(data!, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                AppDelegate.instance().dismissActivityIndicatos()
            } else {
                imageRef.downloadURL(completion: { (url, error) in
                    if let url = url {
                        
                        let feed = ["uid":uid, "url":url.absoluteString, "likes": 0,"author":FIRAuth.auth()!.currentUser!.displayName!, "postID" : key] as [String : Any]
                        
                        let postfeed = ["\(key)" : feed]
                        
                        ref.child("posts").updateChildValues(postfeed)
                        
                        AppDelegate.instance().dismissActivityIndicatos()
                        self.dismiss(animated: true, completion: nil)
                    }
                })
                
        
                
                
            }
            
        }
        uploadtask.resume()
        
    }
    
}

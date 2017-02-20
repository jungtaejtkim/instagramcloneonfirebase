//
//  ViewController.swift
//  instaandfire
//
//  Created by Jungtae Kim on 2017. 2. 19..
//  Copyright © 2017년 Jungtae Kim . All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
            if error != nil {
                
                print((error?.localizedDescription)!)
                
            } else {
                
                print((user?.uid)!)
                
                //test sss
                //test again
            }})
        
        let rootRef = FIRDatabase.database().reference()
        let testRef = rootRef.child("message")
        
        let test = testRef.childByAutoId()
        
        let testDict = ["name": "jtk", "purpose" : "test"]
        
        test.setValue(testDict)
        print(test)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


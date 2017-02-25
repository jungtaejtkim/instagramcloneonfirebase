//
//  PostCollectionViewCell.swift
//  instaandfire
//
//  Created by KimJungtae on 2017. 2. 24..
//  Copyright © 2017년 Jungtae Kim. All rights reserved.
//

import UIKit
import Firebase

class PostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var unlikeButton: UIButton!
    @IBOutlet weak var userPostLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    
    var postID: String!
    
    
    
    @IBAction func likePressed(_ sender: Any) {
        self.likeButton.isEnabled = false
        let ref = FIRDatabase.database().reference()
        let keyToPost = ref.child("posts").childByAutoId().key
        
        ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let post = snapshot.value as? [String : AnyObject] {
                let updateLikes: [String : Any] = ["peopleWhoLike/\(keyToPost)" : FIRAuth.auth()!.currentUser!.uid]
                ref.child("posts").child(self.postID).updateChildValues(updateLikes, withCompletionBlock: { (error, reff) in
                    
                    if error == nil {
                        ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snap) in
                            if let properties = snap.value as? [String : AnyObject] {
                                if let likes = properties["peopleWhoLike"] as? [String : AnyObject] {
                                    let count = likes.count
                                    self.likeLabel.text = "\(count) Likes"
                                    
                                    let update = ["likes" : count]
                                    ref.child("posts").child(self.postID).updateChildValues(update)
                                    
                                    self.likeButton.isHidden = true
                                    self.unlikeButton.isHidden = false
                                    self.likeButton.isEnabled = true
                                }
                            }
                        })
                    }
                })
            }
            
            
        })
        
        ref.removeAllObservers()
    }
    
    @IBAction func unlikePressed(_ sender: Any) {
        self.unlikeButton.isEnabled = false
        let ref = FIRDatabase.database().reference()
        
        
        ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let properties = snapshot.value as? [String : AnyObject] {
                if let peopleWhoLike = properties["peopleWhoLike"] as? [String : AnyObject] {
                    for (id,person) in peopleWhoLike {
                        if person as? String == FIRAuth.auth()!.currentUser!.uid {
                            ref.child("posts").child(self.postID).child("peopleWhoLike").child(id).removeValue(completionBlock: { (error, reff) in
                                if error == nil {
                                    ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snap) in
                                        if let prop = snap.value as? [String : AnyObject] {
                                            if let likes = prop["peopleWhoLike"] as? [String : AnyObject] {
                                                let count = likes.count
                                                self.likeLabel.text = "\(count) Likes"
                                                ref.child("posts").child(self.postID).updateChildValues(["likes" : count])
                                            }else {
                                                self.likeLabel.text = "0 Likes"
                                                ref.child("posts").child(self.postID).updateChildValues(["likes" : 0])
                                            }
                                        }
                                    })
                                }
                            })
                            
                            self.likeButton.isHidden = false
                            self.unlikeButton.isHidden = true
                            self.unlikeButton.isEnabled = true
                            break
                            
                        }
                    }
                }
            }
            
        })
        ref.removeAllObservers()
    }

    }


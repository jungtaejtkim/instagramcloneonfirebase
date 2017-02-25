//
//  FeedViewController.swift
//  instaandfire
//
//  Created by KimJungtae on 2017. 2. 24..
//  Copyright © 2017년 Jungtae Kim. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var postsArray = [Post]()
    var followingArray = [String]()
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPost()
//        test()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    func test() {
        
        FIRDatabase.database().reference().child("userInfo").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            
        })
        
    }
    func fetchPost() {
        
        let myuid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        
        
        ref.child("userInfo").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            let dict = snapshot.value as! [String:AnyObject]
            
//                self.posts.removeAll()
//                self.following.removeAll()
                for (_, value) in dict {
                    
                    if let thisuser = value["uid"] as? String {
                        
                        if thisuser == myuid {
                            
                            if let followings = value["following"] as? [String : String]{
                                for (_, user) in followings {
                                    
                                    self.followingArray.append(user)
                                }
                            }
                            self.followingArray.append(myuid)
                            
                            ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
                                let posts = snap.value as! [String:AnyObject]
                                for (_, value2) in posts {
                                    if let userId = value2["uid"] as? String {
                                        
                                        for user in self.followingArray {
                                            if user == userId {
                                                
                                                let postInfo = Post()
                                                if let author = value2["author"] as? String, let postID = value2["postID"] as? String, let url = value2["url"] as? String, let likes = value2["likes"] as? Int {
                                                    postInfo.author = author
                                                    postInfo.imageUrl = url
                                                    postInfo.likes = likes
                                                    postInfo.postId = postID
                                                    postInfo.userId = myuid
                                                    if let people = value2["peopleWhoLike"] as? [String : AnyObject] {
                                                        for (_,person) in people {
                                                            postInfo.peopleWhoLike.append(person as! String)
                                                          
                                                        }
                                                    }
                                                    
                                                    self.postsArray.append(postInfo)
                                                    
                                                    
                                                }
                                            }
                                        }
                                        self.collectionView.reloadData()
                                        
                                    }
                                }
                                
                            })
                        }
                        
                        
                        
                    }
            
                }
                
            
        })

        ref.removeAllObservers()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsArray.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PostCollectionViewCell
        
        cell.postImage.downloadimage(url: postsArray[indexPath.row].imageUrl)
        cell.userPostLabel.text = postsArray[indexPath.row].author
        cell.likeLabel.text = "\(postsArray[indexPath.row].likes!) Likes"
        cell.postID = postsArray[indexPath.row].postId
        
        for person in self.postsArray[indexPath.row].peopleWhoLike {
            if person == FIRAuth.auth()!.currentUser!.uid {
                cell.likeButton.isHidden = true
                cell.unlikeButton.isHidden = false
                break
            }
        }
        // 굳이 서버에서 불러올필요없이 클라이언트에서 이미 만든 array 로 한번에 하면 성능이 훨씬 빠르고 솔루션도 간단함 >_<
        
        return cell
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    

    
    
}

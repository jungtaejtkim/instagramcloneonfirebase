//
//  UserViewController.swift
//  instaandfire
//
//  Created by Jungtae Kim on 2017. 2. 20..
//  Copyright © 2017년 Jungtae Kim. All rights reserved.
//

import UIKit
import Firebase

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var user = [User]()
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveUser()
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.count 
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserTableViewCell
        
        cell.nameLabel.text = user[indexPath.row].userFullname as String
        cell.userId.text = user[indexPath.row].userId as String
        cell.userImage.downloadimage(url: user[indexPath.row].userProfile)
//
////        JT : 간만에 다른방식으로 이미지 다운로드 해 불러와봄
//        let urlString = user[indexPath.row].userProfile as! String
//        let url = URL(string: urlString)
//        let image = try? Data(contentsOf: url!)
//        let photo = UIImage(data: image!)
//        cell.userImage.image = photo


        
        
        
        checkfollowingstatus(indexPath: indexPath)
        
        return cell
        
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func logoutButton(_ sender: Any) {
        
        do {
         try FIRAuth.auth()?.signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let signVC = storyboard.instantiateViewController(withIdentifier: "signVC")
            
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            
            appdelegate.window?.rootViewController = signVC

        } catch {
            print("logout failed")
        }
    }
    
    
    func retrieveUser() {
        
        let ref = FIRDatabase.database().reference()
        let userref = ref.child("userInfo")
        
        userref.queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            
            let userinfos = snapshot.value as! [String : AnyObject]
            self.user.removeAll()
            
            for (_, value) in userinfos {
                if let uid = value["uid"] as? String {
                    if uid != FIRAuth.auth()!.currentUser!.uid {
                        let userToShow = User()
                        if let userFullName = value["fullname"] as? String, let userProfile = value["photo"] as? String {
                            userToShow.userFullname = userFullName
                            userToShow.userProfile = userProfile
                            userToShow.userId = uid
                            self.user.append(userToShow)
                        }
                        
                    }
                    
                }
            
                }
            
            
           self.tableView.reloadData()
        })
        
        ref.removeAllObservers()
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        let userRef = ref.child("userInfo")
        
        let key = userRef.childByAutoId().key
        
        var isFollowing = false
        
        print("\(indexPath.row) pressed")
        
        
        
        userRef.child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            if let users = snapshot.value as? [String : AnyObject] {
                
                for (ke, value) in users {
                    
                    if value as! String == self.user[indexPath.row].userId {
                        isFollowing = true
                        userRef.child(uid).child("following/\(ke)").removeValue()
                        userRef.child(self.user[indexPath.row].userId).child("followers/\(ke)").removeValue()
                        
                        
                        self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
                        print("unfollow")
                        
                    }
                    
                    
                }
            
            }
            // 위는 결국 팔로잉 유저에 해당 유저가 ㅇ있냐는 말
            // 아래는 팔로잉유저에 없을때 진행 
            
            if !isFollowing {
                
                let following = ["following/\(key)" : self.user[indexPath.row].userId]
                let followers = ["followers/\(key)" : uid]
                
                userRef.child(uid).updateChildValues(following)
                userRef.child(self.user[indexPath.row].userId).updateChildValues(followers)
                
                self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                // 이 메쏘드를 잘못써서 한참 헤맴 ㅠㅠㅠ
                print("follow")
                
           }
        })
        
        ref.removeAllObservers()
        
        
        
    }
    
    
    func checkfollowingstatus(indexPath: IndexPath) {
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        let userRef = ref.child("userInfo").child(uid).child("following")
        userRef.queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
           
            
            if let followings = snapshot.value as? [String: AnyObject] {
                for(_,value) in followings {
                    
                    if value as! String == self.user[indexPath.row].userId {
                        
                        self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                        
                    }
                    
                }
                
            }
            
            
        })
            ref.removeAllObservers()

        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    


}


extension UIImageView {
    
    func downloadimage(url : String) {
        let url = URL(string: url)
        let urlRequest = URLRequest(url: url!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                
                DispatchQueue.main.async {
                    self.image = UIImage(data: data!)
                }
                
                
                
                
            }
            
        }
        task.resume()
    }
    
}


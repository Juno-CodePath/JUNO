//
//  HomeViewController.swift
//  Juno
//
//  Created by Cicely Beckford on 4/13/20.
//  Copyright © 2020 Cicely Beckford. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var compatibilityLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    var count = 0
    var profiles = [PFObject]()
    var zodiac = Zodiac()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        loadProfiles()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadProfiles() {
        let query = PFQuery(className: "Profile")
        query.includeKeys(["owner", "likes", "dislikes", "matches"])
        query.limit = 20
        
        query.findObjectsInBackground { (profs, error) in
            if profs != nil {
                self.profiles = profs!
                
                if self.count >= self.profiles.count {
                    self.setBackground()
                    self.viewedAllProfiles()
                } else {
                    self.setData()
                }
            }
        }
    }
    
    func viewedAllProfiles() {
        
        let alert = UIAlertController(title: "Oh No!", message: "No more profiles.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {
            action in alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
    
    func setBackground() {
        
        var location: PFGeoPoint = PFGeoPoint()
        let profile = profiles[profiles.count - 1]
        
        let imageFile = profile["profilePhoto"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        imageView.af_setImage(withURL: url)
        
        nameLabel.text = profile["name"] as? String
        
        location = profile["location"] as! PFGeoPoint
        getAddress(location)
        compatibilityLabel.text = zodiac.getCompatibility(first: Global.shared.userProfile["sign"] as! String, second: profile["sign"] as! String)
    }
    
    func setData() {
        
        updateCount()
        if count >= profiles.count {
            loadProfiles()
            return
        }
        
        noButton.isEnabled = true
        yesButton.isEnabled = true
        
        var location: PFGeoPoint = PFGeoPoint()
        let profile = profiles[count]
        
        let imageFile = profile["profilePhoto"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        imageView.af_setImage(withURL: url)
        
        nameLabel.text = profile["name"] as? String
        
        location = profile["location"] as! PFGeoPoint
        getAddress(location)
        compatibilityLabel.text = zodiac.getCompatibility(first: Global.shared.userProfile["sign"] as! String, second: profile["sign"] as! String)
    }
    
    func updateCount() {
        
        let id = PFUser.current()?.objectId!

        while count < profiles.count {
            let dislikesArray = profiles[count]["dislikes"] as? Array<String>
            
            let userLikes = Global.shared.userProfile["likes"] as? Array<String>
            let userDislikes = Global.shared.userProfile["dislikes"] as? Array<String>
            
            let user = profiles[count]["owner"] as! PFObject
            
            if dislikesArray!.contains(id!) {
                count += 1
            } else if userLikes!.contains(user.objectId!) {
                count += 1
            } else if userDislikes!.contains(user.objectId!) {
                count += 1
            } else if id!.elementsEqual(user.objectId!) {
                count += 1
            } else {
                break
            }
            print(count)
        }
    }
    
    func getAddress(_ location: PFGeoPoint){
        
        let loc: CLLocation = CLLocation(latitude:location.latitude, longitude: location.longitude)


        CLGeocoder().reverseGeocodeLocation(loc, completionHandler:{ (placemarks, error) in
                if (error != nil) {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]

                if pm.count > 0 {
                    let pm = placemarks![0]
                    
                    var addressString : String = ""
                    
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + " "
                    }

                    self.addressLabel.text = addressString
              }
        })
    }
    
    @IBAction func onNo(_ sender: Any) {
        
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        let likedUser = self.profiles[self.count]["owner"] as! PFObject
        
        Global.shared.userProfile.add(likedUser.objectId, forKey: "dislikes")
        
        Global.shared.userProfile.saveInBackground { (success, error) in
            if success {
                self.setData()
            } else {
                print("Error saving")
            }
        }
    }
    
    @IBAction func onYes(_ sender: Any) {
        
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        let id = PFUser.current()?.objectId
        let likedUser = self.profiles[self.count]["owner"] as! PFObject
        
        Global.shared.userProfile.add(likedUser.objectId, forKey: "likes")
        
        let array = self.profiles[self.count]["likes"] as? Array<String>
        if array!.contains(id!) {
            
            let match = PFObject(className: "Match")
          
            match["profiles"] = [Global.shared.userProfile, self.profiles[self.count]] as Array<PFObject>
            match["messages"] = Array<String>()
            
            match.saveInBackground { (success, error) in
                if success {
                    print("saved match")
                    
                    let likedUserMatches = self.profiles[self.count]["matches"] as! Int
                    let userMatches = Global.shared.userProfile["matches"] as! Int
                    
                    self.profiles[self.count]["matches"] = likedUserMatches + 1
                    Global.shared.userProfile["matches"] = userMatches + 1
                    
                    self.profiles[self.count].saveInBackground()
//                    Global.shared.userProfile.saveInBackground()
                    
                } else {
                    print("error")
                }
            }
        }
        
        Global.shared.userProfile.saveInBackground { (success, error) in
            if success {
                self.setData()
            } else {
                print("Error saving")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  nHomeViewController.swift
//  Juno
//
//  Created by Cicely Beckford on 4/19/20.
//  Copyright © 2020 Cicely Beckford. All rights reserved.
//

import UIKit
import Parse
import Koloda

class HomeViewController: UIViewController, KolodaViewDataSource, KolodaViewDelegate {

    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var moreButton: UIView!
    
    var count = 0
    var profiles = [PFObject]()
    var zodiac = Zodiac()
    
    var numberofProfile: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberofProfile = 0
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        kolodaView.appearanceAnimationDuration = 0.1
        
        loadProfiles()
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        kolodaView.resetCurrentCardIndex()
        loadProfiles()
    }
    
    func loadProfiles() {
        numberofProfile = numberofProfile + 20
        
        let query = PFQuery(className: "Profile")
        query.includeKeys(["owner", "likes", "dislikes", "matches"])
        query.limit = numberofProfile
        
        let subquery = PFQuery(className: "Profile")
        subquery.whereKey("dislikes", containsAllObjectsIn: [PFUser.current()?.objectId])
        
        query.whereKey("owner", notEqualTo: PFUser.current()?.objectId)
        query.whereKey("owner", notContainedIn: Global.shared.userProfile!["dislikes"] as! [Any])
        query.whereKey("owner", notContainedIn: Global.shared.userProfile!["likes"] as! [Any])
        query.whereKey("objectId", doesNotMatchKey: "objectId", in: subquery)
        query.whereKey("location", nearGeoPoint: Global.shared.userProfile["location"] as! PFGeoPoint, withinMiles: Global.shared.userProfile["maxDistance"] as! Double)
        query.whereKey("interest", containedIn: [Global.shared.userProfile["identity"] as! String, "everyone"])
        if (Global.shared.userProfile["interest"] as! String != "everyone") {
            query.whereKey("identity", equalTo: Global.shared.userProfile["interest"])
        }
        
        query.findObjectsInBackground { (profs, error) in
            if profs != nil {
                self.profiles = profs!
                self.kolodaView.reloadData()
            }
        }
    }
    
    func getAddress(_ location: PFGeoPoint, completion: @escaping (_ answer: String?) -> Void){
        
        let loc: CLLocation = CLLocation(latitude:location.latitude, longitude: location.longitude)


        CLGeocoder().reverseGeocodeLocation(loc, completionHandler:{ (placemarks, error) in
            if (error != nil) {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            } else {
                
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
                    completion(addressString)
                }
            }
        })
    }
    
    func swipeLeft(_ index: Int) {
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        let likedUser = self.profiles[index]["owner"] as! PFObject
        
        Global.shared.userProfile.add(likedUser.objectId, forKey: "dislikes")
        Global.shared.userProfile.saveInBackground()
    }
    
    func swipeRight(_ index: Int) {
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        let otherProfile = self.profiles[index]
        
        let id = PFUser.current()?.objectId
        let likedUser = otherProfile["owner"] as! PFObject
        
        Global.shared.userProfile.add(likedUser.objectId, forKey: "likes")
        
        let array = otherProfile["likes"] as? Array<String>
        if array!.contains(id!) {
            
            let match = PFObject(className: "Match")
          
            match["profiles"] = [Global.shared.userProfile, otherProfile] as Array<PFObject>
            match["messages"] = Array<String>()
            
            match.saveInBackground { (success, error) in
                if success {
                    print("saved match")
                    
                    let likedUserMatches = otherProfile["matches"] as! Int
                    let userMatches = Global.shared.userProfile["matches"] as! Int
                    
                    otherProfile["matches"] = likedUserMatches + 1
                    Global.shared.userProfile["matches"] = userMatches + 1
                    
                    otherProfile.saveInBackground()
                    
                } else {
                    print("error")
                }
            }
        }
        
        Global.shared.userProfile.saveInBackground ()
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        
        let profile = profiles[index]
        
        let cardView = Bundle.main.loadNibNamed("KolodaPhotoView", owner: self, options: nil)![0] as? KolodaPhotoView
        
        let imageFile = profile["profilePhoto"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        let location = profile["location"] as! PFGeoPoint
        let dob = profile["dob"] as! Date
        
        getAddress(location) { (address) in
            cardView!.addressLabel.text = address
        }
        
        cardView!.imageView.af_setImage(withURL: url)
        cardView!.nameLabel.text = (profile["name"] as? String)! + ", " + String(dob.age)
        cardView!.compatibilityLabel.text = zodiac.getCompatibility(first: Global.shared.userProfile["sign"] as! String, second: profile["sign"] as! String)
        
        return cardView!
    }
    
    func kolodaViewForCardOverlayAtIndex(koloda: KolodaView, index: UInt) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)![0] as? OverlayView
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        if direction == .right {
            swipeRight(index)
        } else {
            swipeLeft(index)
        }
    }
    
    @IBAction func onNo(_ sender: Any) {
        kolodaView?.swipe(SwipeResultDirection.left)
    }
    
    @IBAction func onYes(_ sender: Any) {
        kolodaView?.swipe(SwipeResultDirection.right)
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        profiles.count
    }
    
    func kolodaDidSwipedCardAtIndex(koloda: KolodaView, index: UInt, direction: SwipeResultDirection) {
        
        if index + 1 == profiles.count {
            loadProfiles()
        }
    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        let alert = UIAlertController(title: "Oh No!", message: "No more profiles.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {
            action in alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
        yesButton.isEnabled = false
        noButton.isEnabled = false
        moreButton.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let cardView = Bundle.main.loadNibNamed("KolodaPhotoView", owner: self, options: nil)![0] as? KolodaPhotoView
        
        if segue.destination is MoreViewController
        {
            let vc = segue.destination as? MoreViewController
            vc?.profile = profiles[kolodaView.currentCardIndex]
            let location = profiles[kolodaView.currentCardIndex]["location"] as! PFGeoPoint
            vc?.compatibility = zodiac.getCompatibility(first: Global.shared.userProfile["sign"] as! String, second: vc?.profile["sign"] as! String)
            getAddress(location) { (address) in
                vc?.locationField.text = address
            }
        }
    }

}
extension Date {
    var age: Int { Calendar.current.dateComponents([.year], from: self, to: Date()).year! }
}

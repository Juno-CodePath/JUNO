///
//  RegistrationScreenController.swift
//  Juno
//
//  Created by Nobel Gebru on 4/14/20.
//  Copyright © 2020 Nobel Gebru. All rights reserved.
//
import UIKit
import Parse

class RegistrationScreenController: UIViewController {

    @IBOutlet weak var usernamefield: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
//    var userProfile: PFObject!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSignup(_ sender: Any) {
         let user = PFUser()
         user.username = usernamefield.text
         user.password = passwordField.text
         
         user.signUpInBackground { (success, error) in
             if success {
                self.createProfile()
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
             } else {
                print("Error: \(String(describing: error?.localizedDescription))")
             }
         }
    }
    
    func createProfile() {
        let profile = PFObject(className: "Profile")
        
        profile["name"] = "Toby Grant"
        profile["location"] = PFGeoPoint(latitude:35,longitude:-65)
        profile["owner"] = PFUser.current()!
        profile["dob"] = Date()
        profile["sign"] = "Taurus"
        profile["likes"] = Array<String>()
        profile["dislikes"] = Array<String>()
        profile["matches"] = Array<String>()
        
//        let imageData = imageView.image!.pngData()
//        let file = PFFileObject(name:"image.png", data: imageData!)
        
//        profile["image"] = file
        
        profile.saveInBackground { (success, error) in
            if success {
                self.getUserProfile()
            } else {
                print("error")
            }
        }
    }
    
    func getUserProfile() {
        
        let user = PFUser.current()
        let query = PFQuery(className: "Profile")
        query.includeKey("owner")
        
        query.whereKey("owner", equalTo: user).findObjectsInBackground{(prof, error) in
            if prof != nil {
                Global.shared.userProfile = prof![0]
            } else {
                print("no posts")
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

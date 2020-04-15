//
//  ProfileViewController.swift
//  Juno
//
//  Created by Sean Mills on 4/13/20.
//  Copyright © 2020 Cicely Beckford. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {

    @IBOutlet weak var editItem: UIBarButtonItem!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var signLabel: UILabel!
    
    @IBOutlet weak var aboutMeField: UITextView!
    
    @IBOutlet weak var occupationField: UITextField!
    
    var userProfile: PFObject!
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var companySchoolField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tempLogin()
        //tempRegistration()
        loadProfile()
        
        //let image = UIImageView(frame: CGRectMake(0, 0, 100, 100))
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        
        aboutMeField.layer.cornerRadius = 5
        aboutMeField.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        aboutMeField.layer.borderWidth = 0.5
        aboutMeField.clipsToBounds = true

        // Do any additional setup after loading the view.
    }
    /*
    func tempLogin() {
        let username = "testuser"
        let password = "password"
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if user != nil {
                return
            } else {
                let user = PFUser(
                user.username = username
                user.password = password
                
                user.signUpInBackground { (success, error) in
                    if success {
                        return
                    } else {
                        print("Error: \(error?.localizedDescription)")
                    }
                }
            }
        }
    }*/
    
    
    func loadProfile() {
        //var profile = PFObject(className: "Profile")
        var profiles = [PFObject]()
        
        let user = PFUser.current()
        let query = PFQuery(className: "Profile")
        query.includeKey("owner")
        query.whereKey("owner", equalTo: user)
        do {
            profiles = try query.findObjects()
            //self.userProfile = profiles[0]
        } catch {
            print(error)
        }
        self.userProfile = profiles[0]
        self.nameLabel.text = (self.userProfile["name"] as! String) + ", 22"
        self.signLabel.text = self.userProfile["sign"] as! String
        self.aboutMeField.text = self.userProfile["about"] as? String
        self.occupationField.text = self.userProfile["jobTitle"] as? String
        self.companySchoolField.text = self.userProfile["companySchool"] as? String
        /*query.findObjectsInBackground{(prof, error) in
            if prof != nil {
                self.userProfile = prof![0]
                //print(self.userProfile)
                self.nameLabel.text = self.userProfile["name"] as! String
                self.aboutMeField.text = self.userProfile["about"] as? String
                self.occupationField.text = self.userProfile["jobTitle"] as? String
                self.companySchoolField.text = self.userProfile["companySchool"] as? String
            } else {
                print("no profiles")
            }
        }*/
        //profileImageView.image = profile["profilePhoto"]
        //self.nameLabel.text = self.userProfile["name"] as! String
        
        print(self.userProfile)
        //nameLabel.text = self.userProfile["name"]
        
    }
    
    /*func loadProfile() {
        let query = PFQuery(className: "Profile")
        
    }*/

    @IBAction func onEditButton(_ sender: Any) {
        if editItem.title == "Item" {
            editItem.image = nil
            editItem.title = "Done"
            // var editImage = editItem.image
            editItem.image = nil
            
            aboutMeField.isEditable = true
            aboutMeField.layer.backgroundColor = UIColor.white.cgColor
            occupationField.isEnabled = true
            companySchoolField.isEnabled = true
            settingsButton.isEnabled = false
        }
        else {
            saveChanges()
            
            editItem.title = "Item"
            editItem.image = UIImage(systemName: "square.and.pencil")
            
            aboutMeField.isEditable = false
            aboutMeField.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
            occupationField.isEnabled = false
            companySchoolField.isEnabled = false
            settingsButton.isEnabled = true
        }
    }
    
    func saveChanges() {
        self.userProfile["about"] = self.aboutMeField.text
        self.userProfile["jobTitle"] = self.occupationField.text
        self.userProfile["companySchool"] = self.companySchoolField.text
        
        self.userProfile.saveInBackground { (success, error) in
            if success {
                //self.dismiss(animated: true, completion: nil)
                print("saved!")
            } else {
                print("Error: \(error?.localizedDescription)")
            }
        }
    }
    
    @IBAction func cancelToProfileViewController(_ segue: UIStoryboardSegue) {
    }

    @IBAction func saveSettings(_ segue: UIStoryboardSegue) {
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

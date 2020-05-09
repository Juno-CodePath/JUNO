//
//  ProfileViewController.swift
//  Juno
//
//  Created by Sean Mills on 4/13/20.
//  Copyright © 2020 Cicely Beckford. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var editItem: UIBarButtonItem!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var signLabel: UILabel!
    
    @IBOutlet weak var aboutMeField: UITextView!
    
    @IBOutlet weak var occupationField: UITextField!
    
    @IBOutlet weak var backView1: UIView!
    @IBOutlet weak var backView4: UIView!
    @IBOutlet weak var backView3: UIView!
    
    var userProfile: PFObject!
    var isPhotoChanged = false
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var companySchoolField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tempLogin()
        //tempRegistration()
        setupUI()
        loadProfile()
        
        
        //let image = UIImageView(frame: CGRectMake(0, 0, 100, 100))
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.isUserInteractionEnabled = false

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
    
    func setupUI() {
        let backViews: [UIView] = [backView1, backView3, backView4]
        
        backViews.forEach { (backView) in
            backView.layer.cornerRadius = 10.0
            backView.clipsToBounds = true
        }
    }
    
    
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
        
        /*let file = self.userProfile["profilePhoto"] as? PFFileObject
        file!.getDataInBackground { (imageData: Data?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let imageData = imageData {
                let image = UIImage(data: imageData)
                self.profileImageView.image = image
            }
        }*/
        let imageFile = self.userProfile["profilePhoto"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        self.profileImageView.af_setImage(withURL: url)
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
            profileImageView.isUserInteractionEnabled = true
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
            profileImageView.isUserInteractionEnabled = false
        }
    }
    
    func saveChanges() {
        self.userProfile["about"] = self.aboutMeField.text
        self.userProfile["jobTitle"] = self.occupationField.text
        self.userProfile["companySchool"] = self.companySchoolField.text
        
        if (self.isPhotoChanged == true) {
            let imageData = profileImageView.image!.pngData()
            let file = PFFileObject(name: "image.png", data: imageData!)
            
            self.userProfile["profilePhoto"] = file
            self.isPhotoChanged = false
        }
        
        self.userProfile.saveInBackground { (success, error) in
            if success {
                //self.dismiss(animated: true, completion: nil)
                print("saved!")
            } else {
                print("Error: \(error?.localizedDescription)")
            }
        }
    }
    @IBAction func onPhotoButton(_ sender: Any) {
        print("photo tapped")
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
           print("Camera is available 📸")
           vc.sourceType = .camera
        } else {
           print("Camera 🚫 available so we will use photo library instead")
           vc.sourceType = .photoLibrary
        }

        self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originalImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let editedImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        let size = CGSize(width: 200, height: 200)
        let scaledImage = editedImage.af_imageAspectScaled(toFill: size)
        
        profileImageView.image = scaledImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        self.isPhotoChanged = true
        dismiss(animated: true, completion: nil)
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

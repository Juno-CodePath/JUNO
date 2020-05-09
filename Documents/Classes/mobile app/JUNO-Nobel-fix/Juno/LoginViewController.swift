//
//  LoginViewController.swift
//  Juno
//
//  Created by Sean Mills on 4/14/20.
//  Copyright © 2020 Cicely Beckford. All rights reserved.
//

import UIKit
import AlamofireImage
import Parse

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var backView1: UIView!
    @IBOutlet weak var backView2: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupUI()
    }
    
    func setupUI() {
        
        backView1.layer.cornerRadius = 25.0
        backView1.clipsToBounds = true
        backView2.layer.cornerRadius = 25.0
        backView2.clipsToBounds = true
        
        loginButton.layer.cornerRadius = 30.0
        loginButton.clipsToBounds = true
        signupButton.layer.cornerRadius = 30.0
        signupButton.clipsToBounds = true
        
        signupButton.addLayerEffects(with: UIColor(red:0.77, green:0.58, blue:0.25, alpha:1.0)
, borderWidth: 1, cornerRadius: 30)
        
    }
    
    @IBAction func onLogin(_ sender: Any) {
        let username = usernameField.text!
        let password = passwordField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print("Error: \(error?.localizedDescription)")
            }
        }
    }
    
    @IBAction func onSignup(_ sender: Any) {
        let user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
        
        user.signUpInBackground { (success, error) in
            if success {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print("Error: \(error?.localizedDescription)")
            }
        }
//        tempRegistration()
    }
    
    func tempRegistration() {
        
        let profile = PFObject(className: "Profile")
        profile["name"] = "Will"
        profile["owner"] = PFUser.current()!
        profile["dob"] = Date()
        profile["likes"] = [String]()
        profile["matches"] = [String]()
        profile["sign"] = "Pisces"
        //profile["profilePhoto"] = PFFileObject(data: nil)
            
            //profileImageView.image = UIImage(named: "will")
            
        /*let imageData = UIImage(named: "will")!.pngData()
        let file = PFFileObject(name: "image.png", data: imageData!)
            
        profile["profilePhoto"] = file*/
        print(PFUser.current())
        profile["location"] = PFGeoPoint(latitude: 0, longitude: 0)
        print("reached")
        profile.saveInBackground { (success, error) in
            if success {
                //self.dismiss(animated: true, completion: nil)
                print("saved!")
            } else {
                print("Error: \(error?.localizedDescription)")
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

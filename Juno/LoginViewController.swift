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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogin(_ sender: Any) {
        let username = usernameField.text!
        let password = passwordField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if user != nil {
                self.getUserProfile()
//                self.performSegue(withIdentifier: "loginSegue", sender: nil)
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
        //tempRegistration()
    }
    
    func getUserProfile() {
        
        let user = PFUser.current()
        let query = PFQuery(className: "Profile")
        query.includeKey("owner")
        
        query.whereKey("owner", equalTo: user).findObjectsInBackground{(prof, error) in
            if prof != nil {
                Global.shared.userProfile = prof![0]
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
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

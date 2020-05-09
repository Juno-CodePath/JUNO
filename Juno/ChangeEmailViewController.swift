//
//  ChangeEmailViewController.swift
//  Juno
//
//  Created by Sean Mills on 5/4/20.
//  Copyright © 2020 Cicely Beckford. All rights reserved.
//

import UIKit
import Parse

class ChangeEmailViewController: UIViewController {
    @IBOutlet weak var newEmailField: UITextField!
    @IBOutlet weak var savedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(PFUser.current()?.username as! String)
        // Do any additional setup after loading the view.
    }
    @IBAction func onDoneButton(_ sender: Any) {
        PFUser.current()?.email = newEmailField.text
        PFUser.current()?.saveInBackground(){
            (success, error) in
            if success {
                //self.dismiss(animated: true, completion: nil)
                print("saved!")
                self.savedLabel.isHidden = false
            } else {
                print("Error: \(error?.localizedDescription)")
            }
        }
    }
    /*
    @IBAction func onSaveButton(_ sender: Any) {
        incorrectPasswordLabel.isHidden = true
        self.savedLabel.isHidden = true
        //PFUser.password
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
                    if user != nil {
                        self.getUserProfile()
        //                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    } else {
                        print("Error: \(error?.localizedDescription)")
                    }
        if (passwordField.text != PFUser.current()?.password as! String) {
            incorrectPasswordLabel.isHidden = false
        }
        else {
            PFUser.current()?.email = newEmailField.text
            PFUser.current()?.saveInBackground(){
                (success, error) in
                if success {
                    //self.dismiss(animated: true, completion: nil)
                    print("saved!")
                    self.savedLabel.isHidden = false
                } else {
                    print("Error: \(error?.localizedDescription)")
                }
            }
            
        }
    }*/
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

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
                 self.performSegue(withIdentifier: "loginSegue", sender: nil)
             } else {
                print("Error: \(String(describing: error?.localizedDescription))")
             }
         }
         // other fields can be set just like with PFObject
        // user["phone"] = "415-392-0202"
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

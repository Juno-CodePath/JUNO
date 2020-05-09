//
//  MoreViewController.swift
//  Juno
//
//  Created by Sean Mills on 5/9/20.
//  Copyright © 2020 Cicely Beckford. All rights reserved.
//

import UIKit
import Parse

class MoreViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var signLabel: UILabel!
    @IBOutlet weak var compatibilityLabel: UILabel!
    
    @IBOutlet weak var aboutMeField: UITextView!
    @IBOutlet weak var occupationField: UITextField!
    @IBOutlet weak var companySchoolField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    
    var profile: PFObject!
    var compatibility: String!
    var address: String!
    var zodiac = Zodiac()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editView()
        loadInfo()

        // Do any additional setup after loading the view.
    }
    
    func editView() {
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        
        aboutMeField.layer.cornerRadius = 5
        aboutMeField.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        aboutMeField.layer.borderWidth = 0.5
        aboutMeField.clipsToBounds = true
    }
    
    func loadInfo() {
        var dob = profile["dob"] as! Date
        nameLabel.text = (profile["name"] as! String) + ", " + String(dob.age)
        print(profile["dob"] as? String)
        signLabel.text = profile["sign"] as! String
        aboutMeField.text = profile["about"] as? String
        occupationField.text = profile["jobTitle"] as? String
        companySchoolField.text = profile["companySchool"] as? String
        
        let imageFile = profile["profilePhoto"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        self.profileImageView.af_setImage(withURL: url)
        
        compatibilityLabel.text = "Compatibility: " + compatibility
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

//
//  ProfileViewController.swift
//  Juno
//
//  Created by Sean Mills on 4/13/20.
//  Copyright © 2020 Cicely Beckford. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var editItem: UIBarButtonItem!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var aboutMeField: UITextView!
    
    @IBOutlet weak var occupationField: UITextField!
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var companySchoolField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            editItem.title = "Item"
            editItem.image = UIImage(systemName: "square.and.pencil")
            
            aboutMeField.isEditable = false
            aboutMeField.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
            occupationField.isEnabled = false
            companySchoolField.isEnabled = false
            settingsButton.isEnabled = true
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

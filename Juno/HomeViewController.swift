//
//  HomeViewController.swift
//  Juno
//
//  Created by Cicely Beckford on 4/13/20.
//  Copyright © 2020 Cicely Beckford. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var compatibilityLabel: UILabel!
    
    var count = 0
    var profiles = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProfiles()
        setData()
    }
    
    func setData() {
        if count >= 20 {
            loadProfiles()
            count = 0
        }
        //nameLabel.text = profiles[count]
        //addressLabel.text = profiles[count]["address"]
        //compatibilityLabel.text = profiles[count]["compatibility"]
        count += 1
    }
    
    func loadProfiles() {
        let query = PFQuery(className: "Profile")
        query.includeKeys(["owner", "likes", "dislikes", "matches"])
        query.limit = 20
        
        query.findObjectsInBackground { (profs, error) in
            if profs != nil {
                self.profiles = profs!
            }
        }
    }
    
    @IBAction func onYes(_ sender: Any) {
        setData()
    }
    
    @IBAction func onNo(_ sender: Any) {
        setData()
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

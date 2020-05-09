//
//  SettingsTableViewController.swift
//  Juno
//
//  Created by Sean Mills on 4/20/20.
//  Copyright © 2020 Cicely Beckford. All rights reserved.
//

import UIKit
import Parse

class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var interestSegmentedControl: UISegmentedControl!
    @IBOutlet weak var identitySegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailLabel.text = PFUser.current()?.email
        var distance = Global.shared.userProfile["maxDistance"] as! Float
        distanceSlider.value = distance
        distanceLabel.text = String(Int(distance)) + " mi"
        
        distanceSlider.value = Global.shared.userProfile["maxDistance"] as! Float
        distanceLabel.text = String(Int(distanceSlider.value)) + " mi"
        identitySegmentedControl.selectedSegmentIndex = getGenderIndex(gender: Global.shared.userProfile["identity"] as! String)
        interestSegmentedControl.selectedSegmentIndex = getGenderIndex(gender: Global.shared.userProfile["interest"] as! String)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func getGenderIndex(gender: String) -> Int {
        if (gender == "women") {
            return 0
        }
        if (gender == "men") {
            return 1
        }
        return 2
    }
    
    func getGenderString(gender: Int) -> String {
        if (gender == 0) {
            return "women"
        }
        if (gender == 1) {
            return "men"
        }
        return "everyone"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (section == 1) {
            return 3
        }
        return 2
    }

    @IBAction func onLogOutButton(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(identifier: "LoginViewController")
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.rootViewController = loginViewController
    }
    @IBAction func onDistanceChanged(_ sender: Any) {
        distanceLabel.text = String(Int(distanceSlider.value)) + " mi"
        Global.shared.userProfile["maxDistance"] = distanceSlider.value
        
        Global.shared.userProfile.saveInBackground { (success, error) in
            if success {
                //self.dismiss(animated: true, completion: nil)
                print("saved!")
            } else {
                print("Error: \(error?.localizedDescription)")
            }
        }
    }
    @IBAction func onInterestChanged(_ sender: Any) {
        let index = interestSegmentedControl.selectedSegmentIndex
        Global.shared.userProfile["interest"] = getGenderString(gender: index)
        Global.shared.userProfile.saveInBackground { (success, error) in
            if success {
                //self.dismiss(animated: true, completion: nil)
                print("saved!")
            } else {
                print("Error: \(error?.localizedDescription)")
            }
        }
        
    }
    
    @IBAction func onIdentityChanged(_ sender: Any) {
        let index = identitySegmentedControl.selectedSegmentIndex
        Global.shared.userProfile["identity"] = getGenderString(gender: index)
        Global.shared.userProfile.saveInBackground { (success, error) in
            if success {
                //self.dismiss(animated: true, completion: nil)
                print("saved!")
            } else {
                print("Error: \(error?.localizedDescription)")
            }
        }
    }
    
    @IBAction func backToSettingsViewController(_ segue: UIStoryboardSegue) {
    }
    
    @IBAction func emailChanged(_ segue: UIStoryboardSegue) {
        emailLabel.text = PFUser.current()?.email
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

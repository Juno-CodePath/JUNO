//
//  MessagesTableViewController.swift
//  Juno
//
//  Created by Cicely Beckford on 4/15/20.
//  Copyright © 2020 Cicely Beckford. All rights reserved.
//

import UIKit
import Parse

class MatchesTableViewController: UITableViewController {
    
    var matches = [PFObject]()
    var numberofMatch: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadMatches()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 92
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadMatches()
    }
    
    func loadMatches() {
        numberofMatch = 20
        
        let query = PFQuery(className: "Match")
        query.includeKeys(["profiles", "messages"])
        query.addDescendingOrder("createdAt")
        query.limit = numberofMatch
        
        query.whereKey("profiles", containsAllObjectsIn: [Global.shared.userProfile]).findObjectsInBackground{(matches, error) in
            if matches != nil {
                self.matches = matches!
                self.tableView.reloadData()
            } else {
                print("no matches")
            }
        }
    }
    
    func loadMoreMatches() {
        numberofMatch = numberofMatch + 20
        
        let query = PFQuery(className: "Match")
        query.includeKeys(["profiles", "messages"])
        query.addDescendingOrder("createdAt")
        query.limit = numberofMatch
        
        query.whereKey("profiles", containsAllObjectsIn: [Global.shared.userProfile]).findObjectsInBackground{(matches, error) in
            if matches != nil {
                self.matches = matches!
                self.tableView.reloadData()
            } else {
                print("no matches")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == matches.count {
            loadMoreMatches()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchCell", for: indexPath) as! MatchCell
        
        let profiles = matches[indexPath.row]["profiles"] as! Array<PFObject>
        var matchProfile = profiles[0]
        if matchProfile.objectId == Global.shared.userProfile.objectId {
            matchProfile = profiles[1]
        }
        
        let messages = matches[indexPath.row]["messages"] as! Array<PFObject>
        
        
        let imageFile = matchProfile["profilePhoto"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.photoView.af_setImage(withURL: url)
        cell.nameLabel.text = matchProfile["name"] as? String
        
        if messages.isEmpty {
            cell.previewLabel.text = "Say hi!"
            cell.timeAgoLabel.text = ""
        } else {
            
            let lastMessage = messages.last!
            let messageAuthor = lastMessage["author"] as! PFUser

            if messageAuthor.objectId == PFUser.current()?.objectId {
                cell.previewLabel.text = "You: " + ((lastMessage["text"] as? String)!)
            } else {
                cell.previewLabel.text = lastMessage["text"] as? String
            }
            
            cell.timeAgoLabel.text = getRelativeTime(date: lastMessage.createdAt!)
            
        }
        
        return cell
    }
    
    func getRelativeTime(date: Date) -> String {
        let time: Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        let timeString = dateFormatter.string(from: date)
        
        time = dateFormatter.date(from: timeString)!
        return time.messagePreviewTimeDisplay()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return matches.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        
        let chatTableViewController = segue.destination as! ChatTableViewController
        chatTableViewController.match = matches[indexPath.row]
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

extension Date {
    func messagePreviewTimeDisplay() -> String {
        var timeStamp: String = ""
        let secondsAgo = Int(Date().timeIntervalSince(self))
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        if (secondsAgo < day) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            timeStamp = dateFormatter.string(from: self)
            
        } else if (secondsAgo < (day * 2)) {
            
            timeStamp = "Yesterday"
        } else if (secondsAgo < week) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE h:mm a"
            timeStamp = dateFormatter.string(from: self)
            
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            timeStamp = dateFormatter.string(from: self)
        }
        return timeStamp
    }
}

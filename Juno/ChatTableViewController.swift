//
//  ChatViewController.swift
//  Juno
//
//  Created by Cicely Beckford on 4/15/20.
//  Copyright © 2020 Cicely Beckford. All rights reserved.
//

import UIKit
import Parse
import MessageInputBar

class ChatTableViewController: UITableViewController, MessageInputBarDelegate {
    
    var match: PFObject!
    var messages = [PFObject]()
    
    var matchProfile: PFObject!
    
    let inputBar = MessageInputBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messages = match["messages"] as! Array<PFObject>
        
        let profiles = match["profiles"] as! Array<PFObject>
        if profiles[0].objectId == Global.shared.userProfile.objectId {
            matchProfile = profiles[1]
        } else {
            matchProfile = profiles[0]
        }
        
        self.title = matchProfile["name"] as? String
        
        inputBar.inputTextView.placeholder = "Message"
        inputBar.sendButton.title = "Send"
        inputBar.delegate = self
        
        tableView.keyboardDismissMode = .interactive
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillBeShown(note:)), name: UIResponder.keyboardWillShowNotification, object: nil)

    }

    @objc func keyboardWillBeShown(note: Notification) {

        if let keyboardSize = (note.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
//    func keyboardWillHide(_ notification:Notification) {
//
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
//        }
//    }
    
    @objc func keyboardWillBeHidden(note: Notification) {
        inputBar.inputTextView.text = nil
        becomeFirstResponder()
        
        if let keyboardSize = (note.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
               }
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        let message = PFObject(className: "Message")
        
        message["author"] = PFUser.current()!
        message["text"] = text

        match.add(message, forKey: "messages")

        match.saveInBackground{ (success, error) in
            if success {
                print("Message saved")
//                self.messages.append(message)
            } else {
                print("Error saving comment")
            }
        }
        
        self.messages.append(message)
        tableView.reloadData()
        
        //Clear and dismiss the comment bar
        inputBar.inputTextView.text = nil
        becomeFirstResponder()
    }
    
//    func loadMessages() {
//        let query = PFQuery(className: "Message")
//        query.includeKeys(["author", "comments", "comments.author"])
//
//        numberOfPost = 20
//        query.limit = numberOfPost
//
//        query.findObjectsInBackground { (posts, error) in
//            if posts != nil {
//                self.posts = posts!
//                self.tableView.reloadData()
//            }
//            self.myRefreshControl.endRefreshing()
//        }
//    }
    
    override var inputAccessoryView: UIView? {
        return inputBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
        let author = messages[indexPath.row]["author"] as! PFUser
        var imageFile: PFFileObject!
        
        if author.objectId == PFUser.current()?.objectId {
            imageFile = Global.shared.userProfile["profilePhoto"] as? PFFileObject
        } else {
            imageFile = matchProfile["profilePhoto"] as? PFFileObject
        }
        
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.profileImage.af_setImage(withURL: url)
        cell.messageLabel.text = messages[indexPath.row]["text"] as? String
        cell.timeLabel.text = getRelativeTime(date: messages[indexPath.row].createdAt!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func getRelativeTime(date: Date) -> String {
        let time: Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        let timeString = dateFormatter.string(from: date)
        
        time = dateFormatter.date(from: timeString)!
        return time.chatTimeDisplay()
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

extension Date {
    func chatTimeDisplay() -> String {
        var timeStamp: String = ""
        let secondsAgo = Int(Date().timeIntervalSince(self))
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        if (secondsAgo < (day * 2)) {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            timeStamp = "Yesterday " + dateFormatter.string(from: self)
            
        } else if (secondsAgo < week) {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE h:mm a"
            timeStamp = dateFormatter.string(from: Date())
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy h:mm a"
            timeStamp = dateFormatter.string(from: self)
        }
        return timeStamp
    }
}


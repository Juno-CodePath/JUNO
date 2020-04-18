//
//  ChatCell.swift
//  Juno 
//
//  Created by Cicely Beckford on 4/15/20.
//  Copyright © 2020 Cicely Beckford. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    
    @IBOutlet weak var receivedView: UIView!
    @IBOutlet weak var receivedImageView: UIImageView!
    @IBOutlet weak var receivedMessageLabel: UILabel!
    @IBOutlet weak var receivedTimeLabel: UILabel!
    
    @IBOutlet weak var sentView: UIView!
    @IBOutlet weak var sentImageView: UIImageView!
    @IBOutlet weak var sentMessageLabel: UILabel!
    @IBOutlet weak var sentTimeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  MessageTableViewCell.swift
//  Juno
//
//  Created by Cicely Beckford on 4/15/20.
//  Copyright © 2020 Cicely Beckford. All rights reserved.
//

import UIKit

class MatchCell: UITableViewCell {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var previewLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

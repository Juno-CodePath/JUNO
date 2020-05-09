//
//  PDFListTVCell.swift
//  PDFCreator
//
//  Created by Lahiru Chathuranga on 12/28/19.
//  Copyright © 2019 Lahiru Chathuranga. All rights reserved.
//

import UIKit

class PDFListTVCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    
    // MARK: - Variable

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backView.layer.cornerRadius = 10
        backView.clipsToBounds = true
        
        thumbImageView.layer.cornerRadius = 4
        thumbImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(with model: _LocalPDF) {
        nameLabel.text = model.name
        dateLabel.text = model.date
    }

}

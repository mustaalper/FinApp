//
//  EarningTableViewCell.swift
//  FinApp
//
//  Created by MAA on 14.09.2022.
//

import UIKit

class EarningTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var costLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

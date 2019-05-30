//
//  HitTableViewCell.swift
//  HNMobileTest
//
//  Created by Diego Sepúlveda on 5/29/19.
//  Copyright © 2019 reigndesign. All rights reserved.
//

import UIKit

class HitTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

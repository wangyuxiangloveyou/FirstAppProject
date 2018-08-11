//
//  EarlyWarningTableViewCell.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/3.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit

class EarlyWarningTableViewCell: UITableViewCell {
    
   
    @IBOutlet weak var warningImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var numberLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

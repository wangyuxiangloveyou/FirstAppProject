//
//  UntreatedViewCell.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/22.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit

class UntreatedViewCell: UITableViewCell {
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var NumLabel: UILabel!
    
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var imageView1: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

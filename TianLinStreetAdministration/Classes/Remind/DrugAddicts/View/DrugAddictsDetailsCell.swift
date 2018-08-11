//
//  DrugAddictsDetailsCell.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/7/12.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit

class DrugAddictsDetailsCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var suspiciousLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bgView.layer.shadowColor = UIColor.black.cgColor;
        self.bgView.layer.shadowOpacity = 0.30;
        self.bgView.layer.shadowOffset = CGSize(width: 0, height: 3)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

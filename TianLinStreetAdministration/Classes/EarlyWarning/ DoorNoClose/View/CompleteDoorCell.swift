//
//  CompleteDoorCell.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/4.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit

class CompleteDoorCell: UITableViewCell {

    @IBOutlet weak var FristImageView: UIImageView!
    @IBOutlet weak var AdressLabel: UILabel!
    @IBOutlet weak var RightLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var OneLabel: UILabel!
    @IBOutlet weak var TwoLabel: UILabel!
    @IBOutlet weak var bkgView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bkgView.layer.shadowColor = UIColor.black.cgColor;
        self.bkgView.layer.shadowOpacity = 0.30;
        self.bkgView.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

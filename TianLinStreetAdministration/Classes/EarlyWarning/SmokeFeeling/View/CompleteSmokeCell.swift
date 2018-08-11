//
//  CompleteSmokeCell.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/4.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit

class CompleteSmokeCell: UITableViewCell {
   
    @IBOutlet weak var bkgView: UIView!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var TimeLongLabel: UILabel!
    @IBOutlet weak var ErrorLabel: UILabel!
    @IBOutlet weak var AllLabel1: UILabel!
    @IBOutlet weak var AllLabel: UILabel!
    
    @IBOutlet weak var Person: UILabel!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var AdressLabel: UILabel!
   
    @IBOutlet weak var FirstmageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bkgView.layer.shadowColor = UIColor.black.cgColor;
        self.bkgView.layer.shadowOpacity = 0.3;
        self.bkgView.layer.shadowOffset = CGSize(width: 0, height: 3)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

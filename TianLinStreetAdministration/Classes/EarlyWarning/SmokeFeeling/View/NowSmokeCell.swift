//
//  NowSmokeCell.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/4.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit

class NowSmokeCell: UITableViewCell {
    
    var nowClourse:IngreJumpClosure?
    
    
    @IBOutlet weak var bkgView: UIView!
    @IBOutlet weak var ImageBtn: UIButton!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var PersonLabel: UILabel!
    
    @IBOutlet weak var AdressLabel: UILabel!
    @IBOutlet weak var RedLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var FirstImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        super.awakeFromNib()
        self.bkgView.layer.shadowColor = UIColor.black.cgColor;
        self.bkgView.layer.shadowOpacity = 0.3;
        self.bkgView.layer.shadowOffset = CGSize(width: 0, height: 3)
    }

    @IBAction func ImageBtn(_ sender: Any) {
        print("受理中")
        if nowClourse != nil {
            self.nowClourse!()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

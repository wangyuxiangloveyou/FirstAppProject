//
//  SmokeFeelingCell.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/4.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit
import Toast_Swift

class SmokeFeelingCell: UITableViewCell {

    @IBOutlet weak var bakView: UIView!
    
    
    @IBOutlet weak var FirstImageView: UIImageView!
    
    @IBOutlet weak var AdressLabel: UILabel!
    
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var RedLabel: UILabel!
    
    @IBOutlet weak var NameLabel: UILabel!
    
    @IBOutlet weak var PersonLabel: UILabel!
   
    @IBOutlet weak var ImageBtn: UIButton!
    
     var untreatedSmokeClourse:IngreJumpClosure?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bakView.layer.shadowColor = UIColor.black.cgColor;
        self.bakView.layer.shadowOpacity = 0.3;
        self.bakView.layer.shadowOffset = CGSize(width: 0, height: 3)
    }

    @IBAction func ImageBtn(_ sender: Any) {
        self.makeToast("受理", duration: 0.3, position: ToastPosition.center)
        if untreatedSmokeClourse != nil {
            self.untreatedSmokeClourse!()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

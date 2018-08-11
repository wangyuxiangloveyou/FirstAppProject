//
//  UntreatedReadCell.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/4.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit

class UntreatedReadCell: UITableViewCell {
    
    var chooseClourse:IngreJumpClosure?
    
    @IBOutlet weak var chooseButton: UIButton!
    
    @IBOutlet weak var bkgView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var allLabel: UILabel!
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var carLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bkgView.layer.shadowColor = UIColor.black.cgColor;
        self.bkgView.layer.shadowOpacity = 0.3;
        self.bkgView.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    @IBAction func chooseButton(_ sender: Any) {
//        chooseButton.isSelected = false
        if self.chooseClourse != nil {
            self.chooseClourse!()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

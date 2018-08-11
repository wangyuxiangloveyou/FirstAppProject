//
//  UntreatedInspectCell.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/4.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit

class UntreatedInspectCell: UITableViewCell {
    @IBOutlet weak var bakView: UIView!
    
    @IBOutlet weak var BeforeTimeLabel: UILabel!
    @IBOutlet weak var ErrorLabel: UILabel!
    @IBOutlet weak var NumberLabel: UILabel!
    
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var FirstImageView: UIImageView!
    
    @IBOutlet weak var AdressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bakView.layer.shadowColor = UIColor.black.cgColor;
        self.bakView.layer.shadowOpacity = 0.3;
        self.bakView.layer.shadowOffset = CGSize(width: 0, height: 3)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

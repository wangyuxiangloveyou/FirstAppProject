//
//  NowDoorCell.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/4.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit

class NowDoorCell: UITableViewCell {
    
    
    
    var doorClourse:IngreJumpClosure?
    @IBOutlet weak var HandleButton: UIButton!
    @IBOutlet weak var bkgView: UIView!
    @IBOutlet weak var RedLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var AdressLabel: UILabel!
    @IBOutlet weak var FristImageView: UIImageView!
    var eventID : String = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bkgView.layer.shadowColor = UIColor.black.cgColor;
        self.bkgView.layer.shadowOpacity = 0.3;
        self.bkgView.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    @IBAction func HandleButton(_ sender: Any) {
        print("点击了")
        if self.doorClourse != nil{
            self.doorClourse!()
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

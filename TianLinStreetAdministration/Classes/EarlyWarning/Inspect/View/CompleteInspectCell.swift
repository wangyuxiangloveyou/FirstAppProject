//
//  CompleteInspectCell.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/4.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit

class CompleteInspectCell: UITableViewCell {
    var repairClourse:IngreJumpClosure?
    var remarksClourse:IngreJumpClosure?

    @IBOutlet weak var remarksButton: UIButton!
    @IBOutlet weak var repairButton: UIButton!
    @IBOutlet weak var FirstImageView: UIImageView!
    
    @IBOutlet weak var AdressLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    
    @IBOutlet weak var NumberLabel: UILabel!
   
    
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var bakView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bakView.layer.shadowColor = UIColor.black.cgColor;
        self.bakView.layer.shadowOpacity = 0.3;
        self.bakView.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    @IBAction func repairButton(_ sender: Any) {
        print(98765)
        if repairClourse != nil{
            self.repairClourse!()
        }
        
    }
    
    @IBAction func remarksButton(_ sender: Any) {
        print(98765)
        if remarksClourse != nil{
            self.remarksClourse!()
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

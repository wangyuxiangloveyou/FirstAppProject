//
//  CompleteSmokeCell.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/4.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit

class CompleteSmokeCell: UITableViewCell {
    let gradientLayer1: CAGradientLayer = CAGradientLayer()
     let layer1:CATextLayer=CATextLayer()
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
    
    func refreshData(model:CompleteSmokeEventsModel)  {
        if (model.resultType.count) > 0
        {
            for i in 0..<model.resultType.count
            {
                if model.resultType[i] == 1
                {
                    ErrorLabel.textAlignment = .center
                    ErrorLabel.text="误报"
                    ErrorLabel.textColor=UIColor.gray
                    ErrorLabel.backgroundColor=UIColor.init(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
                }
                if model.resultType[i] == 2
                {
                    ErrorLabel.textAlignment = .center
                    ErrorLabel.textColor=UIColor.white
                   
                    layer1.frame=CGRect(x: 20, y: 8, width: 80, height:35)
                    layer1.string="非误报"
                    layer1.foregroundColor=UIColor.white.cgColor
                    layer1.fontSize=UIFont.systemFont(ofSize: 14).pointSize
                    
                    
                    let TColor = UIColor.init(red: 236/255, green: 86/255, blue: 86/255, alpha: 1)
                    let BColor = UIColor.init(red: 255/255, green: 152/255, blue: 74/255, alpha: 1)
                    let gradientColors1: [CGColor] = [TColor.cgColor, BColor.cgColor]
                    gradientLayer1.colors = gradientColors1
                    gradientLayer1.startPoint = CGPoint(x: 0, y: 0)
                    gradientLayer1.endPoint = CGPoint(x: 1, y: 0)
                    gradientLayer1.frame = CGRect(x: 0, y: 0, width: 80, height:35)
                    ErrorLabel.layer.addSublayer(gradientLayer1)
                    ErrorLabel.layer.addSublayer(layer1)
                }
                if model.resultType[i] == 3
                {
                    TimeLongLabel.text="接单超时"
                    TimeLongLabel.backgroundColor=UIColor.init(red: 146/255, green: 203/255, blue: 197/255, alpha: 1)
                }
            }
        }
    }
                override func setSelected(_ selected: Bool, animated: Bool) {
                    super.setSelected(selected, animated: animated)
                    
                    // Configure the view for the selected state
                }
                
                override func prepareForReuse() {
                    super.prepareForReuse()
                    gradientLayer1.removeFromSuperlayer()
                    layer1.removeFromSuperlayer()
                }
                
}

//
//  UntreatedDoorCell.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/4.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit
import Toast_Swift
import MBProgressHUD


class UntreatedDoorCell: UITableViewCell {
    var doorClourse:IngreJumpClosure?
    var comClource:IngreJumpClosure?
    var secVC:UntreatedDoorView = UntreatedDoorView()
    var tag1=100
    @IBOutlet weak var HandleButton: UIButton!
    @IBOutlet weak var ReceiptButton: UIButton!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var bkgView: UIView!
    
    @IBOutlet weak var AdressLabel: UILabel!
    @IBOutlet weak var FirstImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bkgView.layer.shadowColor = UIColor.black.cgColor;
        self.bkgView.layer.shadowOpacity = 0.3;
        self.bkgView.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    @IBAction func HandleButton(_ sender: Any) {
        
        tag1 += 1
        if tag1 > 101{
            //            HandleButton.isSelected = true
            //            HandleButton.backgroundColor=UIColor.white
            self.makeToast(("正在处理中"), duration: 0.3, position: ToastPosition.center)
            
        }
        
//        secVC.picClource = {
//            self.tag1 += 1
//            self.ReceiptButton.isHidden=true
//            self.HandleButton.snp.makeConstraints { (make) in
//                make.top.equalTo(self.AdressLabel.snp.bottom).offset(10)
//                make.left.equalTo(self).offset(3)
//                make.width.equalTo(screenWidth-6)
//            }
//              self.makeToast(("正在处理中"), duration: 0.3, position: ToastPosition.center)
//            print(11111)
//        }
        
        
        
        if tag1 == 101 && ReceiptButton.isHidden == false{
            ReceiptButton.isHidden=true
            if self.doorClourse != nil {
                self.doorClourse!()
                HandleButton.snp.makeConstraints { (make) in
                    make.top.equalTo(AdressLabel.snp.bottom).offset(10)
                    make.left.equalTo(self).offset(3)
                    make.width.equalTo(screenWidth-6)
                }
            }
        }else{
            self.makeToast(("正在处理中"), duration: 0.3, position: ToastPosition.center)
        }
    }
    
    @IBAction func ReceiptButton(_ sender: Any) {
        if comClource != nil{
            self.comClource!()
        }
        //        ReceiptButton.removeFromSuperview()
        //        HandleButton.snp.makeConstraints { (make) in
        //            make.top.equalTo(AdressLabel.snp.bottom).offset(10)
        //            make.left.equalTo(self).offset(3)
        //            make.width.equalTo(screenWidth-6)
        //        }
        // 大小变化
        
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.keyTimes = [0, 0.5, 1]
        scaleAnimation.values = [1, 0.4, 1]
        scaleAnimation.duration = 1
        
        // 透明度变化
        let opacityAnimaton = CAKeyframeAnimation(keyPath: "opacity")
        //该属性是一个数组，用以指定每个子路径的时间。
        opacityAnimaton.keyTimes = [0, 0.5, 1]
        //values属性指明整个动画过程中的关键帧点，需要注意的是，起点必须作为values的第一个值。
        opacityAnimaton.values = [1, 0.3, 1]
        opacityAnimaton.duration = 1
        // 组动画
        let animation = CAAnimationGroup()
        //将大小变化和透明度变化的动画加入到组动画
        animation.animations = [scaleAnimation, opacityAnimaton]
        //动画的过渡效果
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        //动画的持续时间
        animation.duration = 1
        //设置重复次数,HUGE可看做无穷大，起到循环动画的效果
        animation.repeatCount = HUGE
        //运行一次是否移除动画
        animation.isRemovedOnCompletion = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

//
//  DetailHeaderView.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/7/27.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit

class DetailHeaderView: UIView {

    //点击事件
    var jumpClosure: IngreJumpClosure?
   
    var imageView:UIImageView?
    //文字
     var titleLabel:UILabel?
    var titleLabel1:UILabel?
    var  iconW:CGFloat=44
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configText("wyx")
        self.backgroundColor=UIColor.white
        //白色背景
        
        titleLabel=UILabel(frame: CGRect(x: 10, y: 0, width: screenWidth-110, height: 30))
        titleLabel!.textAlignment = .left
        titleLabel!.textColor=UIColor.black
        titleLabel!.font=UIFont.boldSystemFont(ofSize: 7)
        titleLabel!.font=UIFont.systemFont(ofSize: 10)
        self.addSubview(titleLabel!)
        titleLabel1=UILabel(frame: CGRect(x: screenWidth-100, y: 0, width: 100, height: 30))
        titleLabel1!.textAlignment = .center
        titleLabel1!.textColor=UIColor.black
        titleLabel1!.font=UIFont.boldSystemFont(ofSize: 7)
        titleLabel1!.font=UIFont.systemFont(ofSize: 10)
        self.addSubview(titleLabel1!)
        titleLabel?.text="特殊"
        titleLabel1?.text="非特殊"
    }
    
    fileprivate func configText(_ text: String) {
       
        //print(allModel?.title)
        //修改位置
       // titleLabel?.frame=CGRect(x: 60, y: 8, width: 120, height: 44)
        //imageView?.frame=CGRect(x: titleLabel!.frame.origin.x-50, y: 0, width: iconW, height: iconW)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

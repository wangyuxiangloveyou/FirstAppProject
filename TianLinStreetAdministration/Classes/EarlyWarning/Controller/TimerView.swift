
//
//  TimerView.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/7/31.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit

class TimerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
       self.layer.contents = UIImage(named:"mmexport1525609772323.jpg")?.cgImage
        let imageView1=UIImageView()
        self.addSubview(imageView1)
        imageView1.image=UIImage(named: "成功.png")
        imageView1.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(100)
            make.center.equalTo(self)
        }
        
        if number1 == 1{
            let label=UILabel()
            self.addSubview(label)
            label.text="已接单"
            label.textAlignment = .center
            label.font=UIFont.systemFont(ofSize: 20)
            label.snp.makeConstraints { (make) in
                make.width.equalTo(imageView1)
                make.height.equalTo(40)
                make.top.equalTo(imageView1.snp.bottom).offset(10)
                make.left.equalTo(imageView1)
            }
            let label1=UILabel()
            self.addSubview(label1)
            label1.text="请在15分钟内处置完成"
            label1.textAlignment = .center
            label1.font=UIFont.systemFont(ofSize: 18)
            label1.snp.makeConstraints { (make) in
                make.width.equalTo(screenWidth/5*3)
                make.height.equalTo(40)
                make.top.equalTo(label.snp.bottom).offset(0)
                make.left.equalTo(screenWidth/5)
            }
        }
        if number1 == 3{
            let label=UILabel()
            self.addSubview(label)
            label.text="提交完成"
            label.font=UIFont.systemFont(ofSize: 20)
            label.textAlignment = .center
            label.snp.makeConstraints { (make) in
                make.width.equalTo(imageView1)
                make.height.equalTo(40)
                make.top.equalTo(imageView1.snp.bottom).offset(5)
                make.left.equalTo(imageView1)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       self.isHidden=true
        
    }
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

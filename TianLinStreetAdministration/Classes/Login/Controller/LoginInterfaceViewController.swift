    //
    //  LoginInterfaceViewController.swift
    //  PublicSecurityRepairs
    //
    //  Created by wangyuxiang on 2017/3/7.
    //  Copyright © 2017年 ShangHaiJinTian. All rights reserved.
    //
    
    import UIKit
    import SnapKit
    import Alamofire
    import Kingfisher
    import Toast_Swift
    import MJExtension
    import MBProgressHUD
    
    class LoginInterfaceViewController: UIViewController, UITextFieldDelegate {
        var textFile1=UITextField()
        var textFile2=UITextField()
        var keyHeight = CGFloat() //键盘的高度
        override func viewWillAppear(_ animated: Bool)
        {
            super.viewWillAppear(animated)
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
        
        override func viewDidDisappear(_ animated: Bool)
        {
            super.viewDidDisappear(animated)
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor=UIColor.white
            configUI()
            
            print("wyx: \(navigationBarHeight)")
        }
        
        func configUI()
        {
            
            
            //创建一个用于显示背景图片的imageView
            let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
            backgroundImage.image = UIImage(named: "mmexport1525609772323.jpg")
            backgroundImage.contentMode = .scaleAspectFill //等比缩放填充（图片可能有部分显示不全）
            //将背景图片imageView插入到当前视图中
            view.insertSubview(backgroundImage, at: 0)
            
//            let backImage=UIImageView()
//            backImage.image=UIImage(named: "mmexport1525609772323.jpg")
//            view.addSubview(backImage)
//            backImage.snp.makeConstraints { (make) in
//                make.left.right.top.bottom.equalTo(view)
//            }
            
            let label=UILabel()
            view.addSubview(label)
            label.text="智慧社区移动终端"
            label.textAlignment = .center
            label.font=UIFont.boldSystemFont(ofSize: 1)
            label.textColor=UIColor.init(red: 3/255, green: 109/255, blue: 253/255, alpha: 1)
            label.font=UIFont.systemFont(ofSize: 33)
            label.snp.makeConstraints { (make) in
                make.top.equalTo(view).offset(screenHeight/7)
                make.width.equalTo(screenWidth*4/5)
                make.left.equalTo(view).offset(screenWidth/14)
                make.right.equalTo(view).offset(-screenWidth/14)
                make.height.equalTo(screenHeight/14)
            }
            
            let label1=UILabel()
            view.addSubview(label1)
            label1.text=""
            
            //label1.font=UIFont.boldSystemFont(ofSize: 40)
            label1.textAlignment = .center
            label1.textColor=UIColor.init(red: 3/255, green: 109/255, blue: 253/255, alpha: 1)
            label1.font=UIFont.systemFont(ofSize: 33)
            label1.snp.makeConstraints { (make) in
                make.top.equalTo(label).offset(screenHeight/12)
                make.width.equalTo(screenWidth/2)
                make.left.equalTo(view).offset(screenWidth/4)
                make.height.equalTo(screenHeight/14)
            }
            
            let Phonelabel1=UILabel()
            view.addSubview(Phonelabel1)
            Phonelabel1.text="用户名"
            Phonelabel1.textAlignment = .left
            
            Phonelabel1.textColor=UIColor.init(red: 129/255, green: 139/255, blue: 157/255, alpha: 1)
            Phonelabel1.font=UIFont.systemFont(ofSize: 18)
            Phonelabel1.snp.makeConstraints { (make) in
                make.top.equalTo(label1.snp.bottom).offset(screenHeight/10)
                make.width.equalTo(screenWidth/2)
                make.left.equalTo(view).offset(screenWidth/12)
                make.height.equalTo(screenHeight/30)
            }
            
            view.addSubview(textFile1)
            textFile1.placeholder=""
            textFile1.textColor=UIColor.init(red: 90/255, green: 99/255, blue: 114/255, alpha: 1)
            textFile1.setValue(UIFont.systemFont(ofSize: 20), forKeyPath: "_placeholderLabel.font")
            textFile1.setValue(UIColor.init(red: 90/255, green: 99/255, blue: 114/255, alpha: 1), forKeyPath: "_placeholderLabel.textColor")
            textFile1.snp.makeConstraints { (make) in
                make.top.equalTo(Phonelabel1.snp.bottom).offset(0)
                make.left.equalTo(view).offset(screenWidth/8)
                make.right.equalTo(view).offset(0)
                make.height.equalTo(screenHeight/14)
            }
            
            let labelline=UIView()
            view.addSubview(labelline)
            //渐变颜色
            let TColorLabelline1 = UIColor.init(red: 254/255, green: 30/255, blue: 154/255, alpha: 1)
            let BColorLabelline1 = UIColor.init(red: 37/255, green: 77/255, blue: 222/255, alpha: 1)
            let gradientColorsLabelline1: [CGColor] = [TColorLabelline1.cgColor, BColorLabelline1.cgColor]
            let gradientLayerLabelline1: CAGradientLayer = CAGradientLayer()
            gradientLayerLabelline1.colors = gradientColorsLabelline1
            //(这里的起始和终止位置就是按照坐标系,四个角分别是左上(0,0),左下(0,1),右上(1,0),右下(1,1))
            gradientLayerLabelline1.startPoint = CGPoint(x: 0, y: 0)
            gradientLayerLabelline1.endPoint = CGPoint(x: 1, y: 0)
            //设置frame和插入view的layer
            gradientLayerLabelline1.frame = CGRect(x: 0, y: 0, width: screenWidth*5/6, height: 1)
            labelline.layer.insertSublayer(gradientLayerLabelline1, at: 0)
            labelline.backgroundColor=UIColor.init(red: 21/255, green: 114/255, blue: 249/255, alpha: 1)
            labelline.snp.makeConstraints { (make) in
                make.top.equalTo(textFile1.snp.bottom).offset(0)
                make.width.equalTo(screenWidth*5/6)
                make.left.equalTo(view).offset(screenWidth/12)
                make.height.equalTo(1)
            }
            
            let verificationlabel=UILabel()
            view.addSubview(verificationlabel)
            verificationlabel.text="密码"
            verificationlabel.textAlignment = .left
            verificationlabel.textColor=UIColor.init(red: 129/255, green: 139/255, blue: 157/255, alpha: 1)
            verificationlabel.font=UIFont.systemFont(ofSize: 18)
            verificationlabel.snp.makeConstraints { (make) in
                make.top.equalTo(labelline.snp.bottom).offset(screenHeight/20)
                make.width.equalTo(screenWidth/2)
                make.left.equalTo(view).offset(screenWidth/12)
                make.height.equalTo(screenHeight/30)
            }
            
            view.addSubview(textFile2)
            textFile2.placeholder=""
            textFile2.textColor=UIColor.init(red: 90/255, green: 99/255, blue: 114/255, alpha: 1)
            textFile2.isSecureTextEntry = true
            textFile2.setValue(UIFont.systemFont(ofSize: 20), forKeyPath: "_placeholderLabel.font")
            textFile2.setValue(UIColor.init(red: 90/255, green: 99/255, blue: 114/255, alpha: 1), forKeyPath: "_placeholderLabel.textColor")
            textFile2.snp.makeConstraints { (make) in
                make.top.equalTo(verificationlabel.snp.bottom).offset(0)
                make.left.equalTo(view).offset(screenWidth/8)
                make.width.equalTo(screenWidth/3)
                make.height.equalTo(screenHeight/14)
            }
            
            let btn1=UIButton()
            view.addSubview(btn1)
            btn1.setTitle("", for:.normal)
            // btn1.setTitle("", for:.highlighted)
            //btn1.setTitle("发送中", for:.selected)
            //btn1.addTarget(self, action: #selector(btn1Click), for: .touchUpInside)
            
            btn1.backgroundColor=UIColor.clear
            btn1.snp.makeConstraints { (make) in
                make.left.equalTo(textFile2.snp.right).offset(screenWidth/8)
                make.right.equalTo(view).offset(-screenWidth/14)
                make.top.equalTo(verificationlabel.snp.bottom).offset(0)
                make.height.equalTo(screenHeight/14)
            }
            
            let labelline2=UIView()
            view.addSubview(labelline2)
            
            //渐变颜色
            let TColorLabelline2 = UIColor.init(red: 254/255, green: 30/255, blue: 154/255, alpha: 1)
            let BColorLabelline2 = UIColor.init(red: 37/255, green: 77/255, blue: 222/255, alpha: 1)
            let gradientColorsLabelline2: [CGColor] = [TColorLabelline2.cgColor, BColorLabelline2.cgColor]
            let gradientLayerLabelline2: CAGradientLayer = CAGradientLayer()
            gradientLayerLabelline2.colors = gradientColorsLabelline2
            //(这里的起始和终止位置就是按照坐标系,四个角分别是左上(0,0),左下(0,1),右上(1,0),右下(1,1))
            gradientLayerLabelline2.startPoint = CGPoint(x: 0, y: 0)
            gradientLayerLabelline2.endPoint = CGPoint(x: 1, y: 0)
            //设置frame和插入view的layer
            gradientLayerLabelline2.frame = CGRect(x: 0, y: 0, width: screenWidth*5/6, height: 1)
            labelline2.layer.insertSublayer(gradientLayerLabelline2, at: 0)
            
            labelline2.backgroundColor=UIColor.init(red: 21/255, green: 114/255, blue: 249/255, alpha: 1)
            labelline2.snp.makeConstraints { (make) in
                make.top.equalTo(btn1.snp.bottom).offset(0)
                make.width.equalTo(screenWidth*5/6)
                make.left.equalTo(view).offset(screenWidth/12)
                make.height.equalTo(1)
            }
            
            let btn2=UIButton()
            view.addSubview(btn2)
            
            //渐变颜色
            let TColor = UIColor.init(red: 37/255, green: 77/255, blue: 222/255, alpha: 1)
            let BColor = UIColor.init(red: 0/255, green: 255/255, blue: 255/255, alpha: 1)
            let gradientColors: [CGColor] = [TColor.cgColor, BColor.cgColor]
            let gradientLayer: CAGradientLayer = CAGradientLayer()
            gradientLayer.colors = gradientColors
            //(这里的起始和终止位置就是按照坐标系,四个角分别是左上(0,0),左下(0,1),右上(1,0),右下(1,1))
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            //设置frame和插入view的layer
            gradientLayer.frame = CGRect(x: 0, y: 0, width: screenWidth/2, height: screenHeight/12)
            btn2.layer.insertSublayer(gradientLayer, at: 0)
            
            
            btn2.setTitleColor(UIColor.white, for: .normal)
            btn2.setTitle("登录", for: .normal)
            btn2.addTarget(self, action: #selector(enterClick),for: .touchUpInside)
            btn2.titleLabel?.textAlignment = .center
            
            btn2.snp.makeConstraints { (make) in
                make.left.equalTo(view).offset(screenWidth/4)
                make.right.equalTo(view).offset(-screenWidth/4)
                make.top.equalTo(labelline2.snp.bottom).offset(screenHeight/8)
                make.height.equalTo(screenHeight/12)
            }
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.textFile1.resignFirstResponder()
            self.textFile2.resignFirstResponder()
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            return true
        }
        
        func showCustomAlertView()
        {
            let frame:CGRect = CGRect(x: screenWidth * 0.2, y: screenHeight*0.2, width:screenWidth*0.6 , height: screenHeight*0.6)
            let  view:UIView = UIView.init(frame: frame)
            view.backgroundColor = UIColor.red
            self.view.addSubview(view)
        }
        
        
        //        func btn1Click(btn1:UIButton)  {
        //            if btn1.currentTitle  == "获取验证码" {
        //                btn1.setTitle("发送中60s", for: .normal)
        //            } else {
        //               btn1.setTitle("获取验证码", for: .normal)
        //            }
        //        }
        
        func enterClick(Btn:UIButton)
        {
            let loginName:String = self.textFile1.text!
            let loginPassword:String = self.textFile2.text!
            //self.showCustomAlertView()
            if loginName.isEmpty {
                self.view.makeToast("用户名不能为空", duration: 0.3, position: ToastPosition.center)
                return
            }
            
            if loginPassword.isEmpty {
                self.view.makeToast("密码不能为空")
                return
            }
            
            
            let parameters: Parameters = [
                "head":[
                    "platform":"app",
                    "timestamp":timeStamp,
                    "token":"app",
                    "longitude":longitude,
                     "latitude":latitude,
                ],
                "userName": loginName,
                "password": loginPassword
            ]
            
            
//            let parameters: Parameters = [
//                "head":[
//                    "platform":"app",
//                    "timestamp":timeStamp,
//                    "token":"app",
//                    "longitude":longitude,
//                    "latitude":latitude,
//                ],
//                "userName": "apptest",
//                "password": "123456"
//            ]
            print(parameters)
//          let vc=HomePageController()
//          vc.hidesBottomBarWhenPushed=true
//          self.navigationController?.pushViewController(vc, animated: true)
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = "登录中"
//          背景渐变效果
            hud.dimBackground = true
            Alamofire.request("http://47.75.190.168:5000/api/user/login", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ (response)  in
                let json = response.result.value
                  hud.hide(animated: true)
                print("json: \(json)")
                let loginModel : LonginModel = LonginModel.mj_object(withKeyValues: json)
                //let loginModel : LonginModel = LonginModel()
                //loginModel.mj_setKeyValues(json)
                //let model=LonginModel()
                //model.responseStatus?.resultCode
                print(loginModel.responseStatus?.resultCode)
                if loginModel.responseStatus?.resultCode == 0{
                    token1=loginModel.token!
                    let vc=HomePageController()
                    vc.hidesBottomBarWhenPushed=true
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                    self.view.makeToast((loginModel.responseStatus?.resultMessage)!, duration: 0.3, position: ToastPosition.center)
                }
            }
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    }

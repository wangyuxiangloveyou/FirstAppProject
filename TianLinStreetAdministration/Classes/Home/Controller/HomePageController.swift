    //
    //  HomePageController.swift
    //  TianLinStreetAdministration
    //
    //  Created by wangyuxiang on 2018/6/3.
    //  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
    //

    import UIKit
    import Alamofire
    import MBProgressHUD

    var homeData:[AnyObject]=[]
    class HomePageController: UIViewController {
        
        let label=UILabel()
        override func viewWillAppear(_ animated: Bool)
        {
            super.viewWillAppear(animated)
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        
        override func viewWillDisappear(_ animated: Bool)
        {
            super.viewDidDisappear(animated)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor=UIColor.init(red: 230/255, green: 230/255, blue: 245/255, alpha: 1)
            let backItem:UIBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backItem
            loadData1()
        }

        //home - 获取App全局配信息
        func loadData1()
        {
            let parameters: Parameters = [
                "head":[
                    "platform":"app",
                    "timestamp":timeStamp,
                    "token":token1,
                    "longitude":longitude,
                    "latitude":latitude,
                ]
            ]
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = "加载中"
            //背景渐变效果
            hud.alpha = 0.8
        
            Alamofire.request("http://47.75.190.168:5000/api/app/getAppGlobalConfig", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ (response)  in
                print("获取App全局配信息")
                hud.hide(animated: true)
                if let dic = response.result.value {
                    let data : NSData! = try! JSONSerialization.data(withJSONObject: dic, options: []) as NSData?
                    let json = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
                    
                print(json)
                     let homeModel = HomePageModel.mj_object(withKeyValues: json)
                    if homeModel?.responseStatus?.resultMessage == "请重新登录"{
                        if #available(iOS 11.0, *) {
                            let vc = LoginInterfaceViewController()
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                    
                    print("dic: \(dic)")
                    print("json: \(json)")
                    
                    if homeModel?.responseStatus?.resultCode==0 && homeModel?.functions != nil{
                    homeData=(homeModel?.functions)!
                    villageName=(homeModel?.villages![0].villageName)!
                    villageID=(homeModel?.villages![0].villageID)!
                    villageArray.append(villageID as AnyObject)
                    name=(homeModel?.prodcutName)!
                    for i in 0..<homeModel!.functions!.count{
                        if homeModel!.functions![i].code == "realTimeDeal"{
                            blockName2 = homeModel!.functions![i].name!
                             homeNumber2=(homeModel?.functions![i].unsolveNum)!
                        }
                        if homeModel!.functions![i].code == "alarmNotify"{
                            blockName3 = homeModel!.functions![i].name!
                             homeNumber3=(homeModel?.functions![i].unsolveNum)!
                        }
                        if homeModel!.functions![i].code == "deviceOps"{
                            blockName4 = homeModel!.functions![i].name!
                             homeNumber4=(homeModel?.functions![i].unsolveNum)!
                        }
                    }
                }
                }
                else
                {
                    //print("dic: \(response)")
                }
                self.configUI()
            }
        }
        
        func configUI(){
            
            
            let backImage=UIImageView()
            backImage.image=UIImage(named: "mmexport1525609772323.jpg")
            view.addSubview(backImage)
            backImage.snp.makeConstraints { (make) in
                make.left.right.top.bottom.equalTo(view)
            }
            
           // view.backgroundColor=UIColor(patternImage: UIImage(named: "mmexport1525609772323.jpg")!)
            view.addSubview(label)
            label.text=name
            label.numberOfLines=0
            label.textAlignment = .center
            label.textColor=UIColor.init(red: 3/255, green: 109/255, blue: 253/255, alpha: 1)
            
            label.font=UIFont.systemFont(ofSize: 33)
            label.snp.makeConstraints { (make) in
                make.top.equalTo(view).offset(screenHeight/7)
                make.left.equalTo(view).offset(screenWidth/12)
                make.right.equalTo(view).offset(-screenWidth/12)
                make.height.equalTo(screenHeight/7)
            }
            
            let label1=UILabel()
            view.addSubview(label1)
            label1.text=""
            label1.textAlignment = .center
            label1.font=UIFont.boldSystemFont(ofSize: 20)
            label1.textColor=UIColor.init(red: 3/255, green: 109/255, blue: 253/255, alpha: 1)
            label1.font=UIFont.systemFont(ofSize: 33)
            label1.snp.makeConstraints { (make) in
                make.top.equalTo(label).offset(screenHeight/12)
                make.width.equalTo(screenWidth/2)
                make.left.equalTo(view).offset(screenWidth/4)
                make.height.equalTo(0)
            }
            
            //移动发卡
            let moveImageView = UIImageView()
            //moveImageView.isHidden=true
            view.addSubview(moveImageView)
            moveImageView.layer.shadowOpacity = 0.35
            moveImageView.layer.shadowColor = UIColor.black.cgColor
            moveImageView.layer.shadowOffset = CGSize(width: 1, height: 2)
            
            moveImageView.backgroundColor=UIColor.white
            moveImageView.snp.makeConstraints { (make) in
                make.top.equalTo(label1).offset(screenHeight/8)
                make.left.equalTo(view).offset(screenWidth/9)
                make.height.equalTo(screenHeight/100*21)
                make.width.equalTo(screenWidth/3)
            }
            
            let moveTapGesture = UITapGestureRecognizer(target: self, action: #selector(moveImageViewClick))
            moveImageView.addGestureRecognizer(moveTapGesture)
            moveImageView.isUserInteractionEnabled = true
            
            
            let badgeLayermove=CATextLayer.createTextLayer()
            
            let formattor = NumberFormatter()
            formattor.numberStyle = .decimal
            let str = formattor.string(from: homeNumber2)
            print(Int(homeNumber2))
            if  Int(homeNumber2) > 99  {
                badgeLayermove.string="99+"
            }else{
                badgeLayermove.string=str
            }
            
            moveImageView.layer.addSublayer(badgeLayermove)
            badgeLayermove.frame=CGRect(x: screenWidth/3-30, y: 3, width: 22, height: 22)
            badgeLayermove.cornerRadius=11
            
            let smallMoveImageView = UIImageView()
            moveImageView.addSubview(smallMoveImageView)
            smallMoveImageView.image=UIImage(named: "移动发卡.png")
            smallMoveImageView.snp.makeConstraints { (make) in
                make.top.equalTo(moveImageView).offset(screenHeight/30)
                make.left.equalTo(moveImageView).offset(screenWidth/9)
                make.height.equalTo(41)
                make.width.equalTo(41)
            }
            
            let Movelabel = UILabel()
            moveImageView.addSubview(Movelabel)
            
            Movelabel.text=blockName2
            Movelabel.font=UIFont.systemFont(ofSize: 17)
            Movelabel.textAlignment = .center
            Movelabel.snp.makeConstraints { (make) in
                make.top.equalTo(smallMoveImageView.snp.bottom).offset(0)
                make.left.equalTo(moveImageView).offset(0)
                make.height.equalTo(screenHeight/20)
                make.width.equalTo(screenWidth/3)
            }
            
            let addLabel = UILabel()
            moveImageView.addSubview(addLabel)
            addLabel.text="进入"
            addLabel.font=UIFont.systemFont(ofSize: 14)
            addLabel.textAlignment = .center
            
            let  gradientLayer1 = CAGradientLayer.createCAGradientLayer()
            addLabel.layer.insertSublayer(gradientLayer1, at: 0)
            //倒圆角
            //        addLabel.layer.cornerRadius = 8;
            //        addLabel.clipsToBounds = true
            addLabel.textColor=UIColor.white
            
            addLabel.snp.makeConstraints { (make) in
                make.top.equalTo(Movelabel.snp.bottom).offset(3)
                make.left.equalTo(moveImageView).offset(screenWidth/30)
                make.height.equalTo(screenHeight/25)
                make.width.equalTo(screenWidth/3-screenWidth/15)
            }
            
            //预警
            let warningImageView = UIImageView()
            view.addSubview(warningImageView)
            warningImageView.backgroundColor=UIColor.white
            
            warningImageView.layer.shadowOpacity = 0.35
            warningImageView.layer.shadowColor = UIColor.black.cgColor
            warningImageView.layer.shadowOffset = CGSize(width: 1, height: 2)
            
            warningImageView.snp.makeConstraints { (make) in
                make.top.equalTo(label1).offset(screenHeight/8)
                make.left.equalTo(moveImageView.snp.right).offset(screenWidth/9)
                make.height.equalTo(screenHeight/100*21)
                make.width.equalTo(screenWidth/3)
            }
            let warningTapGesture = UITapGestureRecognizer(target: self, action: #selector(warningImageViewClick))
            warningImageView.addGestureRecognizer(warningTapGesture)
            warningImageView.isUserInteractionEnabled = true
            
            let badgeLayerWarning=CATextLayer.createTextLayer()
            
            let formattor2 = NumberFormatter()
            formattor2.numberStyle = .decimal
            let str2 = formattor2.string(from: homeNumber3)
            print(Int(homeNumber2))
            if  Int(homeNumber2) > 99  {
                badgeLayerWarning.string="99+"
            }else{
                badgeLayerWarning.string=str2
            }
           
            warningImageView.layer.addSublayer(badgeLayerWarning)
            badgeLayerWarning.frame=CGRect(x: screenWidth/3-30, y: 3, width: 22, height: 22)
            badgeLayerWarning.cornerRadius=11
            
            let smallwarningImageView = UIImageView()
            warningImageView.addSubview(smallwarningImageView)
            smallwarningImageView.image=UIImage(named: "预警.png")
            smallwarningImageView.snp.makeConstraints { (make) in
                make.top.equalTo(warningImageView).offset(screenHeight/30)
                make.left.equalTo(warningImageView).offset(screenWidth/9)
                make.height.equalTo(41)
                make.width.equalTo(41)
            }
            
            let warninglabel = UILabel()
            warningImageView.addSubview(warninglabel)
            warninglabel.text=blockName3
            warninglabel.font=UIFont.systemFont(ofSize: 17)
            warninglabel.textAlignment = .center
            warninglabel.snp.makeConstraints { (make) in
                make.top.equalTo(smallwarningImageView.snp.bottom).offset(0)
                make.left.equalTo(warningImageView).offset(0)
                make.height.equalTo(screenHeight/20)
                make.width.equalTo(screenWidth/3)
            }
            
            let addLabel2 = UILabel()
            warningImageView.addSubview(addLabel2)
            addLabel2.text="进入"
            addLabel2.font=UIFont.systemFont(ofSize: 14)
            addLabel2.textAlignment = .center
            addLabel2.textColor=UIColor.white
            
            
            let  gradientLayer2 = CAGradientLayer.createCAGradientLayer()
            addLabel2.layer.insertSublayer(gradientLayer2, at: 0)
            
            addLabel2.snp.makeConstraints { (make) in
                make.top.equalTo(warninglabel.snp.bottom).offset(3)
                make.left.equalTo(warningImageView).offset(screenWidth/30)
                make.height.equalTo(screenHeight/25)
                make.width.equalTo(screenWidth/3-screenWidth/15)
            }
            
            //提醒
            let remindImageView = UIImageView()
            view.addSubview(remindImageView)
             remindImageView.isHidden=true
            remindImageView.backgroundColor=UIColor.white
            
            remindImageView.layer.shadowOpacity = 0.35
            remindImageView.layer.shadowColor = UIColor.black.cgColor
            remindImageView.layer.shadowOffset = CGSize(width: 1, height: 2)
            
            remindImageView.snp.makeConstraints { (make) in
                make.top.equalTo(moveImageView.snp.bottom).offset(screenHeight/16)
                make.left.equalTo(view).offset(screenWidth/9)
                make.height.equalTo(screenHeight/100*21)
                make.width.equalTo(screenWidth/3)
            }
            
            let remindTapGesture = UITapGestureRecognizer(target: self, action: #selector(remindImageViewClick))
            remindImageView.addGestureRecognizer(remindTapGesture)
            remindImageView.isUserInteractionEnabled = true
            
            let badgeLayerRemind=CATextLayer.createTextLayer()
            let formattor3 = NumberFormatter()
            formattor3.numberStyle = .decimal
            let str3 = formattor3.string(from: homeNumber3)
           
            if  Int(homeNumber3) > 99  {
                badgeLayerRemind.string="99+"
            }else{
               badgeLayerRemind.string=str3
            }
            remindImageView.layer.addSublayer(badgeLayerRemind)
            badgeLayerRemind.frame=CGRect(x: screenWidth/3-30, y: 3, width: 22, height: 22)
            badgeLayerRemind.cornerRadius=11
            
            let smallremindImageView = UIImageView()
            remindImageView.addSubview(smallremindImageView)
            smallremindImageView.image=UIImage(named: "提醒.png")
            smallremindImageView.snp.makeConstraints { (make) in
                make.top.equalTo(remindImageView).offset(screenHeight/30)
                make.left.equalTo(remindImageView).offset(screenWidth/9)
                make.height.equalTo(41)
                make.width.equalTo(41)
            }
            
            let remindlabel = UILabel()
            remindImageView.addSubview(remindlabel)
            remindlabel.text=blockName3
            remindlabel.font=UIFont.systemFont(ofSize: 17)
            remindlabel.textAlignment = .center
            remindlabel.snp.makeConstraints { (make) in
                make.top.equalTo(smallremindImageView.snp.bottom).offset(0)
                make.left.equalTo(remindImageView).offset(0)
                make.height.equalTo(screenHeight/20)
                make.width.equalTo(screenWidth/3)
            }
            
            let addLabel3 = UILabel()
            remindImageView.addSubview(addLabel3)
            addLabel3.text="进入"
            addLabel3.font=UIFont.systemFont(ofSize: 14)
            addLabel3.textAlignment = .center
            addLabel3.textColor=UIColor.white
            
            
            let  gradientLayer3 = CAGradientLayer.createCAGradientLayer()
            addLabel3.layer.insertSublayer(gradientLayer3, at: 0)
            addLabel3.snp.makeConstraints { (make) in
                make.top.equalTo(remindlabel.snp.bottom).offset(3)
                make.left.equalTo(remindImageView).offset(screenWidth/30)
                make.height.equalTo(screenHeight/25)
                make.width.equalTo(screenWidth/3-screenWidth/15)
            }
            
            //运维
            let MaintainImageView = UIImageView()
            view.addSubview(MaintainImageView)
           MaintainImageView.isHidden=true
            MaintainImageView.backgroundColor=UIColor.white
            MaintainImageView.layer.shadowOpacity = 0.35
            MaintainImageView.layer.shadowColor = UIColor.black.cgColor
            MaintainImageView.layer.shadowOffset = CGSize(width: 1, height: 2)
            
            MaintainImageView.snp.makeConstraints { (make) in
                make.top.equalTo(warningImageView.snp.bottom).offset(screenHeight/16)
                make.left.equalTo(remindImageView.snp.right).offset(screenWidth/9)
                make.height.equalTo(screenHeight/100*21)
                make.width.equalTo(screenWidth/3)
            }
            
            let MaintainTapGesture = UITapGestureRecognizer(target: self, action: #selector(MaintainImageViewClick))
            MaintainImageView.addGestureRecognizer(MaintainTapGesture)
            MaintainImageView.isUserInteractionEnabled = true
            
            
            let badgeLayerMaintain=CATextLayer.createTextLayer()
            let formattor4 = NumberFormatter()
            formattor4.numberStyle = .decimal
            let str4 = formattor4.string(from: homeNumber4)
            if  Int(homeNumber4) > 99  {
                badgeLayerMaintain.string="99+"
            }else{
                badgeLayerMaintain.string=str4
            }
            MaintainImageView.layer.addSublayer(badgeLayerMaintain)
            badgeLayerMaintain.frame=CGRect(x: screenWidth/3-30, y: 3, width: 22, height: 22)
            badgeLayerMaintain.cornerRadius=11
            
            let smallMaintainImageView = UIImageView()
            MaintainImageView.addSubview(smallMaintainImageView)
            smallMaintainImageView.image=UIImage(named: "运维.png")
            smallMaintainImageView.snp.makeConstraints { (make) in
                make.top.equalTo(MaintainImageView).offset(screenHeight/30)
                make.left.equalTo(MaintainImageView).offset(screenWidth/9)
                make.height.equalTo(41)
                make.width.equalTo(41)
            }
            
            let Maintainlabel = UILabel()
            MaintainImageView.addSubview(Maintainlabel)
            Maintainlabel.text=blockName4
            Maintainlabel.font=UIFont.systemFont(ofSize: 17)
            Maintainlabel.textAlignment = .center
            Maintainlabel.snp.makeConstraints { (make) in
                make.top.equalTo(smallMaintainImageView.snp.bottom).offset(0)
                make.left.equalTo(MaintainImageView).offset(0)
                make.height.equalTo(screenHeight/20)
                make.width.equalTo(screenWidth/3)
            }
            
            let addLabel4 = UILabel()
            MaintainImageView.addSubview(addLabel4)
            addLabel4.text="进入"
            addLabel4.font=UIFont.systemFont(ofSize: 14)
            addLabel4.textAlignment = .center
            addLabel4.textColor=UIColor.white
            
            let  gradientLayer4 = CAGradientLayer.createCAGradientLayer()
            addLabel4.layer.insertSublayer(gradientLayer4, at: 0)
            addLabel4.snp.makeConstraints { (make) in
                make.top.equalTo(Maintainlabel.snp.bottom).offset(3)
                make.left.equalTo(MaintainImageView).offset(screenWidth/30)
                make.height.equalTo(screenHeight/25)
                make.width.equalTo(screenWidth/3-screenWidth/15)
            }
           
        }
        
        func moveImageViewClick(tap1:UITapGestureRecognizer)  {
    //        let vc = HairpinViewController()
             let vc = EarlyWarningController()
            vc.hidesBottomBarWhenPushed=true
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
        func warningImageViewClick(tap2:UITapGestureRecognizer)  {
           // let vc = EarlyWarningController()
            let vc = RemindViewController()
            vc.hidesBottomBarWhenPushed=true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        func remindImageViewClick(tap2:UITapGestureRecognizer)  {
            let vc = RemindViewController()
            vc.hidesBottomBarWhenPushed=true
            
            self.navigationController?.pushViewController(vc, animated: true)
        
        }
        
        func MaintainImageViewClick(tap2:UITapGestureRecognizer)  {
            let vc = MaintainViewController()
            vc.hidesBottomBarWhenPushed=true
           
            self.navigationController?.pushViewController(vc, animated: true)
        
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        /*
         // MARK: - Navigation
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destinationViewController.
         // Pass the selected object to the new view controller.
         }
         */
        
    }

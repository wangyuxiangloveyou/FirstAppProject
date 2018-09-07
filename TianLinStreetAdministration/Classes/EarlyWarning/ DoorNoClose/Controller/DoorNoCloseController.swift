    //
//  DoorNoCloseController.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/4.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//
import UIKit
import IQKeyboardManagerSwift
import Alamofire
import Speech
import SnapKit
import Toast_Swift
import MBProgressHUD
    
public var number1=0
public var dataArry1:NSMutableArray=[]
public var dataArryID:[String]=[]
public var localTime=0
class DoorNoCloseController: UIViewController,UITextViewDelegate,UITextFieldDelegate, SFSpeechRecognizerDelegate {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "zh_CN"))  //1
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    var segCtrl:KtcSegCtrl?
    
    var bottomConstraint:ConstraintMakerEditable? = nil
    var sceneType = 1
    //滚动视图
   // var bottomConstraint:ConstraintMakerEditable? = nil
    var timer1:Timer?
     var  unResultType = 1
    let  timeLabel=UILabel()
    let addressLabel=UILabel()
    let imageView1=UIImageView()
    public var scrollView:UIScrollView?
    let commonBtn=UIButton()
    var view1=UIView()
    var firstView:UntreatedDoorView?
    var secondView:NowDoorView?
    var ThreeView:CompleteDoorView?
    var btn1=UIButton()
    var btn2=UIButton()
    var speciaBtn=UIButton()
    var noSpeciaBtn=UIButton()
    var allLabel=UILabel()
    var allTextView=UITextView()
    var countDownLabel=UILabel()
    var allLabel2=UILabel()
    var allTextView2=UITextView()
    let sayBtn1=UIButton()
    let sayBtn2=UIButton()
    let labelButtom1=UILabel()
    let labelButtom2=UILabel()
    let labelline1=UIView()
    let labelline2=UIView()
    let fourLabel=UILabel()
    var idDoor=""
    var dataSourceDoor:UntreatedDoorEventsModel?
    var dataDoorNow:UntreatedDoorEventsModel?
    
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sayBtn1.isEnabled = false  //2
        sayBtn2.isEnabled = false  //2
        speechRecognizer?.delegate = self  //3
        SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
            
            var isButtonEnabled = false
            switch authStatus {  //5
            case .authorized:
                isButtonEnabled = true
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            //OperationQueue.main.addOperation() {self.sayBtn.isEnabled = isButtonEnabled
            self.sayBtn1.isEnabled = isButtonEnabled
            self.sayBtn2.isEnabled = isButtonEnabled
            //  }
        }
        
        
        self.view.backgroundColor=UIColor.white
        IQKeyboardManager.sharedManager().enable = true
        self.title="门未关"
        creatNav()
        configUI2()
        //loadData1()
        firstView?.doorCellClourse = {
            (doorDataSource) in
            self.dataSourceDoor=doorDataSource as! UntreatedDoorEventsModel
            dataArry1.add(self.dataSourceDoor)
            dataMutable[(self.dataSourceDoor?.eventID)!]=300
            print(dataMutable)
           
            dataArryID.append((self.dataSourceDoor?.eventID)!)
            print(dataArryID)
            let vc=pictureController()
            number1=1
//            self.navigationController?.pushViewController(vc, animated: true)
            let vc1=TimerView()
            self.view?.addSubview(vc1)
            vc1.snp.makeConstraints({ (make) in
                make.bottom.left.right.equalTo(self.view!)
                make.top.equalTo(self.view!).offset(0)
            })
           
            self.segCtrl?.selectIndex=1
            self.scrollView?.contentOffset.x=1*(self.scrollView?.bounds.size.width)!
            self.secondView?.tableView?.reloadData()
        }
        
        
        secondView?.doorCellClourseTwo = {
            (dataSoureDoorNow)in
            self.dataDoorNow=dataSoureDoorNow as! UntreatedDoorEventsModel
            print(self.dataDoorNow?.eventID)
            self.idDoor=(self.dataDoorNow?.eventID)!
            print("响应了")
           
           localTime = self.getSecondsFromTimeStr(timeStr: timeSecod as! String)
            self.timer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.tickDown), userInfo: nil, repeats: true)
             self.configUI1()
        }
        firstView?.repairCellClourse = {
            (dataSoureDoorNow) in
            self.dataDoorNow=dataSoureDoorNow as! UntreatedDoorEventsModel
            print(self.dataDoorNow?.eventID)
            self.idDoor=(self.dataDoorNow?.eventID)!
            self.configUI1()
        }
    }
   
    //event - 门禁事件处理进度上报
    func loadData1()
    {
        var parameters:Parameters!
        if unResultType == 1{
            parameters = [
            "head":[
                "platform":"app",
                "timestamp":timeStamp,
                "token":token1,
                "longitude":longitude,
                "latitude":latitude,
            ],
            "status":1,
            "eventID":self.idDoor,
            "resultType":unResultType,
            "sceneType":sceneType,
            "result":allTextView2.text
        ]
        }
        if unResultType==2{
            parameters = [
                "head":[
                    "platform":"app",
                    "timestamp":timeStamp,
                    "token":token1,
                    "longitude":longitude,
                    "latitude":latitude,
                ],
                "status":1,
                "eventID":self.idDoor,
                "resultType":unResultType,
                "sceneType":sceneType,
                "result":allTextView.text
            ]
        }
        
        print(parameters)
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "登录中"
        //背景渐变效果
        hud.dimBackground = true
        Alamofire.request("http://47.75.190.168:5000/api/app/accessProcessReport", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ (response)  in
            print(token1)
             hud.hide(animated: true)
            if let dic = response.result.value {
                let data : NSData! = try! JSONSerialization.data(withJSONObject: dic, options: []) as NSData?
                let json = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
                print(json)
                print("门禁事件处理进度上报")
                print("dic: \(dic)")
            let loginModel : LonginModel = LonginModel.mj_object(withKeyValues: json)
            if loginModel.responseStatus?.resultCode == 0 {
                self.commonBtn.removeFromSuperview()
                let vc = pictureController()
                number1=3
                let vc1=TimerView()
                self.view?.addSubview(vc1)
                vc1.snp.makeConstraints({ (make) in
                    make.bottom.left.right.equalTo(self.view!)
                    make.top.equalTo(self.view!).offset(0)
                })
                self.view1.removeFromSuperview()
                self.segCtrl?.selectIndex=2
                self.scrollView?.contentOffset.x=2*(self.scrollView?.bounds.size.width)!
                
                
                
                for i in 0..<dataArry1.count{
                    if (dataArry1[i] as AnyObject).eventID == self.idDoor{
                        
                        dataArry1.remove(dataArry1[i])
                        self.secondView?.tableView?.reloadData()
                    }
                }
            }else {
                self.view.makeToast((loginModel.responseStatus?.resultMessage)!, duration: 0.3, position: ToastPosition.center)
            }
            }
        }
    }
    
//    override func viewSafeAreaInsetsDidChange() {
//        if #available(iOS 11.0, *) {
//            super.viewSafeAreaInsetsDidChange()
//            NSLog("viewSafeAreaInsetsDidChange-%@",NSStringFromUIEdgeInsets(self.view.safeAreaInsets))
//        } else {
//            // Fallback on earlier versions
//        }
//        self.updateOrientation()
//    }
    /**
     更新屏幕safearea frame
     */
//    func updateOrientation()
//    {
//        if #available(iOS 11.0, *) {
//            var frame = self.view.frame
//            frame.origin.x = self.view.safeAreaInsets.left
//            frame.size.width  = self.view.frame.size.width - self.view.safeAreaInsets.left - self.view.safeAreaInsets.right
//            frame.size.height = self.view.frame.size.height - self.view.safeAreaInsets.bottom
//            self.view.frame = frame
//        }
//    }
    
    
    func tickDown()
    {
        
       print(localTime)
        if localTime > 0{
            localTime = localTime-1
            var localTime1:String = getFormatPlayTime(secounds: TimeInterval(localTime))
            print(localTime1)
            timeLabel.text="倒计时 "+localTime1
        }
        if localTime == 0{
            timeLabel.text="倒计时 :00:00:00"
        }
        
    }
    
    
    
    // 秒转换成00:00:00格式
    
    func getFormatPlayTime(secounds:TimeInterval)->String{
        if secounds.isNaN{
            return "00:00"
        }
        var Min = Int(secounds / 60)
        let Sec = Int(secounds.truncatingRemainder(dividingBy: 60))
        var Hour = 0
        if Min>=60 {
            Hour = Int(Min / 60)
            Min = Min - Hour*60
            print(String(format: "%02d:%02d:%02d", Hour, Min, Sec))
            return String(format: "%02d:%02d:%02d", Hour, Min, Sec)
        }
        print(String(format: "00:%02d:%02d", Min, Sec))
        return String(format: "00:%02d:%02d", Min, Sec)
    }
    
    
    func getSecondsFromTimeStr(timeStr:String) -> Int {
        print(timeSecod)
        if timeStr.isEmpty {
            return 0
        }
        let timeArry = timeStr.replacingOccurrences(of: "：", with: ":").components(separatedBy: ":")
        var seconds:Int = 0
        
        if timeArry.count > 0 {
            let hh = Int(timeArry[0])
            if hh! > 0 {
                seconds += hh!*60*60
            }
        }
        if timeArry.count > 1{
            let mm = Int(timeArry[1])
            if mm! > 0 {
                seconds += mm!*60
            }
        }
        if timeArry.count > 2{
            let ss = Int(timeArry[2])
            if ss! > 0 {
                seconds += ss!
            }
        }
        return seconds
    }
    
    func configUI1() {
        print("布局")
        self.segCtrl?.selectIndex=1
        self.scrollView?.contentOffset.x=(self.scrollView?.bounds.size.width)!
        secondView?.backgroundColor=UIColor.white
        secondView?.backgroundColor=UIColor(patternImage:UIImage(named:"mmexport1525609772323.jpg")!)
        secondView?.tableView?.isHidden=true
        self.view1.backgroundColor=UIColor.white
        self.secondView?.addSubview(self.view1)
       
        //   let view1TapGesture = UITapGestureRecognizer(target: self, action: #selector(view1Click))
        //   view1.addGestureRecognizer(view1TapGesture)
        
        view1.layer.shadowOpacity = 0.3
        view1.layer.shadowColor = UIColor.black.cgColor
        view1.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        self.view1.snp.makeConstraints { (make) in
            make.top.equalTo(self.secondView!)
            make.left.equalTo(self.secondView!)
            make.right.equalTo(self.secondView!)
        }
        
        self.view1.addSubview(imageView1)
        imageView1.image=UIImage(named: "居民楼-黑.png")
        imageView1.snp.makeConstraints { (make) in
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.left.equalTo(view1).offset(0)
            make.top.left.equalTo(self.view1).offset(5)
        }
        
        
        self.view1.addSubview(addressLabel)
        
        addressLabel.font=UIFont.systemFont(ofSize: 15)
        addressLabel.textColor=UIColor.init(red: 0/255, green: 123/255, blue: 195/255, alpha: 1)
        
        let str = "田林十二村 4栋"
        let moneyTitle = NSMutableAttributedString.init(string:str)
        moneyTitle.addAttribute(NSForegroundColorAttributeName, value:UIColor.red, range:NSRange.init(location:6, length: 2))
        moneyTitle.addAttribute(NSFontAttributeName, value:UIFont.systemFont(ofSize:20), range:NSRange.init(location:6, length: 2))
        addressLabel.attributedText = moneyTitle
        
        addressLabel.snp.makeConstraints { (make) in
            make.width.equalTo(screenWidth/2)
            make.height.equalTo(30)
            make.left.equalTo(imageView1.snp.right).offset(5)
            make.top.equalTo(self.view1).offset(5)
        }
        
        self.view1.addSubview(timeLabel)
        
        timeLabel.font=UIFont.systemFont(ofSize: 12)
        timeLabel.textColor=UIColor.red
        timeLabel.snp.makeConstraints { (make) in
            make.width.equalTo(screenWidth/2-45)
            make.height.equalTo(30)
            make.left.equalTo(addressLabel.snp.right).offset(10)
            make.top.equalTo(self.view1).offset(5)
        }
        
        self.view1.addSubview(self.btn1)
        self.btn1.layer.borderWidth = 1
        self.btn1.layer.borderColor = UIColor.lightGray.cgColor
        self.btn1.setTitle("人为", for: .normal)
        self.btn1.addTarget(self, action: #selector(self.btn1Click), for: .touchUpInside)
        self.btn1.backgroundColor=UIColor.white
        self.btn1.setImage(UIImage(named: "checkbox_off_light"), for: .normal)
        self.btn1.setTitleColor(UIColor.black, for: .normal)
        self.btn1.snp.makeConstraints { (make) in
            make.width.equalTo(screenWidth/2)
            make.height.equalTo(55)
            make.left.equalTo(self.secondView!).offset(0)
            make.top.equalTo(addressLabel.snp.bottom).offset(5)
        }
        
        
        self.view1.addSubview(self.btn2)
        self.btn2.setTitle("非人为", for: .normal)
        self.btn2.addTarget(self, action: #selector(self.btn2Click), for: .touchUpInside)
        self.btn2.backgroundColor=UIColor.white
        self.btn2.layer.borderWidth = 1
        self.btn2.layer.borderColor = UIColor.lightGray.cgColor
        self.btn2.setImage(UIImage(named: "Check box"), for: .normal)
        self.btn2.setTitleColor(UIColor.black, for: .normal)
        self.btn2.snp.makeConstraints { (make) in
            make.width.equalTo(screenWidth/2)
            make.height.equalTo(55)
            make.left.equalTo(self.btn1.snp.right).offset(0)
            make.top.equalTo(addressLabel.snp.bottom).offset(5)
        }
        
        view1.addSubview(allLabel2)
        allLabel2.text="备注"
        allLabel2.textColor=UIColor.lightGray
        allLabel2.font=UIFont.systemFont(ofSize: 15)
        allLabel2.snp.makeConstraints { (make) in
            make.width.equalTo(screenWidth/2)
            make.height.equalTo(20)
            make.left.equalTo(view1).offset(20)
            make.top.equalTo(btn2.snp.bottom).offset(5)
        }
        
        view1.addSubview(allTextView2)
//      allTextView2.placeholder="情况说明"
        allTextView2.textColor=UIColor.black
        allTextView2.textAlignment = .left
        allTextView2.font=UIFont.systemFont(ofSize: 15)
        allTextView2.snp.makeConstraints { (make) in
            make.width.equalTo(screenWidth-20)
            make.height.equalTo(130)
            make.left.equalTo(view1).offset(10)
            make.top.equalTo(allLabel2.snp.bottom).offset(-3)
        }
        
        view1.addSubview(sayBtn2)
        //sayBtn2.backgroundColor=UIColor.red
        sayBtn2.setImage(UIImage(named: "Voice.png"), for: .normal)
        sayBtn2.addTarget(self, action: #selector(sayClick2), for: .touchUpInside)
        sayBtn2.snp.makeConstraints { (make) in
            make.left.equalTo(allTextView2.snp.right).offset(-30)
            make.width.equalTo(24)
            make.bottom.equalTo(allTextView2)
            make.height.equalTo(30)
        }
        
        view1.addSubview(labelline2)
        labelline2.backgroundColor=UIColor.init(red: 0/255, green: 150/255, blue: 136/255, alpha: 1)
        labelline2.snp.makeConstraints { (make) in
            make.top.equalTo(allTextView2.snp.bottom).offset(0)
            make.width.equalTo(screenWidth-20)
            make.left.equalTo(view1).offset(10)
            make.height.equalTo(1)
        }
        
        
        view1.addSubview(labelButtom2)
        labelButtom2.text="110/120"
        labelButtom2.font=UIFont.systemFont(ofSize: 15)
        labelButtom2.snp.makeConstraints { (make) in
            make.top.equalTo(labelline2.snp.bottom).offset(0)
            make.width.equalTo(60)
            make.right.equalTo(view1.snp.right).offset(-3)
            make.height.equalTo(25)
            self.bottomConstraint = make.bottom.equalTo(self.view1.snp.bottom)
        }
        
        
        self.secondView?.addSubview(commonBtn)
        commonBtn.setTitle("提交", for: .normal)
        //渐变颜色
        let gradientLayer1: CAGradientLayer = CAGradientLayer.createCAGradientLayer()
        let TColor = UIColor.init(red: 37/255, green: 77/255, blue: 222/255, alpha: 1)
        let BColor = UIColor.init(red: 0/255, green: 255/255, blue: 255/255, alpha: 1)
        let gradientColors1: [CGColor] = [TColor.cgColor, BColor.cgColor]
        gradientLayer1.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 70)
        gradientLayer1.colors = gradientColors1
        commonBtn.layer.insertSublayer(gradientLayer1, at: 0)
        commonBtn.addTarget(self, action: #selector(self.commonClick), for: .touchUpInside)
        commonBtn.backgroundColor=UIColor.init(red: 77/255, green: 160/255, blue: 209/255, alpha: 1)
        commonBtn.setTitleColor(UIColor.white, for: .normal)
        commonBtn.snp.makeConstraints { (make) in
            make.width.equalTo(screenWidth)
            make.height.equalTo(58)
            make.left.right.bottom.equalTo(self.secondView!).offset(0)
        }
    }
    
    
    func btn1Click(btn1:UIButton)  {
        unResultType=1
        if btn1.isSelected  == false {
            btn1.setImage(UIImage(named: "Check box"), for: .normal)
            btn2.setImage(UIImage(named: "checkbox_off_light"), for: .normal)
            
            labelline2.isHidden=true
            labelButtom2.isHidden=true
            sayBtn2.isHidden=true
            allLabel2.isHidden=true
            allTextView2.isHidden=true
            
            fourLabel.isHidden=false
            labelline1.isHidden=false
            labelButtom1.isHidden=false
            sayBtn1.isHidden=false
            allLabel.isHidden=false
            allTextView.isHidden=false
            speciaBtn.isHidden=false
            noSpeciaBtn.isHidden=false
            
            
            self.view1.addSubview(self.speciaBtn)
            speciaBtn.setTitle("特殊情况", for: .normal)
            speciaBtn.titleLabel?.font=UIFont.systemFont(ofSize: 16)
            speciaBtn.addTarget(self, action: #selector(self.speciaClick), for: .touchUpInside)
            speciaBtn.backgroundColor=UIColor.white
            speciaBtn.tintColor=UIColor.init(red: 0/255, green: 123/255, blue: 195/255, alpha: 1)
            speciaBtn.setImage(UIImage(named: "radio_off_light"), for: .normal)
            speciaBtn.setTitleColor(UIColor.init(red: 0/255, green: 123/255, blue: 195/255, alpha: 1), for: .normal)
            speciaBtn.snp.makeConstraints { (make) in
                make.width.equalTo(screenWidth/2)
                make.height.equalTo(55)
                make.left.equalTo(self.secondView!).offset(0)
                make.top.equalTo(btn1.snp.bottom).offset(0)
            }
            
            speciaBtn.addSubview(fourLabel)
            fourLabel.text="搬家/装修/结婚/丧事"
            fourLabel.font=UIFont.systemFont(ofSize: 12)
            fourLabel.textColor=UIColor.lightGray
            fourLabel.snp.makeConstraints { (make) in
                make.width.equalTo(screenWidth/2)
                make.height.equalTo(25)
                make.left.equalTo(speciaBtn).offset(screenWidth/8)
                make.top.equalTo(speciaBtn).offset(35)
            }
            
            
            self.view1.addSubview(self.noSpeciaBtn)
            noSpeciaBtn.setTitle("非特殊情况", for: .normal)
            noSpeciaBtn.titleLabel?.font=UIFont.systemFont(ofSize: 16)
            noSpeciaBtn.addTarget(self, action: #selector(self.noSpeciaClick), for: .touchUpInside)
            noSpeciaBtn.backgroundColor=UIColor.white
            noSpeciaBtn.setImage(UIImage(named: "radio_on_light"), for: .normal)
            noSpeciaBtn.setTitleColor(UIColor.init(red: 0/255, green: 123/255, blue: 195/255, alpha: 1), for: .normal)
            noSpeciaBtn.snp.makeConstraints { (make) in
                make.width.equalTo(screenWidth/2)
                make.height.equalTo(55)
                make.left.equalTo(self.btn1.snp.right).offset(0)
                make.top.equalTo(btn1.snp.bottom).offset(0)
            }
            
            
            
            view1.addSubview(allLabel)
            allLabel.text="备注"
            allLabel.textColor=UIColor.lightGray
            allLabel.font=UIFont.systemFont(ofSize: 14)
            allLabel.snp.makeConstraints { (make) in
                make.width.equalTo(screenWidth/2)
                make.height.equalTo(20)
                make.left.equalTo(view1).offset(20)
                make.top.equalTo(noSpeciaBtn.snp.bottom).offset(5)
            }
            
            view1.addSubview(allTextView)
//            allTextView.placeholder="情况说明"
            allTextView.textColor=UIColor.black
            allTextView.textAlignment = .left
            allTextView.font=UIFont.systemFont(ofSize: 18)
            allTextView.snp.makeConstraints { (make) in
                make.width.equalTo(screenWidth-20)
                make.height.equalTo(130)
                make.left.equalTo(view1).offset(10)
                make.top.equalTo(allLabel.snp.bottom).offset(-3)
            }
            
            
            view1.addSubview(sayBtn1)
            sayBtn1.setImage(UIImage(named: "Voice.png"), for: .normal)
            sayBtn1.addTarget(self, action: #selector(sayClick1), for: .touchUpInside)
            sayBtn1.snp.makeConstraints { (make) in
                make.left.equalTo(allTextView.snp.right).offset(-30)
                make.width.equalTo(24)
                make.bottom.equalTo(allTextView)
                make.height.equalTo(30)
            }
            
            
            view1.addSubview(labelline1)
            labelline1.backgroundColor=UIColor.init(red: 0/255, green: 150/255, blue: 136/255, alpha: 1)
            labelline1.snp.makeConstraints { (make) in
                make.top.equalTo(allTextView.snp.bottom).offset(0)
                make.width.equalTo(screenWidth-20)
                make.left.equalTo(view1).offset(10)
                make.height.equalTo(1)
            }
            
            view1.addSubview(labelButtom1)
            labelButtom1.text="110/120"
            self.bottomConstraint!.constraint.activate()
            //self.bottomConstraint?.constraint.activate()
            labelButtom1.font=UIFont.systemFont(ofSize: 15)
            labelButtom1.snp.makeConstraints { (make) in
                make.top.equalTo(labelline1.snp.bottom).offset(0)
                make.width.equalTo(60)
                make.right.equalTo(view1.snp.right).offset(-3)
                make.height.equalTo(25)
               // self.bottomConstraint = make.bottom.equalTo(view1.snp.bottom)
                make.bottom.equalTo(view1.snp.bottom)
                
            }
        }
        
    }
    func sayClick1(btn:UIButton)  {
        c()
   
        print("点击啦1")
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            btn.isEnabled = false
            btn.setTitle("Start Recording", for: .normal)
        } else {
            startRecording()
            btn.setTitle("Stop Recording", for: .normal)
        }
        
    }
    func sayClick2(btn:UIButton)  {
        c()
        print("点击啦2")
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            btn.isEnabled = false
            btn.setTitle("Start Recording", for: .normal)
        } else {
            startRecording()
            btn.setTitle("Stop Recording", for: .normal)
        }
        
    }
    
    func c()  {
        var parameters:Parameters?
        if unResultType == 1{
            parameters = [
                "head":[
                    "platform":"app",
                    "timestamp":timeStamp,
                    "token":token1,
                ],
                "status":1,
                "eventID":self.idDoor,
                "resultType":unResultType,
                "sceneType":sceneType,
                "result":allTextView2.text
            ]
        }
        if unResultType==2{
            parameters = [
                "head":[
                    "platform":"app",
                    "timestamp":timeStamp,
                    "token":token1,
                ],
                "status":1,
                "eventID":self.idDoor,
                "resultType":unResultType,
                "sceneType":sceneType,
                "result":allTextView.text
            ]
        }
        print(parameters)
    }
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            sayBtn1.isEnabled = true
            sayBtn2.isEnabled = true
        } else {
            sayBtn1.isEnabled = false
            sayBtn2.isEnabled = false
        }
    }
    
    
    func startRecording() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.allTextView.text = result?.bestTranscription.formattedString
                self.allTextView2.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode?.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.sayBtn1.isEnabled = true
                self.sayBtn2.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode?.outputFormat(forBus: 0)
        inputNode?.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        allTextView.text = "请说普通话"
         allTextView2.text = "请说普通话"
    }
    
    
    func btn2Click(btn2:UIButton)  {
        unResultType=2
        self.bottomConstraint?.constraint.activate()
        if btn2.isSelected  == false {
            
            btn2.setImage(UIImage(named: "Check box"), for: .normal)
            btn1.setImage(UIImage(named: "checkbox_off_light"), for: .normal)
            
            allLabel2.isHidden=false
            allTextView2.isHidden=false
            labelline2.isHidden=false
            labelButtom2.isHidden=false
            sayBtn2.isHidden=false
            
            fourLabel.isHidden=true
            labelline1.isHidden=true
            labelButtom1.isHidden=true
            sayBtn1.isHidden=true
            allLabel.isHidden=true
            allTextView.isHidden=true
            countDownLabel.isHidden=true
            speciaBtn.isHidden=true
            noSpeciaBtn.isHidden=true
        }
    }
    
    //    func view1Click(tap2:UITapGestureRecognizer)  {
    //        self.allTextView2.resignFirstResponder()
    //        self.allTextView.resignFirstResponder()
    //    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.allTextView2.resignFirstResponder()
        self.allTextView.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func commonClick(commonbtn:UIButton)  {
        //        if btn2.isSelected  == true {
        //            print("非误报")
        //        }
        //        if btn2.isSelected  == true{
        //            print("误报")
        //        }
        loadData1()
    }
    
    func speciaClick(speciaBtn:UIButton)  {
        sceneType=1
        self.bottomConstraint?.constraint.activate()
        if speciaBtn.isSelected  == false {
            speciaBtn.setImage(UIImage(named: "radio_on_light"), for: .normal)
            noSpeciaBtn.setImage(UIImage(named: "radio_off_light"), for: .normal)
            
            allLabel.isHidden=false
            allTextView.isHidden=false
            countDownLabel.isHidden=false
            
            view1.addSubview(countDownLabel)
            countDownLabel.text="倒计时4个小时"
            countDownLabel.textColor=UIColor.black
            //  countDownLabel.layer.borderWidth = 1
            //  countDownLabel.layer.borderColor = UIColor.orange.cgColor
            //  countDownLabel.contentMode = .top
            countDownLabel.layer.masksToBounds = true;
            countDownLabel.textAlignment = .center
            countDownLabel.backgroundColor=UIColor.white
            countDownLabel.font=UIFont.systemFont(ofSize: 14)
            countDownLabel.snp.makeConstraints { (make) in
                make.width.equalTo(screenWidth-20)
                make.height.equalTo(55)
                make.left.equalTo(view1).offset(10)
                make.top.equalTo(view1.snp.bottom).offset(3)
            }
            let image1=UIImageView()
            countDownLabel.addSubview(image1)
            image1.image=UIImage(named: "提示.png")
            image1.snp.makeConstraints { (make) in
                make.left.equalTo(countDownLabel.snp.left).offset(10)
                make.height.width.equalTo(40)
                make.top.equalTo(countDownLabel).offset(8)
            }
            let xianView=UIView()
            countDownLabel.addSubview(xianView)
            xianView.backgroundColor=UIColor.yellow
            xianView.snp.makeConstraints { (make) in
                make.left.right.bottom.equalTo(countDownLabel)
                make.width.equalTo(countDownLabel)
                make.height.equalTo(1)
            }
        }
    }
    
    func noSpeciaClick(noSpeciaBtn:UIButton)  {
        sceneType=2
        self.bottomConstraint?.constraint.activate()
        if noSpeciaBtn.isSelected  == false {
            noSpeciaBtn.setImage(UIImage(named: "radio_on_light"), for: .normal)
            speciaBtn.setImage(UIImage(named: "radio_off_light"), for: .normal)
            countDownLabel.removeFromSuperview()
        }
    }
    
    func creatNav(){
        //选择控件
        let frame=CGRect(x: 0, y: navigationBarHeight-24, width: screenWidth, height: 95)
        segCtrl=KtcSegCtrl(frame: frame, titleArray: ["未处理","处理中","已处理"])
        
        segCtrl?.delegate=self
        segCtrl?.backgroundColor = UIColor.white
        view.addSubview(segCtrl!)
        
        let badgeLayer=CATextLayer.createTextLayer()
        segCtrl?.layer.addSublayer(badgeLayer)
        badgeLayer.frame=CGRect(x: screenWidth/3-20, y: 45, width: 18, height: 18)
        badgeLayer.cornerRadius=9
        badgeLayer.fontSize=12
        if  Int(doorRed) > 99  {
            badgeLayer.string="99+"
        }else{
            badgeLayer.string="\(doorRed)"
        }
       
        
        //        let badgeLayer2=CATextLayer.createTextLayer()
        //        segCtrl?.layer.addSublayer(badgeLayer2)
        //        badgeLayer2.frame=CGRect(x: screenWidth/3*2-20, y: 45, width: 18, height: 18)
        //        badgeLayer2.cornerRadius=9
        //        badgeLayer.fontSize=16
        //        badgeLayer2.string="3"
        
        //        let badgeLayer3=CATextLayer.createTextLayer()
        //        segCtrl?.layer.addSublayer(badgeLayer3)
        //        badgeLayer3.frame=CGRect(x: screenWidth-20, y: 45, width: 20, height: 20)
        //        badgeLayer3.cornerRadius=10
        //        badgeLayer3.string=""
    }
    
    
    func configUI2(){
        scrollView=UIScrollView()
        scrollView!.isPagingEnabled=true
        //设置代理
        scrollView?.delegate=self
        view.addSubview(scrollView!)
        
        //约束
        scrollView!.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(114+navigationBarHeight-44, 0, 0, 0))
        }
        
        //容器视图
        let containerView=UIView.createView()
        scrollView!.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView!)
            make.height.equalTo(scrollView!)
        }
        //添加子视图
        //1.firstView子视图
        firstView = UntreatedDoorView()
        containerView.addSubview(firstView!)
        firstView?.snp.makeConstraints({ (make) in
            make.top.bottom.left.equalTo(containerView)
            make.width.equalTo(screenWidth)
        })
        
        //2.secondView视图
        secondView = NowDoorView()
        
        containerView.addSubview(secondView!)
        secondView?.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(containerView)
            make.width.equalTo(screenWidth)
            make.left.equalTo((firstView?.snp.right)!)
        })
        //3.ThreeView视图
        ThreeView=CompleteDoorView()
        containerView.addSubview(ThreeView!)
        ThreeView?.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(containerView)
            make.width.equalTo(screenWidth)
            make.left.equalTo((secondView?.snp.right)!)
        })
        
        //修改容器视图大小
        containerView.snp.makeConstraints { (make) in
            make.right.equalTo(ThreeView!)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
//Mark: KtcSegCtrl代理

extension DoorNoCloseController:KtcSegCtrlDelegate{
    func segCtrl(segCtrl: KtcSegCtrl, didClickBtnIndex index: Int) {
        scrollView?.setContentOffset(CGPoint(x: CGFloat(index)*screenWidth, y: 0), animated: true)
        
        if segCtrl.selectIndex != 1{
            timer1?.invalidate()
             secondView?.tableView?.isHidden=false
            view1.removeFromSuperview()
            //scrollView?.contentOffset.y=114+navigationBarHeight-44
            allLabel2.isHidden=false
            allTextView2.isHidden=false
            allLabel.isHidden=true
            allTextView.isHidden=true
            countDownLabel.isHidden=true
            speciaBtn.isHidden=true
            noSpeciaBtn.isHidden=true
            commonBtn.removeFromSuperview()
            timeLabel.removeFromSuperview()
            addressLabel.removeFromSuperview()
            imageView1.removeFromSuperview()
        }
        if segCtrl.selectIndex == 0{
            firstView?.startRefreshData1()
        }
        
        if segCtrl.selectIndex == 2{
            self.ThreeView?.startRefreshData1()
        }
        
    }
}

//Mark: scrollView代理

extension DoorNoCloseController:UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index=scrollView.contentOffset.x/scrollView.bounds.size.width
        segCtrl?.selectIndex=Int(index)
        if segCtrl?.selectIndex != 1{
            timer1?.invalidate()
           // scrollView.contentOffset.y=114+navigationBarHeight-44
            secondView?.tableView?.isHidden=false
            view1.removeFromSuperview()
            allLabel2.isHidden=false
            allTextView2.isHidden=false
            allLabel.isHidden=true
            allTextView.isHidden=true
            countDownLabel.isHidden=true
            speciaBtn.isHidden=true
            noSpeciaBtn.isHidden=true
            commonBtn.removeFromSuperview()
            timeLabel.removeFromSuperview()
            addressLabel.removeFromSuperview()
            imageView1.removeFromSuperview()
        }
        if segCtrl?.selectIndex == 0{
            firstView?.startRefreshData1()
        }
        
        if segCtrl?.selectIndex == 2{
            self.ThreeView?.startRefreshData1()
        }
    }
}

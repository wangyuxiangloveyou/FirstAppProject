//
//  SmokeFeelingController.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/4.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire
import Speech

class SmokeFeelingController: UIViewController,UITextViewDelegate,UITextFieldDelegate, SFSpeechRecognizerDelegate {
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "zh_CN"))  //1
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    var  unResultType = 0
    var segCtrl:KtcSegCtrl?
     let sayBtn=UIButton()
    //滚动视图
    public var scrollView:UIScrollView?
    var firstView:SmokeFeelingView?
    var secondView:NowSmokeView?
    var ThreeView:CompleteSmokeView?
    var view1=UIView()
    var btn1=UIButton()
    var btn2=UIButton()
    var allLabel=UILabel()
    var allTextView=UITextView()
    let nameLabel=UITextView()
    var view2=UIView()
    var height=0
    let commonBtn=UIButton()
    let imageView1=UIImageView()
    let addressLabel=UILabel()
    var dataSource1:eventsModel?
    
   
    override func viewDidAppear(_ animated: Bool) {
        firstView?.startRefreshData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sayBtn.isEnabled = false  //2
        
        speechRecognizer?.delegate = self    //3
        
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
            self.sayBtn.isEnabled = isButtonEnabled
        }
        
        
        
        self.view.backgroundColor=UIColor.white
        self.title="烟感"
        view1.isUserInteractionEnabled = true
        view.isUserInteractionEnabled=true
        creatNav()
        IQKeyboardManager.sharedManager().enable = true
        configUI2()
        firstView?.untreatedSmokeCellClourse = {
            (dataSoure) in
            self.dataSource1=dataSoure as! eventsModel
            self.configUI1()
        }
        
        secondView?.nowCellclourse = {
            (dataSoure) in
            //self.scrollView?.contentOffset.x=(self.scrollView?.bounds.size.width)!
            self.configUI1()
        }
    }
    
//    func refreshWithDataSource(historyInfo:HistoryInfo)
//    {
//        self.historyInfo = historyInfo
//        //self.tableView?.reloadData()
//    }
    
    //烟感事件处理进度上报
    func loadData1()
    {
       
        let parameters: Parameters = [
            "head":[
                "platform":"app",
                "timestamp":timeStamp,
                "token":token1,
                "longitude":longitude,
                "latitude":latitude,
            ],
            "status":1,
            "eventID":id1,
            "resultType":unResultType,
            "result":allTextView.text
        ]
        print(parameters)
        Alamofire.request("http://47.75.190.168:5000/api/app/smokeDetectorProcessReport", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ (response)  in
           // print(token1)
            if let dic = response.result.value {
                print("烟感事件处理进度上报")
                let data : NSData! = try! JSONSerialization.data(withJSONObject: dic, options: []) as NSData?
                let json = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
                print("json: \(dic)")
                print(json)
            }
            else
            {
                print("dic: \(response)")
            }
            self.ThreeView?.startRefreshData()
        }
    }
    
    
   // @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if let scheme = URL.scheme{
            switch scheme {
            case "about" :
                showAlert(tagType: "about",
                          payload: (URL as NSURL).resourceSpecifier!.removingPercentEncoding!)
            case "feedback":
                showAlert(tagType: "feedback",
                          payload: (URL as NSURL).resourceSpecifier!.removingPercentEncoding!)
            default:
                print("这个是普通的url")
            }
        }
        return true
    }
    
    //显示消息
    func showAlert(tagType:String, payload:String){
        let alertController = UIAlertController(title: "检测到\(tagType)标签",
            message: payload, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func configUI1() {
        allTextView.isHidden=false
        self.segCtrl?.selectIndex=1
        self.scrollView?.contentOffset.x=(self.scrollView?.bounds.size.width)!
        secondView?.backgroundColor=UIColor(patternImage: UIImage(named: "mmexport1525609772323.jpg")!)
        secondView?.tableView?.isHidden=true
        let view1TapGesture = UITapGestureRecognizer(target: self, action: #selector(view1Click))
        view1.addGestureRecognizer(view1TapGesture)
        view1.backgroundColor=UIColor.white
        self.secondView?.addSubview(self.view1)
        self.view1.snp.makeConstraints { (make) in
            make.width.equalTo(screenWidth-6)
            make.height.equalTo(screenHeight-270)
            make.top.equalTo(self.secondView!).offset(0)
            make.left.equalTo(self.secondView!).offset(3)
        }
        view1.layer.shadowOpacity = 0.3
        view1.layer.shadowColor = UIColor.black.cgColor
        view1.layer.shadowOffset = CGSize(width: 0, height: 3)
        //view1.backgroundColor=UIColor.white
        
        self.view1.addSubview(imageView1)
        imageView1.image=UIImage(named: "居民楼-黑.png")
        imageView1.snp.makeConstraints { (make) in
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.left.equalTo(view1).offset(0)
            make.top.equalTo(view1.snp.top).offset(5)
        }
        
        self.view1.addSubview(addressLabel)
        addressLabel.text=self.dataSource1?.villageName
        addressLabel.textColor=UIColor.init(red: 0/255, green: 123/255, blue: 195/255, alpha: 1)
        addressLabel.snp.makeConstraints { (make) in
            make.width.equalTo(screenWidth/2)
            make.height.equalTo(30)
            make.left.equalTo(imageView1.snp.right).offset(0)
            make.top.equalTo(view1.snp.top).offset(5)
        }
        
        self.view1.addSubview(self.nameLabel)
//        for i in 0 ..< self.dataSource1?.people?.count{
//            if self.dataSource1?.people?[i].phone != ""{
//                nameLabel.text = self.dataSource1?.people?[i].name+self.dataSource1?.people?[i].phone
//            }
//        }
       // self.dataSource1?.people?.first?.phone
//      nameLabel.dataDetectorTypes = UIDataDetectorTypes.phoneNumber
        //nameLabel.text = self.dataSource1?.people?.first?.name
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        nameLabel.isEditable=false
        nameLabel.delegate=self
        if (self.dataSource1?.people?.count)!>0{
            for i in 0..<self.dataSource1!.people!.count{
                if self.dataSource1!.people![i].relation == 1{
                }
                self.nameLabel.text=self.nameLabel.text+self.dataSource1!.people![i].name!+"  "+"\(self.dataSource1!.people![i].phone!)\n "
            }
        }
//       self.nameLabel.text="户主：张玲玲     13648273948\n            陈晓成     17263746464\n            陈晓成     17263746464\n            王吉安     13648273948"
        // nameLabel.text="18701813730  18701813730"
//        if self.dataSource1?.people?.first?.relation == 1{
//            nameLabel.text=self.dataSource1?.people?.first?.name
//            print(self.dataSource1?.people?.first?.name)
//        }
        if self.dataSource1?.people?.first?.relation == 0 && (self.dataSource1?.people?.count)!>0{
            let formattor = NumberFormatter()
            formattor.numberStyle = .decimal
            let str = formattor.string(from: (self.dataSource1?.people?.first?.phone)!)
           // self.nameLabel.text=(self.dataSource1?.people?.first?.name)!  +  str! + "\n  18701813730"
            
            print((self.dataSource1?.people?.first?.name)!+str!)
        }
       
        self.nameLabel.snp.makeConstraints { (make) in
            make.width.equalTo(screenWidth-6)
            make.height.equalTo(23*(dataSource1?.people?.count)!)
            make.left.equalTo(view1).offset(0)
            make.top.equalTo(imageView1.snp.bottom).offset(0)
        }
        
        self.view1.addSubview(self.btn1)
        self.btn1.layer.borderWidth = 1
        self.btn1.layer.borderColor = UIColor.lightGray.cgColor
        self.btn1.setTitle("误报", for: .normal)
        
        self.btn1.addTarget(self, action: #selector(self.btn1Click), for: .touchUpInside)
        self.btn1.backgroundColor=UIColor.white
        self.btn1.setImage(UIImage(named: "checkbox_off_light"), for: .normal)
        
        self.btn1.setTitleColor(UIColor.black, for: .normal)
        self.btn1.snp.makeConstraints { (make) in
            make.width.equalTo(screenWidth/2-3)
            make.height.equalTo(60)
            make.left.equalTo(view1).offset(0)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(0)
        }
        
        self.view1.addSubview(self.btn2)
        self.btn2.setTitle("非误报", for: .normal)
        self.btn2.addTarget(self, action: #selector(self.btn2Click), for: .touchUpInside)
        self.btn2.backgroundColor=UIColor.white
        self.btn2.layer.borderWidth = 1
        self.btn2.layer.borderColor = UIColor.lightGray.cgColor
        self.btn2.setImage(UIImage(named: "Check box"), for: .normal)
        self.btn2.setTitleColor(UIColor.black, for: .normal)
        self.btn2.snp.makeConstraints { (make) in
            make.width.equalTo(screenWidth/2-3)
            make.height.equalTo(60)
            make.left.equalTo(self.btn1.snp.right).offset(0)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(0)
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
        commonBtn.setTitleColor(UIColor.white, for: .normal)
        commonBtn.snp.makeConstraints { (make) in
            make.width.equalTo(screenWidth)
            make.height.equalTo(58)
            make.left.right.bottom.equalTo(self.secondView!).offset(0)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.allTextView.resignFirstResponder()
        view1.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.allTextView.resignFirstResponder()
        view1.endEditing(true)
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        allTextView.deleteBackward()
    }
    func view1Click(tap2:UITapGestureRecognizer)  {
        
        self.allTextView.resignFirstResponder()
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
        badgeLayer.fontSize=12
        badgeLayer.cornerRadius=9
        if  Int(smokeRed) > 99  {
            badgeLayer.string="99+"
        }else{
            badgeLayer.string="\(smokeRed)"
        }
        
        
//        let badgeLayer2=CATextLayer.createTextLayer()
//        segCtrl?.layer.addSublayer(badgeLayer2)
//        badgeLayer2.frame=CGRect(x: screenWidth/3*2-20, y: 45, width: 18, height: 18)
//        badgeLayer2.cornerRadius=9
//        badgeLayer.fontSize=16
//        badgeLayer2.string="1"
    }
    
    func btn1Click(btn1:UIButton)  {
        unResultType=1
        print(unResultType)
        if btn1.isSelected  == false {
            btn1.setImage(UIImage(named: "Check box"), for: .normal)
            btn2.setImage(UIImage(named: "checkbox_off_light"), for: .normal)
            view1.addSubview(allLabel)
            allLabel.text="  具体内容"
            allLabel.textAlignment = .left
            allLabel.textColor=UIColor.lightGray
            allLabel.font=UIFont.systemFont(ofSize: 15)
            allLabel.backgroundColor=UIColor.white
            allLabel.snp.makeConstraints { (make) in
                make.width.equalTo(screenWidth-6)
                make.height.equalTo(20)
                make.left.equalTo(view1).offset(0)
                make.top.equalTo(btn1.snp.bottom).offset(0)
            }
            
            view1.addSubview(allTextView)
            allTextView.placeholderText="厨房烧菜烟雾"
            //allTextView.
            allTextView.textColor=UIColor.black
            //  allTextView.layer.borderWidth = 1
            //  allTextView.layer.borderColor = UIColor.blue.cgColor
            allTextView.textAlignment = .left
            allTextView.font=UIFont.systemFont(ofSize: 20)
            allTextView.snp.makeConstraints { (make) in
                make.height.equalTo(screenHeight/5)
                make.left.equalTo(view1).offset(0)
                make.right.equalTo(view1).offset(0)
                make.top.equalTo(allLabel.snp.bottom).offset(-3)
            }
            
           
            view1.addSubview(sayBtn)
            sayBtn.setImage(UIImage(named: "Voice.png"), for: .normal)
            sayBtn.addTarget(self, action: #selector(sayClick), for: .touchDown)
            sayBtn.snp.makeConstraints { (make) in
                make.left.equalTo(allTextView.snp.right).offset(-30)
                make.width.equalTo(24)
                make.bottom.equalTo(allTextView)
                make.height.equalTo(30)
            }
            
            let labelline2=UIView()
            view1.addSubview(labelline2)
            labelline2.backgroundColor=UIColor.init(red: 0/255, green: 150/255, blue: 136/255, alpha: 1)
            labelline2.snp.makeConstraints { (make) in
                make.top.equalTo(allTextView.snp.bottom).offset(0)
                make.width.equalTo(screenWidth-6)
                make.left.equalTo(view1).offset(0)
                make.height.equalTo(1)
            }
            
            let labelButtom=UILabel()
            view1.addSubview(labelButtom)
            labelButtom.text="110/120"
            labelButtom.font=UIFont.systemFont(ofSize: 15)
            labelButtom.snp.makeConstraints { (make) in
                make.top.equalTo(labelline2.snp.bottom).offset(0)
                make.width.equalTo(60)
                make.right.equalTo(view1.snp.right).offset(-3)
                make.height.equalTo(30)
            }
        }
    }
    
    func sayClick(btn:UIButton)  {
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
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            sayBtn.isEnabled = true
        } else {
            sayBtn.isEnabled = false
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
                
                self.allTextView.text = (result?.bestTranscription.formattedString)!
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode?.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.sayBtn.isEnabled = true
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
        
        allTextView.text = "请讲普通话!"
    }
    
    
    func btn2Click(btn2:UIButton)  {
        unResultType=2
        print(unResultType)
        if btn2.isSelected  == false {
            btn2.setImage(UIImage(named: "Check box"), for: .normal)
            btn1.setImage(UIImage(named: "checkbox_off_light"), for: .normal)
            allLabel.removeFromSuperview()
            allTextView.removeFromSuperview()
        }
    }
    
    func commonClick(commonbtn:UIButton)  {
        let parameters: Parameters = [
            "head":[
                "platform":"app",
                "timestamp":timeStamp,
                "token":token1,
            ],
            "status":"0",
            "eventID":id1,
            "resultType":unResultType,
            "result":allTextView.text
        ]
//
       print(parameters)
        print(unResultType)
        commonBtn.removeFromSuperview()
        let vc = pictureController()
        number1=3
        self.navigationController?.pushViewController(vc, animated: true)
        view1.removeFromSuperview()
        self.segCtrl?.selectIndex=2
        self.scrollView?.contentOffset.x=2*(self.scrollView?.bounds.size.width)!
        loadData1()
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
        firstView = SmokeFeelingView()
        containerView.addSubview(firstView!)
        firstView?.snp.makeConstraints({ (make) in
            make.top.equalTo(containerView).offset(0)
            make.bottom.left.equalTo(containerView)
            make.width.equalTo(screenWidth)
        })
        
        //2.secondView视图
        secondView = NowSmokeView()
        containerView.addSubview(secondView!)
        secondView?.snp.makeConstraints({ (make) in
            make.top.equalTo(containerView).offset(0)
            make.bottom.equalTo(containerView)
            make.width.equalTo(screenWidth)
            make.left.equalTo((firstView?.snp.right)!)
        })
        //3.ThreeView视图
        ThreeView=CompleteSmokeView()
        containerView.addSubview(ThreeView!)
        
        ThreeView?.snp.makeConstraints({ (make) in
            make.top.equalTo(containerView).offset(0)
            make.bottom.equalTo(containerView)
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
extension SmokeFeelingController:KtcSegCtrlDelegate{
    func segCtrl(segCtrl: KtcSegCtrl, didClickBtnIndex index: Int) {
        scrollView?.setContentOffset(CGPoint(x: CGFloat(index)*screenWidth, y: 0), animated: true)
        if segCtrl.selectIndex == 0{
             firstView?.startRefreshData()
            self.nameLabel.removeFromSuperview()
            commonBtn.removeFromSuperview()
            self.view1.removeFromSuperview()
           self.allTextView.resignFirstResponder()
            allTextView.isHidden=true
            allLabel.removeFromSuperview()
        }
        if segCtrl.selectIndex == 2{
            ThreeView?.startRefreshData()
        }
       
        if segCtrl.selectIndex != 1{
            secondView?.tableView?.isHidden=false
            self.nameLabel.removeFromSuperview()
            commonBtn.removeFromSuperview()
            self.view1.removeFromSuperview()
            self.allTextView.resignFirstResponder()
            allTextView.isHidden=true
            allLabel.removeFromSuperview()
        }
        
    }
}


extension SmokeFeelingController:UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index=scrollView.contentOffset.x/scrollView.bounds.size.width
        segCtrl?.selectIndex=Int(index)
        if segCtrl?.selectIndex == 0{
           firstView?.startRefreshData()
        }
        
        if segCtrl?.selectIndex == 2{
            self.ThreeView?.startRefreshData()
        }
        
        if segCtrl?.selectIndex != 1{
            secondView?.tableView?.isHidden=false
            self.nameLabel.removeFromSuperview()
            self.view1.removeFromSuperview()
            commonBtn.removeFromSuperview()
            allTextView.isHidden=true
            allLabel.removeFromSuperview()
        }
        
    }
}




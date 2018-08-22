//
//  NowDoorView.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/4.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit
import SnapKit
public var leftTime:Int = 60
public var leftTimMin:Int = 4
public var timeSecod:String=""
public var timer :Timer!
public  var dataMutable:Dictionary<String,Double> = [:];

class NowDoorView: UIView {
    var btn : UIButton!
    var label1=UILabel()
    
    var tableView:UITableView?
   // static var timer = NowDoorView()
    var time=""
    var tag2=0
    var doorCellClourseTwo:OperationSelected?
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        self.backgroundColor=UIColor.yellow
        let ud = UserDefaults.standard
        let firstLaunch:Bool = ud.bool(forKey: "Launched");
        if(!firstLaunch){
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tickDown), userInfo: nil, repeats: true)
        }else{
            ud.setValue(true, forKey: "Launched")
            ud.synchronize()
        }
        
        print(dataMutable)
        
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
//        time=(String(format: "00:%02d:%02d", Min, Sec))
        return String(format: "00:%02d:%02d", Min, Sec)
    }
    
    func configUI()  {
        //创建表格试图
        tableView=UITableView(frame: CGRect(x: 0, y: 0, width:screenWidth , height: screenHeight-106), style: .plain)
        tableView?.dataSource=self
        tableView?.delegate=self
//        tableView?.backgroundColor=UIColor(patternImage: UIImage(named: "mmexport1525609772323.jpg")!)
        //创建一个用于显示背景图片的imageView
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "mmexport1525609772323.jpg")
        backgroundImage.contentMode = .scaleAspectFill //等比缩放填充（图片可能有部分显示不全）
        //将背景图片imageView插入到当前视图中
        tableView?.insertSubview(backgroundImage, at: 0)
        
        self.addSubview(tableView!)
        self.tableView?.isScrollEnabled = true
        self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        //tableView?.separatorStyle = UITableViewCellSeparatorStyle.singleLineEtched
        //tableView?.allowsSelection = false
        tableView?.register(UINib(nibName: "NowDoorCell",bundle: nil), forCellReuseIdentifier: "NowDoorCellId")
        tableView?.reloadData()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tickDown()
    {
        
        for key:String in dataMutable.keys
        {
           // print(dataMutable[key])
          
            if dataMutable[key]! > 0{
            dataMutable[key]=dataMutable[key]!-1
            }
            
            for cell1  in tableView!.visibleCells as![NowDoorCell]
            {
                if cell1.eventID == key && dataMutable[key]! >= 0
                {
                    let localTime = getFormatPlayTime(secounds: dataMutable[key]!)
                    cell1.RedLabel.text = "倒计时 " + "\(localTime)"
                }
                if dataMutable[key]! == 0 && cell1.eventID == key{
                     cell1.RedLabel.text = "倒计时 :00:00:00"
                }
            }
        }
    }
}

extension NowDoorView:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArry1.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(dataArry1.count)
        let cell:NowDoorCell = tableView.dequeueReusableCell(withIdentifier: "NowDoorCellId", for: indexPath as IndexPath) as! NowDoorCell
        let model:UntreatedDoorEventsModel=dataArry1[indexPath.row]as! UntreatedDoorEventsModel
       
        cell.FristImageView.image=UIImage(named: "居民楼-黑.png")
        cell.AdressLabel.textColor=UIColor.init(red: 0/255, green: 123/255, blue: 195/255, alpha: 1)
        let str = model.villageName!+"-"+"\(model.buildingNo!)"+"栋"
        let moneyTitle = NSMutableAttributedString.init(string:str)
        moneyTitle.addAttribute(NSForegroundColorAttributeName, value:UIColor.red, range:NSRange.init(location:model.villageName!.count+1, length: "\(model.buildingNo!)".count))
        moneyTitle.addAttribute(NSFontAttributeName, value:UIFont.systemFont(ofSize:17), range:NSRange.init(location:model.villageName!.count+1, length: "\(model.buildingNo!)".count))
        cell.AdressLabel.attributedText = moneyTitle
        cell.TimeLabel.text = model.createTime
        cell.eventID = model.eventID!;
        
        cell.RedLabel.textColor=UIColor.red

        
        cell.HandleButton.setTitle("待处理", for: .normal)
        cell.HandleButton.backgroundColor=UIColor.init(red: 76/255, green: 162/255, blue: 255/255, alpha: 1)
        cell.HandleButton.tintColor=UIColor.white
        cell.doorClourse = {
            ()in
            if self.doorCellClourseTwo != nil {
                let index = cell.RedLabel.text!.index(cell.RedLabel.text!.startIndex, offsetBy: 4)//获取字符d的索引
                let result = cell.RedLabel.text!.substring(from: index)
                timeSecod=result
                let dataSoureDoorNow:UntreatedDoorEventsModel=dataArry1[indexPath.row]as! UntreatedDoorEventsModel
                self.doorCellClourseTwo!(dataSoureDoorNow)
                for key:String in dataMutable.keys
                {
                for cell1  in tableView.visibleCells as![NowDoorCell]
                {
                    if cell1.eventID == key && dataMutable[key]! >= 0
                    {
                       // timeSecod =  dataMutable[key]!
                    }
                }
                }
               
                
                
            }
        }
        cell.selectionStyle = .none
        return cell
        
    }
    
}


//
//  CompleteDoorView.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/4.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//


import UIKit
import Alamofire
import MBProgressHUD

class CompleteDoorView: UIView {
    
    var tableView:UITableView?
    var dataArray:[AnyObject]=[]
    override init(frame: CGRect) {
        super.init(frame: frame)
        //configUI()
        loadData1()
       //self.backgroundColor=UIColor.white
    //self.backgroundColor=UIColor(patternImage: UIImage(named: "mmexport1525609772323.jpg")!)
    }
    
    func configUI()  {
        //创建表格试图
        tableView=UITableView(frame: CGRect(x: 0, y: 0, width:screenWidth , height: screenHeight-106), style: .plain)
        tableView?.dataSource=self
        tableView?.delegate=self
         tableView?.backgroundColor=UIColor(patternImage: UIImage(named: "mmexport1525609772323.jpg")!)
        self.addSubview(tableView!)
        self.tableView?.isScrollEnabled = true
        self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        //tableView?.separatorStyle = UITableViewCellSeparatorStyle.singleLineEtched
        //tableView?.allowsSelection = false
        tableView?.register(UINib(nibName: "CompleteDoorCell",bundle: nil), forCellReuseIdentifier: "CompleteDoorCellId")
    }
    
    
    //获取门禁已完成事件列表
    func loadData1()
    {
        let parameters: Parameters = [
            "head":[
                "platform":"app",
                "timestamp":timeStamp,
                "token":token1,
            ],
            "villageIDs":villageArray,
            "status":2,
            "pageNum":1,
            "pageSize":5,
            ]
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.label.text = "加载中"
        //背景渐变效果
        hud.alpha = 0.8
        hud.dimBackground = true
        Alamofire.request("http://47.75.190.168:5000/api/app/getAccessEventList", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ (response)  in
            hud.hide(animated: true)
            print("获取门禁已完成事件列表")
            print(villageArray)
            if let dic = response.result.value {
                let data : NSData! = try? JSONSerialization.data(withJSONObject: dic, options: []) as NSData!
                let json = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
                print("json: \(dic)")
                print(json)
                let model1:CompleteDoorModel = CompleteDoorModel.mj_object(withKeyValues: dic)
                if model1.responseStatus?.resultCode == 0 && model1.events != nil{
                self.dataArray=model1.events!
                }
            }
            else
            {
                print("dic: \(response)")
            }
            self.configUI()
            self.tableView?.reloadData()
        }
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}



extension CompleteDoorView:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CompleteDoorCell = tableView.dequeueReusableCell(withIdentifier: "CompleteDoorCellId", for: indexPath as IndexPath) as! CompleteDoorCell
         let model:CompleteDoorEventsModel=self.dataArray[indexPath.row] as! CompleteDoorEventsModel
        cell.FristImageView.image=UIImage(named: "居民楼-黑.png")
        cell.AdressLabel.textColor=UIColor.init(red: 0/255, green: 123/255, blue: 195/255, alpha: 1)
         let str = model.villageName!+"-"+"\(model.buildingNo!)"+"栋"
        let moneyTitle = NSMutableAttributedString.init(string:str)
        moneyTitle.addAttribute(NSForegroundColorAttributeName, value:UIColor.red, range:NSRange.init(location:model.villageName!.count+1, length: "\(model.buildingNo!)".count))
        moneyTitle.addAttribute(NSFontAttributeName, value:UIFont.systemFont(ofSize:20), range:NSRange.init(location:model.villageName!.count+1, length: "\(model.buildingNo!)".count))
        cell.AdressLabel.attributedText = moneyTitle
       
        cell.RightLabel.text="人为"
        cell.RightLabel.textAlignment = .center
        cell.RightLabel.backgroundColor=UIColor.init(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        
       
        cell.TimeLabel.text=model.createTime
        
        cell.OneLabel.text="特殊情况"
        cell.OneLabel.textAlignment = .center
        cell.OneLabel.backgroundColor=UIColor.init(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        
        cell.TwoLabel.text="处置超时"
         cell.TwoLabel.textAlignment = .center
        cell.TwoLabel.backgroundColor=UIColor.init(red: 190/255, green: 223/255, blue: 219/255, alpha: 1)
      cell.selectionStyle = .none
        return cell
        
    }
}


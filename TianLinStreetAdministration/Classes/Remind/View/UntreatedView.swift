//
//  UntreatedView.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/22.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit
import Alamofire

class UntreatedView: UIView {
    var cellClourseONE:OperationSelected?
    var cellClourseTWO:OperationSelected?
    var cellClourseTHREE:OperationSelected?
    var tableView:UITableView?
    var dataArray:[UnDrugAddictsGroupsModel]=[]
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadData1()
        //hloadData2()
        //loadData3()
        self.backgroundColor=UIColor.white
    }
    
    
    func loadData1()
    {
        let parameters: Parameters = [
            "head":[
                "platform":"app",
                "timestamp":timeStamp,
                "token":token1,
            ]
        ]
        
        Alamofire.request("http://47.75.190.168:5000/api/app/getAlarmModels", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ (response)  in
            
            if let dic = response.result.value {
                let data : NSData! = try! JSONSerialization.data(withJSONObject: dic, options: []) as NSData?
                let json = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
                print(json)
                print("获取报警模型")
                print("dic: \(dic)")
                if (json?.length)! >= 60{
                    let model1:UnDrugAddictsModel = UnDrugAddictsModel.mj_object(withKeyValues: dic)
                    self.dataArray=model1.groups!
                    print(self.dataArray)
                }
            }
            else
            {
                print("dic: \(response)")
            }
            //            let vc=CompleteView()
            //            vc.refershData(dataArray:self.dataArray)
            self.configUI()
            self.tableView?.reloadData()
        }
    }
    
    func loadData3()
    {
        let parameters: Parameters = [
            "head":[
                "platform":"app",
                "timestamp":timeStamp,
                "token":token1,
                "longitude":longitude,
                "latitude":latitude,
            ],
            "alarmID": "5c83b8dfd8ab492390bcb1469f2536c4",
            "resultType": 1,
            ]
        
        print("上报信息")
        print(parameters)
       // print(1111111111111111)
        
        Alamofire.request("http://47.75.190.168:5000/api/app/alarmProcessReport", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ (response)  in
            
            if let dic = response.result.value {
                let data : NSData! = try! JSONSerialization.data(withJSONObject: dic, options: []) as NSData?
                let json = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
                
                print(json)
                //print("获取报警信息")
                print("dic: \(dic)")
                if (json?.length)! >= 60{
                    let model1:UnDrugAddictsModel = UnDrugAddictsModel.mj_object(withKeyValues: dic)
                    self.dataArray=model1.groups!
                    print(self.dataArray)
                }
            }
            else
            {
                print("dic: \(response)")
            }
            //  let vc=CompleteView()
            //  vc.refershData(dataArray:self.dataArray)
            self.configUI()
            self.tableView?.reloadData()
        }
    }
    
    func configUI()  {
        //创建表格试图
        tableView=UITableView(frame: CGRect(x: 0, y: 0, width:screenWidth , height: screenHeight-100), style: .plain)
        tableView?.dataSource=self
        tableView?.delegate=self
        tableView?.backgroundColor=UIColor(patternImage: UIImage(named: "mmexport1525609772323.jpg")!)
        self.addSubview(tableView!)
        self.tableView?.isScrollEnabled = false
        self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        //tableView?.separatorStyle = UITableViewCellSeparatorStyle.singleLineEtched
        //tableView?.allowsSelection = false
        //设置分割线颜色
        // self.tableView?.separatorColor = UIColor.white
        //self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView?.register(UINib(nibName: "UntreatedViewCell",bundle: nil), forCellReuseIdentifier: "UntreatedViewCellId")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



extension UntreatedView:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight/10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UntreatedViewCell = tableView.dequeueReusableCell(withIdentifier: "UntreatedViewCellId", for: indexPath as IndexPath) as! UntreatedViewCell
        
        let model:UnDrugAddictsGroupsModel=self.dataArray[indexPath.row] as! UnDrugAddictsGroupsModel
        cell.NameLabel.text=model.groupName
        cell.NumLabel.text = "\(model.unsolveNum!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.cellClourseONE != nil{
            let data1=self.dataArray[indexPath.row].models
            unDrugDataArray1=data1!
           //unDrugDataArray1=data1
           print(data1![0].modelName) 
            print(data1)
            print(unDrugDataArray1)
            self.cellClourseONE!(data1 as AnyObject)
        }
       
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
}

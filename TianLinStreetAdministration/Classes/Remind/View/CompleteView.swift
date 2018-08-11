//
//  CompleteView.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/22.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit
import Alamofire

class CompleteView: UIView {
    var cellClourseONE:IngreJumpClosure?
    var cellClourseTWO:IngreJumpClosure?
    var cellClourseTHREE:IngreJumpClosure?
    var tableView:UITableView?
     var dataArray:[UnDrugAddictsGroupsModel]=[]
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadData1()
        self.backgroundColor=UIColor.white
    }
    
//    func refershData(dataArray:[UnDrugAddictsGroupsModel]){
//         self.dataArray = dataArray
//        print(self.dataArray.count)
//        self.configUI()
//        self.tableView?.reloadData()
//
//    }
    
    func loadData1()
    {
        let parameters: Parameters = [
            "head":[
                "platform":"app",
                "timestamp":timeStamp,
                "token":token1,
            ]
        ]
        print(parameters)
       // print("获取报警模型")
        Alamofire.request("http://47.75.190.168:5000/api/app/getAlarmModels", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ (response)  in
            print(token1)
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
        //        self.tableView?.separatorColor = UIColor.white
        //        self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView?.register(UINib(nibName: "UntreatedViewCell",bundle: nil), forCellReuseIdentifier: "UntreatedViewCellId")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



extension CompleteView:UITableViewDelegate,UITableViewDataSource
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
        print(model.groupName)
        cell.imageView1.isHidden=true
        cell.rightLabel.isHidden=false
        cell.NameLabel.text=model.groupName
        cell.NumLabel.text = ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.cellClourseONE != nil{
            let data1=self.dataArray[indexPath.row].models
            unDrugDataArray1=data1!
            self.cellClourseONE!()
        }
        
        //        if indexPath.row == 0 {
        //            if self.cellClourseONE != nil{
        //
        //                let data1=self.dataArray[indexPath.row].models
        //                self.cellClourseONE!(data1 as AnyObject)
        //            }
        //        }
        //
        //        if indexPath.row == 1{
        //            if self.cellClourseTWO != nil{
        //            let data2=self.dataArray[indexPath.row].models
        //                self.cellClourseTWO!(data2 as AnyObject)
        //            }
        //        }
        //
        //        if indexPath.row == 2 {
        //            if self.cellClourseTHREE != nil{
        //                 let data3=self.dataArray[indexPath.row].models
        //                self.cellClourseTHREE!(data3 as AnyObject)
        //            }
        //        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
}

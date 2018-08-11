//
//  ComDrugAddictsView.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/22.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit
import Alamofire
public var name2=0
class ComDrugAddictsView: UIView {
    // var dataArray:[UnDrugAddictsGroupsModel]=[]
    var cellClourseONE:IngreJumpClosure?
    var cellClourseTWO:IngreJumpClosure?
    var cellClourseTHREE:IngreJumpClosure?
    var tableView:UITableView?
    
    //var dataArray=["每天访客超过三次","每天频繁进出6次","连续3天无进出记录"]
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor=UIColor.white
        configUI()
        
        
        
    }
    
    
    //        func refershData(dataArray:[modelsModel]){
    //            let data1=dataArray
    //            self.dataArray1.append(data1 as AnyObject)
    //            print(self.dataArray1.count)
    //             print(self.dataArray1)
    //            self.tableView?.reloadData()
    //        }
    
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
        // self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView?.register(UINib(nibName: "ComDrugAddictsViewCell",bundle: nil), forCellReuseIdentifier: "ComDrugAddictsViewCellId")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ComDrugAddictsView:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(unDrugDataArray1.count)
        return unDrugDataArray1.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight/10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ComDrugAddictsViewCell = tableView.dequeueReusableCell(withIdentifier: "ComDrugAddictsViewCellId", for: indexPath as IndexPath) as! ComDrugAddictsViewCell
        
        let model:modelsModel=unDrugDataArray1[indexPath.row] as! modelsModel
        cell.nameLabel.text=model.modelName
        //cell.numLabel.text = model.unsolveNum
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.cellClourseONE != nil{
            let model:modelsModel=unDrugDataArray1[indexPath.row] as! modelsModel
            name1=model.modelID!
            name2=1
            self.cellClourseONE!()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
}


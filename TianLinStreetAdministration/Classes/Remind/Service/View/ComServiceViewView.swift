

//
//  ComServiceViewView.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/7/16.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit

class ComServiceViewView: UIView {
    var cellClourseONE:IngreJumpClosure?
    var cellClourseTWO:IngreJumpClosure?
    var cellClourseTHREE:IngreJumpClosure?
    var tableView:UITableView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        self.backgroundColor=UIColor.white
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
        tableView?.allowsSelection = false
        //设置分割线颜色
        //        self.tableView?.separatorColor = UIColor.white
        //        self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView?.register(UINib(nibName: "ComServiceViewCell",bundle: nil), forCellReuseIdentifier: "ComServiceViewCellId")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



extension ComServiceViewView:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight/10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ComServiceViewCell = tableView.dequeueReusableCell(withIdentifier: "ComServiceViewCellId", for: indexPath as IndexPath) as! ComServiceViewCell
        if indexPath.row == 0{
            cell.nameLabel.text="80岁以上独居老人两天无出行记录无访客"
            cell.numLabel.text = "1"
            
            
        }
        if indexPath.row == 1{
            cell.nameLabel.text = "60岁以上有需求老人两天无出行记录无访客"
            cell.numLabel.text = "2"
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
}



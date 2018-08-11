//
//  NowInspectView.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/4.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit

class NowInspectView: UIView {

    var tableView:UITableView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        //self.backgroundColor=UIColor.white
    }
    
    func configUI()  {
        //创建表格试图
         tableView=UITableView(frame: CGRect(x: 0, y: navigationBarHeight-44, width:screenWidth , height: screenHeight+navigationBarHeight-160), style: .plain)
        tableView?.dataSource=self
        tableView?.delegate=self
         tableView?.backgroundColor=UIColor(patternImage: UIImage(named: "mmexport1525609772323.jpg")!)
        self.addSubview(tableView!)
        self.tableView?.isScrollEnabled = true
        self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        //tableView?.separatorStyle = UITableViewCellSeparatorStyle.singleLineEtched
        tableView?.allowsSelection = false
        tableView?.register(UINib(nibName: "NowInspectCell",bundle: nil), forCellReuseIdentifier: "NowInspectCellId")
    }
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}



extension NowInspectView:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:NowInspectCell = tableView.dequeueReusableCell(withIdentifier: "NowInspectCellId", for: indexPath as IndexPath) as! NowInspectCell
     
        cell.FirstImageView.image=UIImage(named: "居民楼-黑.png")
        
        cell.AdressLabel.text="田林十二村"
        cell.AdressLabel.textColor=UIColor.init(red: 0/255, green: 123/255, blue: 195/255, alpha: 1)
        cell.TimeLabel.text="2018-02-19 13:22:34"
        cell.NameLabel.text="监控摄像机"
        
        cell.NumberLabel.text="31827384753472038475"
        cell.ErrorLabel.text = "已接单"
        cell.ErrorLabel.textAlignment = .center
        cell.ErrorLabel.backgroundColor=UIColor.init(red: 76/255, green: 162/255, blue: 255/255, alpha: 1)
        cell.ErrorLabel.textColor=UIColor.white
        
//        cell.seconedTimeLabel.numberOfLines=0
//        cell.seconedTimeLabel.text="02-19 10:23:43\n  厂家已接单\n  预计2/20日9-11点派人查看\n\n02-20 10:23:43\n  设备故障已修复"
       cell.selectionStyle = .none
        return cell
        
    }
}

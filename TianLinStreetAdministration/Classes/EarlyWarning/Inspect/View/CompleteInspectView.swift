//
//  CompleteInspectView.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/4.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit

class CompleteInspectView: UIView {

    var tableView:UITableView?
    var repairCellClourse:IngreJumpClosure?
    var remarksCellClourse:IngreJumpClosure?
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
        self.addSubview(tableView!)
         tableView?.backgroundColor=UIColor(patternImage: UIImage(named: "mmexport1525609772323.jpg")!)
        self.tableView?.isScrollEnabled = true
        self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        //tableView?.separatorStyle = UITableViewCellSeparatorStyle.singleLineEtched
        //tableView?.allowsSelection = false
        tableView?.register(UINib(nibName: "CompleteInspectCell",bundle: nil), forCellReuseIdentifier: "CompleteInspectCellId")
    }
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}



extension CompleteInspectView:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CompleteInspectCell = tableView.dequeueReusableCell(withIdentifier: "CompleteInspectCellId", for: indexPath as IndexPath) as! CompleteInspectCell
        cell.FirstImageView.image=UIImage(named: "居民楼-黑.png")
        
        cell.AdressLabel.text="田林十二村"
        cell.AdressLabel.textColor=UIColor.init(red: 0/255, green: 123/255, blue: 195/255, alpha: 1)
        
        cell.NameLabel.text="监控摄像机"
        
        cell.NumberLabel.text="31827384753472038475"
        
        cell.TimeLabel.text="2018-02-19 13:22:34"
        cell.TimeLabel.textAlignment = .left
        cell.repairButton.setTitle("已修复", for: .normal)
        cell.repairButton.titleLabel?.textAlignment = .center
        cell.repairButton.backgroundColor=UIColor.init(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        cell.repairButton.tintColor=UIColor.black
    
        cell.remarksButton.setTitle("备注", for: .normal)
        cell.remarksButton.titleLabel?.textAlignment = .center
        cell.remarksButton.backgroundColor=UIColor.init(red: 237/255, green: 224/255, blue: 204/255, alpha: 1)
        cell.remarksButton.tintColor=UIColor.black
        cell.repairClourse = {
            ()in
            if self.repairCellClourse != nil {
                self.repairCellClourse!()
            }
        }
        
        cell.remarksClourse = {
            ()in
            if self.remarksCellClourse != nil {
                self.remarksCellClourse!()
            }
        }
        cell.selectionStyle = .none
        return cell
        
    }
}

//
//  ServiceViewDetailController.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/7/16.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit
import SnapKit

class ServiceViewDetailController: UIViewController {
    var tableView:UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="为老服务"
        configUI()
    }
    
    func configUI(){
        //创建表格试图
        tableView=UITableView(frame: CGRect(x: 0, y:40, width:screenWidth , height: screenHeight-40), style: .plain)
        tableView?.dataSource=self
        tableView?.delegate=self
        tableView?.backgroundColor=UIColor(patternImage: UIImage(named: "mmexport1525609772323.jpg")!)
        view.addSubview(tableView!)
        self.tableView?.isScrollEnabled = false
        self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        //tableView?.separatorStyle = UITableViewCellSeparatorStyle.singleLineEtched
        //tableView?.allowsSelection = false
        //设置分割线颜色
        // self.tableView?.separatorColor = UIColor.white
        //  self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView?.register(UINib(nibName: "DrugAddictsDetailsCell",bundle: nil), forCellReuseIdentifier: "DrugAddictsDetailsCellId")
        tableView?.register(UINib(nibName: "TitleTableViewCell",bundle: nil), forCellReuseIdentifier: "TitleTableViewCellId")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ServiceViewDetailController:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 35
        }
        return 85
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell:TitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCellId", for: indexPath as IndexPath) as! TitleTableViewCell
            cell.numberLabel.text=name1
            cell.timeLabel.text="04-09"
            return cell
        }
        
        if indexPath.row == 1{
            let cell:DrugAddictsDetailsCell = tableView.dequeueReusableCell(withIdentifier: "DrugAddictsDetailsCellId", for: indexPath as IndexPath) as! DrugAddictsDetailsCell
            cell.nameLabel.font=UIFont.systemFont(ofSize: 12)
            cell.nameLabel.textColor=UIColor.init(red: 0/255, green: 123/255, blue: 195/255, alpha: 1)
            let str = "田林十二村-4栋-202"
            let moneyTitle = NSMutableAttributedString.init(string:str)
            moneyTitle.addAttribute(NSForegroundColorAttributeName, value:UIColor.red, range:NSRange.init(location:6, length: 1))
            moneyTitle.addAttribute(NSForegroundColorAttributeName, value:UIColor.red, range:NSRange.init(location:9, length: 3))
            moneyTitle.addAttribute(NSFontAttributeName, value:UIFont.systemFont(ofSize:18), range:NSRange.init(location:6, length: 1))
            moneyTitle.addAttribute(NSFontAttributeName, value:UIFont.systemFont(ofSize:18), range:NSRange.init(location:9, length: 3))
            cell.nameLabel.attributedText = moneyTitle
            cell.peopleLabel.text="徐健坤"
            cell.timeLabel.text="记录访客:   09:23:23   12:23:24   16:23:09\n                  20:45:23"
            return cell
        }
        if indexPath.row == 2{
            let cell:DrugAddictsDetailsCell = tableView.dequeueReusableCell(withIdentifier: "DrugAddictsDetailsCellId", for: indexPath as IndexPath) as! DrugAddictsDetailsCell
            cell.nameLabel.font=UIFont.systemFont(ofSize: 12)
            cell.nameLabel.textColor=UIColor.init(red: 0/255, green: 123/255, blue: 195/255, alpha: 1)
            let str = "田林十二村-4栋-202"
            let moneyTitle = NSMutableAttributedString.init(string:str)
            moneyTitle.addAttribute(NSForegroundColorAttributeName, value:UIColor.red, range:NSRange.init(location:6, length: 1))
            moneyTitle.addAttribute(NSForegroundColorAttributeName, value:UIColor.red, range:NSRange.init(location:9, length: 3))
            moneyTitle.addAttribute(NSFontAttributeName, value:UIFont.systemFont(ofSize:18), range:NSRange.init(location:6, length: 1))
            moneyTitle.addAttribute(NSFontAttributeName, value:UIFont.systemFont(ofSize:18), range:NSRange.init(location:9, length: 3))
            cell.nameLabel.attributedText = moneyTitle
            cell.peopleLabel.text="徐健坤"
            cell.timeLabel.text="记录访客:   09:23:23   12:23:24   16:23:09\n                  20:45:23"
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        
        if indexPath.row == 0 {
            return false
        }else{
            return true
        }
    }
    
  
    //返回每一个行对应的事件按钮
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath)
        -> [UITableViewRowAction]? {
            
            //创建“更多”事件按钮
            let more = UITableViewRowAction(style: .normal, title: "更多") {
                action, index in
                // UIAlertController.showAlert(message: "点击了“更多”按钮")
                let cell:DrugAddictsDetailsCell = tableView.dequeueReusableCell(withIdentifier: "DrugAddictsDetailsCellId", for: indexPath as IndexPath) as! DrugAddictsDetailsCell
                cell.suspiciousLabel.text="可疑"
                cell.suspiciousLabel.backgroundColor=UIColor.init(red: 0/255, green: 123/255, blue: 195/255, alpha: 1)
                
            }
            more.backgroundColor = UIColor.lightGray
            
            //创建“旗标”事件按钮
            let favorite = UITableViewRowAction(style: .normal, title: "标记\n可疑") {
                action, index in
                // UIAlertController.showAlert(message: "点击了“旗标”按钮")
            }
            favorite.backgroundColor = UIColor.orange
            
            //创建“删除”事件按钮
            let delete = UITableViewRowAction(style: .normal, title: "删除") {
                action, index in
                //将对应条目的数据删除
                //self.items.remove(at: index.row)
                //tableView.reloadData()
            }
            delete.backgroundColor = UIColor.red
            //返回所有的事件按钮
       
            return [delete, favorite, more]
    }
  
    
}



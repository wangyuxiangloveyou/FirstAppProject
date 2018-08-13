//
//  NowSmokeView.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/4.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit

class NowSmokeView: UIView {
    var tableView:UITableView?
    var nowCellclourse:IngreJumpClosure?
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        //self.backgroundColor=UIColor.white
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
        tableView?.register(UINib(nibName: "NowSmokeCell",bundle: nil), forCellReuseIdentifier: "NowSmokeCellId")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NowSmokeView:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:NowSmokeCell = tableView.dequeueReusableCell(withIdentifier: "NowSmokeCellId", for: indexPath as IndexPath) as! NowSmokeCell
        cell.FirstImageView.image=UIImage(named: "居民楼-黑.png")
        cell.AdressLabel.textColor=UIColor.init(red: 0/255, green: 123/255, blue: 195/255, alpha: 1)
        let str = "田林十二村-4栋-202"
        let moneyTitle = NSMutableAttributedString.init(string:str)
        moneyTitle.addAttribute(NSForegroundColorAttributeName, value:UIColor.red, range:NSRange.init(location:9, length: 3))
        moneyTitle.addAttribute(NSFontAttributeName, value:UIFont.systemFont(ofSize:16), range:NSRange.init(location:9, length: 3))
        moneyTitle.addAttribute(NSForegroundColorAttributeName, value:UIColor.red, range:NSRange.init(location:6, length: 1))
        moneyTitle.addAttribute(NSFontAttributeName, value:UIFont.systemFont(ofSize:16), range:NSRange.init(location:6, length: 1))
        cell.AdressLabel.attributedText = moneyTitle
        
        cell.PersonLabel.text="常住人口 共4人"
        cell.NameLabel.text="业主:张玲玲"
        cell.TimeLabel.text="2018-02-19 13:22:34"

        cell.ImageBtn.setTitle("受理中", for: .normal)

        cell.ImageBtn.backgroundColor=UIColor.init(red: 76/255, green: 162/255, blue: 255/255, alpha: 1)
        cell.ImageBtn.tintColor=UIColor.white
        cell.ImageBtn.titleLabel?.textAlignment = .center
        cell.RedLabel.text="暂无60～80岁以上的独居老人"
        
        cell.nowClourse = {
            () in
            if self.nowCellclourse != nil {
                self.nowCellclourse!()
            }
        }
        cell.selectionStyle = .none
        return cell
        
    }
}


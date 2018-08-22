//
//  SmokeFeelingView.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/4.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import MJRefresh

public var id1=""
class SmokeFeelingView: UIView {
    var pageNum = 0
    var shouldLoadMoreData = true
    var index = 1
    var dataArray:[AnyObject]=[]
    var tableView:UITableView?
    var untreatedSmokeCellClourse:OperationSelected?
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadData1()
        tableView=UITableView(frame: CGRect(x: 0, y: 0, width:screenWidth , height: screenHeight-106), style: .plain)
        self.layer.contents = UIImage(named:"mmexport1525609772323.jpg")?.cgImage
        tableView?.layer.contents = UIImage(named:"mmexport1525609772323.jpg")?.cgImage
        self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView?.isScrollEnabled = true
        self.addSubview(tableView!)
    }
    
   
    
    func configUI()  {
        //创建表格试图
        tableView?.dataSource=self
        tableView?.delegate=self
        
        self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView?.isScrollEnabled = true
        
        //tableView?.separatorStyle = UITableViewCellSeparatorStyle.singleLineEtched
        //tableView?.allowsSelection = false
        tableView?.register(UINib(nibName: "SmokeFeelingCell",bundle: nil), forCellReuseIdentifier: "SmokeFeelingCellId")
        
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(CompleteSmokeView.headerRefresh))
        // 现在的版本要用mj_header
        tableView?.mj_header = header
        header.setTitle("", for: .idle)
        header.setTitle("释放更新", for: .pulling)
        header.setTitle("正在刷新...", for: .refreshing)
        // 上拉加载
        footer.setRefreshingTarget(self, refreshingAction: #selector(CompleteSmokeView.footerRefresh))
        tableView?.mj_footer = footer
        footer.setTitle("", for: .idle)
        footer.setTitle("释放加载", for: .pulling)
        footer.setTitle("正在加载...", for: .refreshing)
        footer.setTitle("没有更多数据", for: .noMoreData)
    }
    
    
    //顶部刷新
    func headerRefresh(){
        print("下拉刷新")
        // 结束刷新
        // self.tableView?.mj_header.beginRefreshing()
        index=1
        loadData1()
    }
    
    // 底部刷新
    
    func footerRefresh()
    {
        index = index + 1
        // self.tableView?.mj_footer.beginRefreshing()
        if shouldLoadMoreData {
            loadData1()
        } else {
            self.tableView!.mj_footer.endRefreshingWithNoMoreData()
        }
    }
    
    func startRefreshData1()
    {
        self.tableView?.mj_header.beginRefreshing()
        index = 1
        loadData1()
    }
    
    //获取烟感事件列表
    func loadData1()
    {
        let parameters: Parameters = [
            "head":[
                "platform":"app",
                "timestamp":timeStamp,
                "token":token1,
                "longitude":longitude,
                "latitude":latitude,
            ],
            "villageIDs":villageArray,
            "status":0,
            "pageNum":index,
            "pageSize":20,
            ]
        Alamofire.request("http://47.75.190.168:5000/api/app/getSmokeDetectorEventList", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ (response)  in
            print(token1)
            print("获取烟感未处理事件列表")
            if let dic = response.result.value
            {
                let data : NSData! = try! JSONSerialization.data(withJSONObject: dic, options: []) as NSData?
                let json = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
  
                print("json: \(json)")
                let model1:SmokeModel = SmokeModel.mj_object(withKeyValues: dic)
                if model1.responseStatus?.resultCode == 0 && model1.events != nil {
                    let c =  model1.events!.count
                    print(c)
                    self.shouldLoadMoreData = c >= 15
                    if c>0
                    {
                        if self.index > 1
                        {
                            for i in 0..<c
                            {
                                self.dataArray.append(model1.events[i])
                            }
                        }
                        else if self.index == 1
                        {
                            self.dataArray = model1.events!
                        }
                    }
                    else
                    {
                        //self.tableView!.mj_footer.endRefreshingWithNoMoreData()
                    }
                }
            }
            else
            {
                print("dic: \(response)")
            }
            // 结束刷新
            self.tableView?.reloadData()
            self.configUI()
            self.tableView?.mj_header.endRefreshing()
            self.tableView?.mj_footer.endRefreshing()
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



extension SmokeFeelingView:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model:eventsModel=self.dataArray[indexPath.row] as! eventsModel
            if model.tag.count==0{
               return 80
            }
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell:SmokeFeelingCell = (tableView.dequeueReusableCell(withIdentifier: "SmokeFeelingCellId", for: indexPath as IndexPath) as? SmokeFeelingCell)!
        let model:eventsModel=(self.dataArray[indexPath.row] as? eventsModel)!
        
        cell.FirstImageView.image=UIImage(named: "居民楼-黑.png")
        cell.AdressLabel.textColor=UIColor.init(red: 0/255, green: 123/255, blue: 195/255, alpha: 1)
        
        if model.villageName != nil && model.buildingNo != nil && model.houseNo != nil{
            let str = model.villageName!+"-"+"\(model.buildingNo!)"+"栋-"+"\(model.houseNo!)"
            let moneyTitle = NSMutableAttributedString.init(string:str)
            moneyTitle.addAttribute(NSForegroundColorAttributeName, value:UIColor.red, range:NSRange.init(location:(model.villageName?.count)!+"\(model.buildingNo!)".count+3, length: "\(model.houseNo!)".count))
                    moneyTitle.addAttribute(NSFontAttributeName, value:UIFont.systemFont(ofSize:16), range:NSRange.init(location:(model.villageName?.count)!+"\(model.buildingNo!)".count+3, length: "\(model.houseNo!)".count))
            moneyTitle.addAttribute(NSForegroundColorAttributeName, value:UIColor.red, range:NSRange.init(location:(model.villageName?.count)!+1, length: "\(model.buildingNo!)".count))
            moneyTitle.addAttribute(NSFontAttributeName, value:UIFont.systemFont(ofSize:16), range:NSRange.init(location:(model.villageName?.count)!+1, length: "\(model.buildingNo!)".count))
             cell.AdressLabel.attributedText = moneyTitle
        }

        if model.residentNum == 0{
            cell.NameLabel.text=""
        }
        
        cell.PersonLabel.text="常住人口共"+"\(model.residentNum!)"+"人"
        if (model.people?.count)! > 0 {
        for i in 0..<model.people!.count{
            if model.people?[i].relation != nil{
            if Int((model.people?[i].relation)!) == 1{
                cell.NameLabel.text="业主:" + (model.people?[i].name)!
            }
            }
        }
        }
       
        cell.TimeLabel.text=model.createTime
       
        cell.ImageBtn.setTitle("受理", for: .normal)
        let  gradientLayer1 = CAGradientLayer.createCAGradientLayer()
        let TColor = UIColor.init(red: 236/255, green: 86/255, blue: 86/255, alpha: 1)
        let BColor = UIColor.init(red: 255/255, green: 152/255, blue: 74/255, alpha: 1)
        let gradientColors1: [CGColor] = [TColor.cgColor, BColor.cgColor]
        gradientLayer1.colors = gradientColors1
        gradientLayer1.frame = CGRect(x: 0, y: 0, width: 70, height:30)
        cell.ImageBtn.layer.insertSublayer(gradientLayer1, at: 0)
        
        cell.ImageBtn.tintColor=UIColor.white
        cell.ImageBtn.titleLabel?.textAlignment = .center
        cell.RedLabel.textColor=UIColor.red
        cell.RedLabel.text=model.tag.first
        
        cell.untreatedSmokeClourse = {
            () in
            if self.untreatedSmokeCellClourse != nil {
                 let dataSoure:eventsModel=self.dataArray[indexPath.row] as! eventsModel
                self.untreatedSmokeCellClourse!(dataSoure)
                print(model.eventID!)
                id1=model.eventID!
                print(id1)
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

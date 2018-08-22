    //
    //  UntreatedDoorView.swift
    //  TianLinStreetAdministration
    //
    //  Created by wangyuxiang on 2018/6/4.
    //  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
    //
    
    import UIKit
    import Alamofire
    import SnapKit
    import  MJRefresh
    public var unID=""
    
    public var jump=0
    class UntreatedDoorView: UIView {
        
        var shouldLoadMoreData = true
        var index = 1
        // 顶部刷新
        let header = MJRefreshNormalHeader()
        // 底部刷新
        let footer = MJRefreshAutoNormalFooter()
        var pageNum=0
        var tableView:UITableView?
        var doorCellClourse:OperationSelected?
        var repairCellClourse:OperationSelected?
        var dataArray:[Any]=[]
        var mutableID:[Any]=[]
        var picClource:IngreJumpClosure?
        override init(frame: CGRect) {
            super.init(frame: frame)
            loadData1()
            self.backgroundColor=UIColor.white
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
            self.tableView?.isScrollEnabled = true
            
            //tableView?.separatorStyle = UITableViewCellSeparatorStyle.singleLineEtched
            //tableView?.allowsSelection = false
            tableView?.register(UINib(nibName: "UntreatedDoorCell",bundle: nil), forCellReuseIdentifier: "UntreatedDoorCellId")
            if #available(iOS 11.0, *) {
                tableView?.contentInsetAdjustmentBehavior = .never
                
            } else {
                //self.automaticallyAdjustsScrollViewInsets = false
            }
            
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
            //        self.tableView?.mj_footer.beginRefreshing()
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
        
        
        //获取门禁未完成事件列表
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
            Alamofire.request("http://47.75.190.168:5000/api/app/getAccessEventList", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ (response)  in
                print("获取门禁未完成事件列表")
                print(villageArray)
                
                if let dic = response.result.value {
                    let data : NSData! = try? JSONSerialization.data(withJSONObject: dic, options: []) as NSData!
                    let json = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
                    print("json: \(dic)")
                    print(json)
                    var data1:[String]=[]
                    let model1:UntreatedDoorModel = UntreatedDoorModel.mj_object(withKeyValues: dic)
                    if model1.responseStatus?.resultCode == 0 && model1.events != nil{
                        //最简单粗暴的做法，逐个比较，时间复杂度为(B.length)^(A.length)，b的a次方了，时间复杂度相当高
                        for i in 0..<dataArryID.count{
                            for j in 0..<model1.events!.count{
                                if( dataArryID[i] == model1.events![j].eventID ){
                                    model1.events![j].status = 1
                                    print(model1.events![j].status)
                                }
                            }
                        }
                        let c =  model1.events!.count
                        self.shouldLoadMoreData = c >= 20
                        if c>0
                        {
                            if self.index > 1
                            {
                                for i in 0..<c
                                {
                                    self.dataArray.append(model1.events![i])
                                }
                            }
                            else if self.index == 1
                            {
                                self.dataArray = model1.events!
                            }
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
    
    
    
    extension UntreatedDoorView:UITableViewDelegate,UITableViewDataSource
    {
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.dataArray.count
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 105
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell:UntreatedDoorCell = tableView.dequeueReusableCell(withIdentifier: "UntreatedDoorCellId", for: indexPath as IndexPath) as! UntreatedDoorCell
            let model:UntreatedDoorEventsModel=self.dataArray[indexPath.row] as! UntreatedDoorEventsModel
            cell.FirstImageView.image=UIImage(named: "居民楼-黑.png")
            cell.AdressLabel.textColor=UIColor.init(red: 0/255, green: 123/255, blue: 195/255, alpha: 1)
            let str = model.villageName!+"-"+"\(model.buildingNo!)"+"栋"
            let moneyTitle = NSMutableAttributedString.init(string:str)
            moneyTitle.addAttribute(NSForegroundColorAttributeName, value:UIColor.red, range:NSRange.init(location:model.villageName!.count+1, length: "\(model.buildingNo!)".count))
            moneyTitle.addAttribute(NSFontAttributeName, value:UIFont.systemFont(ofSize:17), range:NSRange.init(location:model.villageName!.count+1, length: "\(model.buildingNo!)".count))
            cell.AdressLabel.attributedText = moneyTitle
            
            cell.TimeLabel.text=model.createTime
            cell.ReceiptButton.tintColor=UIColor.white
            var str1 = ""
            if (model.options?.count)! > 0 && (model.options![0].code == "select"){
                cell.ReceiptButton.setTitle(model.options![0].name, for: .normal)
                str1 = model.options![1].name!
            }else{
                cell.ReceiptButton.setTitle(model.options![1].name, for: .normal)
                str1 = model.options![1].name!
            }
            
            cell.ReceiptButton.backgroundColor=UIColor.init(red: 59/255, green: 89/255, blue: 152/255, alpha: 1)
            print(model.key)
            print(self.dataArray)
            if model.status == 1{
                
                jump=1
                cell.ReceiptButton.isHidden=true
                cell.HandleButton.snp.makeConstraints { (make) in
                    make.top.equalTo(cell.AdressLabel.snp.bottom).offset(10)
                    make.left.equalTo(self).offset(3)
                    make.width.equalTo(screenWidth-6)
                }
            }
            
            cell.HandleButton.tintColor=UIColor.white
            cell.HandleButton.backgroundColor=UIColor.init(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
            
            let moneyTitle1 = NSMutableAttributedString.init(string:str1)
            moneyTitle1.addAttribute(NSFontAttributeName, value:UIFont.systemFont(ofSize:12), range:NSRange.init(location:0, length: 4))
            cell.HandleButton.setAttributedTitle(moneyTitle1, for: .normal)
            
            cell.doorClourse = {
                () in
                if self.doorCellClourse != nil {
                    let doorDataSource:UntreatedDoorEventsModel=self.dataArray[indexPath.row] as! UntreatedDoorEventsModel
                    self.doorCellClourse!(doorDataSource)
                }
            }
            cell.comClource = {
                () in
                if self.repairCellClourse != nil {
                    let doorDataSource:UntreatedDoorEventsModel=self.dataArray[indexPath.row] as! UntreatedDoorEventsModel
                    self.repairCellClourse!(doorDataSource)
                }
            }
            
            cell.selectionStyle = .none
            return cell
            
        }
    }

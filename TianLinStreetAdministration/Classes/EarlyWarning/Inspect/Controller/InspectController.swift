//
//  InspectController.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/4.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit

class InspectController: UIViewController {

    var segCtrl:KtcSegCtrl?
    //滚动视图
    public var scrollView:UIScrollView?
    var view1=UIView()
    var btn1=UIButton()
    var btn2=UIButton()
    var allLabel=UILabel()
    var allTextView=UITextView()
    let nameLabel=UILabel()
    let oneTableView=UITableView()
    var firstView:UntreatedInspectView?
    var secondView:NowInspectView?
    var ThreeView:CompleteInspectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.white
        self.oneTableView.isScrollEnabled = true
        self.oneTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.oneTableView.allowsSelection = false
        oneTableView.delegate=self
        oneTableView.dataSource=self
        oneTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        
        self.title="设备自检"
        creatNav()
        configUI2()
        ThreeView?.remarksCellClourse = {
            () in
          self.configUI1()
        }
        ThreeView?.repairCellClourse = {
            () in
            self.configUI1()
        }
    }
    
    func creatNav(){
        //选择控件
        let frame=CGRect(x: 0, y: navigationBarHeight-24, width: screenWidth, height:95)
        segCtrl=KtcSegCtrl(frame: frame, titleArray: ["未处理","处理中","已处理"])
        segCtrl?.delegate=self
        segCtrl?.backgroundColor = UIColor.white
        view.addSubview(segCtrl!)
        
        let badgeLayer=CATextLayer.createTextLayer()
        segCtrl?.layer.addSublayer(badgeLayer)
        badgeLayer.frame=CGRect(x: screenWidth/3-20, y: 45, width: 18, height: 18)
        badgeLayer.cornerRadius=9
        badgeLayer.fontSize=16
        badgeLayer.string="2"
        
        let badgeLayer2=CATextLayer.createTextLayer()
        segCtrl?.layer.addSublayer(badgeLayer2)
        badgeLayer2.frame=CGRect(x: screenWidth/3*2-20, y: 45, width: 18, height: 18)
        badgeLayer2.cornerRadius=9
        badgeLayer.fontSize=16
        badgeLayer2.string="3"
        
//        let badgeLayer3=CATextLayer.createTextLayer()
//        segCtrl?.layer.addSublayer(badgeLayer3)
//        badgeLayer3.frame=CGRect(x: screenWidth-20, y: 45, width: 20, height: 20)
//        badgeLayer3.cornerRadius=10
//        badgeLayer3.string=""
    }
    
    func configUI1() {
        
        self.segCtrl?.selectIndex=2
        self.scrollView?.contentOffset.x=2*(self.scrollView?.bounds.size.width)!
        
        self.view1.backgroundColor=UIColor.white
        self.ThreeView?.addSubview(self.view1)
        self.view1.snp.makeConstraints { (make) in
            make.width.equalTo(screenWidth)
            make.height.equalTo(screenHeight)
            make.top.right.left.bottom.equalTo(self.ThreeView!)
            
        }
        view1.backgroundColor=UIColor(patternImage: UIImage(named: "mmexport1525609772323.jpg")!)
        
        let imageView1=UIImageView()
        self.view1.addSubview(imageView1)
        imageView1.image=UIImage(named: "居民楼-黑.png")
        imageView1.snp.makeConstraints { (make) in
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.top.left.equalTo(self.ThreeView!).offset(5)
        }
        let addressLabel=UILabel()
        self.view1.addSubview(addressLabel)
        addressLabel.text="田林十二村"
        addressLabel.textColor=UIColor.init(red: 0/255, green: 123/255, blue: 195/255, alpha: 1)
        addressLabel.snp.makeConstraints { (make) in
            make.width.equalTo(screenWidth/2-20)
            make.height.equalTo(30)
            make.left.equalTo(imageView1.snp.right).offset(5)
            make.top.equalTo(self.ThreeView!).offset(5)
        }
        
        let timeLabel=UILabel()
        self.view1.addSubview(timeLabel)
        timeLabel.text="2018-02-19 13:22:34"
        //timeLabel.textAlignment = .left
        timeLabel.font=UIFont.systemFont(ofSize: 14)
        timeLabel.textColor=UIColor.black
        timeLabel.snp.makeConstraints { (make) in
            make.width.equalTo(screenWidth/2)
            make.height.equalTo(30)
            make.left.equalTo(addressLabel.snp.right).offset(0)
            make.top.equalTo(self.ThreeView!).offset(5)
        }
        
        let deviceLabel=UILabel()
        self.view1.addSubview(deviceLabel)
        deviceLabel.text="监控摄像机"
        deviceLabel.textColor=UIColor.black
        deviceLabel.snp.makeConstraints { (make) in
            make.width.equalTo(screenWidth/2)
            make.height.equalTo(30)
            make.left.equalTo(self.ThreeView!).offset(8)
            make.top.equalTo(addressLabel.snp.bottom).offset(3)
        }
        
        let numberLabel=UILabel()
        self.view1.addSubview(numberLabel)
        numberLabel.text="31827384753472038475"
        numberLabel.textAlignment = .left
       numberLabel.font=UIFont.systemFont(ofSize: 15)
        numberLabel.textColor=UIColor.black
        numberLabel.snp.makeConstraints { (make) in
            make.width.equalTo(screenWidth/3*2)
            make.height.equalTo(30)
            make.left.equalTo(self.ThreeView!).offset(8)
            make.top.equalTo(deviceLabel.snp.bottom).offset(3)
        }
        
        let repairabtn=UIButton()
        self.view1.addSubview(repairabtn)
       repairabtn.setTitle("已修复", for: .normal)
        repairabtn.titleLabel?.font=UIFont.systemFont(ofSize: 14)
        repairabtn.titleLabel?.textAlignment = .center
        repairabtn.addTarget(self, action: #selector(repairabtnClick), for: .touchUpInside)
        repairabtn.backgroundColor=UIColor.init(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        repairabtn.tintColor=UIColor.blue
        repairabtn.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(35)
            make.right.equalTo(self.ThreeView!).offset(-10)
            make.top.equalTo(timeLabel.snp.bottom).offset(18)
        }
        
       
        self.view1.addSubview(nameLabel)
        self.nameLabel.numberOfLines=0
        self.nameLabel.text="02-19 10:23:43\n  厂家已接单\n  预计2/20日9-11点派人查看\n\n02-20 10:23:43\n  设备故障已修复"
        self.nameLabel.font=UIFont.systemFont(ofSize: 15)
        self.nameLabel.snp.makeConstraints { (make) in
            make.width.equalTo(screenWidth/4*3)
            make.height.equalTo(120)
            make.left.equalTo(self.ThreeView!).offset(10)
            make.top.equalTo(repairabtn.snp.bottom).offset(0)
        }
        
        
    }
    func repairabtnClick(btn:UIButton){
        self.nameLabel.removeFromSuperview()
        self.view1.removeFromSuperview()
    }
    func configUI2(){
        scrollView=UIScrollView()
        scrollView!.isPagingEnabled=true
        //设置代理
        scrollView?.delegate=self
        view.addSubview(scrollView!)
        //约束
        scrollView!.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(114, 0, 0, 0))
        }
        //容器视图
        let containerView=UIView.createView()
        scrollView!.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView!)
            make.height.equalTo(scrollView!)
        }
        //添加子视图
        //1.firstView子视图
        firstView = UntreatedInspectView()
        containerView.addSubview(firstView!)
        firstView?.snp.makeConstraints({ (make) in
            make.top.bottom.left.equalTo(containerView)
            make.width.equalTo(screenWidth)
        })
        
        //2.secondView视图
        secondView = NowInspectView()
        
        containerView.addSubview(secondView!)
        secondView?.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(containerView)
            make.width.equalTo(screenWidth)
            make.left.equalTo((firstView?.snp.right)!)
        })
        //3.ThreeView视图
        ThreeView=CompleteInspectView()
        containerView.addSubview(ThreeView!)
        
        ThreeView?.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(containerView)
            make.width.equalTo(screenWidth)
            make.left.equalTo((secondView?.snp.right)!)
        })
        
        //修改容器视图大小
        containerView.snp.makeConstraints { (make) in
            make.right.equalTo(ThreeView!)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
//Mark: KtcSegCtrl代理
extension InspectController:KtcSegCtrlDelegate{
    func segCtrl(segCtrl: KtcSegCtrl, didClickBtnIndex index: Int) {
        scrollView?.setContentOffset(CGPoint(x: CGFloat(index)*screenWidth, y: 0), animated: true)
        self.nameLabel.removeFromSuperview()
        self.view1.removeFromSuperview()
    }
}

//Mark: scrollView代理

extension InspectController:UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index=scrollView.contentOffset.x/scrollView.bounds.size.width
        segCtrl?.selectIndex=Int(index)
        self.nameLabel.removeFromSuperview()
        self.view1.removeFromSuperview()
    }
}

extension InspectController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.imageView?.image=UIImage(named: "circle.png")
        cell.textLabel?.text="2016-08-09 20"
        return cell
    }
    
    
}

//
//  CarStopController.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/4.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit
import Alamofire
import MJRefresh

class CarStopController: UIViewController {

    var segCtrl:KtcSegCtrl?
    //滚动视图
    public var scrollView:UIScrollView?
    var firstView:UntreatedReadView?
    var secondView:CompleteReadView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.white
        view.backgroundColor=UIColor(patternImage: UIImage(named: "mmexport1525609772323.jpg")!)
        self.title="小区停车"
        creatNav()
        configUI2()
        firstView?.cellClourse = {
            (id1) in
            
            let vc=pictureController()
            number1=2
            self.navigationController?.pushViewController(vc, animated: true)
            self.segCtrl?.selectIndex=1
            self.scrollView?.contentOffset.x=1*(self.scrollView?.bounds.size.width)!
            carId=id1 as! String
            self.loadData1()
            print(carId)
            
        }
        
    }
    
    //停车处理结果上报
    func loadData1()
    {
        let parameters: Parameters = [
            "head":[
                "platform":"app",
                "timestamp":timeStamp,
                "token":token1,
            ],
            "status":1,
            "eventID":carId,
        ]
        print(parameters)
        Alamofire.request("http://47.75.190.168:5000/api/app/parkingProcessReport", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ (response)  in
            if let dic = response.result.value {
                print("车处理结果上报")
                let data : NSData! = try! JSONSerialization.data(withJSONObject: dic, options: []) as NSData?
                let json = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
                print("dic: \(json)")
            }
            else
            {
                print("dic: \(response)")
            }
        }
    }
    
    func creatNav(){
        //选择控件
        let frame=CGRect(x: 0, y: navigationBarHeight-24, width: screenWidth, height: 95)
        segCtrl=KtcSegCtrl(frame: frame, titleArray: ["未读","已读"])
        segCtrl?.delegate=self
        segCtrl?.backgroundColor = UIColor.white
        view.addSubview(segCtrl!)
        let badgeLayer=CATextLayer.createTextLayer()
        segCtrl?.layer.addSublayer(badgeLayer)
        badgeLayer.frame=CGRect(x: screenWidth/2-20, y: 45, width: 18, height: 18)
        badgeLayer.cornerRadius=9
        badgeLayer.fontSize=12
        if  Int(carStopRed) > 99  {
            badgeLayer.string="99+"
        }else{
            badgeLayer.string="\(carStopRed)"
        }
       
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
        firstView = UntreatedReadView()
        containerView.addSubview(firstView!)
        firstView?.snp.makeConstraints({ (make) in
            make.top.bottom.left.equalTo(containerView)
            make.width.equalTo(screenWidth)
        })
        
        //2.secondView视图
        secondView = CompleteReadView()
        
        containerView.addSubview(secondView!)
        secondView?.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(containerView)
            make.width.equalTo(screenWidth)
            make.left.equalTo((firstView?.snp.right)!)
        })
        
        
        //修改容器视图大小
        containerView.snp.makeConstraints { (make) in
            make.right.equalTo(secondView!)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//Mark: KtcSegCtrl代理
extension CarStopController:KtcSegCtrlDelegate{
    func segCtrl(segCtrl: KtcSegCtrl, didClickBtnIndex index: Int) {
        scrollView?.setContentOffset(CGPoint(x: CGFloat(index)*screenWidth, y: 0), animated: true)
        if segCtrl.selectIndex == 0{
            firstView?.startRefreshData1()
        }
        
        if segCtrl.selectIndex == 1{
            self.secondView?.startRefreshData1()
        }
    }
}

//Mark: scrollView代理

extension CarStopController:UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index=scrollView.contentOffset.x/scrollView.bounds.size.width
        segCtrl?.selectIndex=Int(index)
        if segCtrl?.selectIndex == 0{
            firstView?.startRefreshData1()
        }
        
        if segCtrl?.selectIndex == 1{
            self.secondView?.startRefreshData1()
        }
    }
}

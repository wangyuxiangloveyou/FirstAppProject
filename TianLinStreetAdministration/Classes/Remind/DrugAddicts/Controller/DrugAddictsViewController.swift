//
//  DrugAddictsViewController.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/22.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit

class DrugAddictsViewController: UIViewController {

    var segCtrl:KtcSegCtrl?
    //滚动视图
    public var scrollView:UIScrollView?
    var firstView:UnDrugAddictsView?
    var secondView:ComDrugAddictsView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor=UIColor.white
        view.backgroundColor=UIColor(patternImage: UIImage(named: "mmexport1525609772323.jpg")!)
        self.title="吸毒人员"
        let backItem:UIBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 31/255, green: 80/255, blue: 203/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor.white
        view.backgroundColor=UIColor(patternImage: UIImage(named: "mmexport1525609772323.jpg")!)
        
        creatNav()
        configUI2()
//        if item1==1 {
//            self.segCtrl?.selectIndex=1
//            self.scrollView?.contentOffset.x=(self.scrollView?.bounds.size.width)!
//        }
        
        firstView?.cellClourseONE = {
            () in
            let vc=DrugAddictsDetailsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        secondView?.cellClourseONE = {
            () in
            let vc=DrugAddictsDetailsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func creatNav(){
        //选择控件
        let frame=CGRect(x: 0, y: 20, width: screenWidth, height: 95)
        segCtrl=KtcSegCtrl(frame: frame, titleArray: ["未读","已读"])
        segCtrl?.delegate=self
        segCtrl?.backgroundColor = UIColor.white
        view.addSubview(segCtrl!)
        
        //        let badgeLayer=CATextLayer.createTextLayer()
        //        segCtrl?.layer.addSublayer(badgeLayer)
        //        badgeLayer.frame=CGRect(x: screenWidth/2-20, y: 45, width: 20, height: 20)
        //        badgeLayer.cornerRadius=10
        //        badgeLayer.string="2"
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
        firstView = UnDrugAddictsView()
        containerView.addSubview(firstView!)
        firstView?.snp.makeConstraints({ (make) in
            make.top.bottom.left.equalTo(containerView)
            make.width.equalTo(screenWidth)
        })
        
        //2.secondView视图
        secondView = ComDrugAddictsView()
        
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
extension DrugAddictsViewController:KtcSegCtrlDelegate{
    func segCtrl(segCtrl: KtcSegCtrl, didClickBtnIndex index: Int) {
        scrollView?.setContentOffset(CGPoint(x: CGFloat(index)*screenWidth, y: 0), animated: true)
    }
}

//Mark: scrollView代理
extension DrugAddictsViewController:UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index=scrollView.contentOffset.x/scrollView.bounds.size.width
        segCtrl?.selectIndex=Int(index)
        
    }
}

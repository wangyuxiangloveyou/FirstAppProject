//
//  DrugAddictsDetailsCell.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/7/12.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit

class DrugAddictsDetailsCell: UITableViewCell {
    var model1:alarmsDetailsModel?
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var peopleLabel: UILabel!
    
    
    @IBOutlet weak var timeTableView: UITableView!
    @IBOutlet weak var suspiciousLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bgView.layer.shadowColor = UIColor.black.cgColor;
        self.bgView.layer.shadowOpacity = 0.30;
        self.bgView.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.timeTableView?.isScrollEnabled = true
        self.timeTableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        self.timeTableView?.allowsSelection = false
        timeTableView.delegate=self
        timeTableView.dataSource=self
        timeTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        
    }

    func refreshData(model:alarmsDetailsModel){
        model1=model
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension DrugAddictsDetailsCell:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if model1?.trafficRecords != nil && model1?.visitorRecords == nil{
        return (model1?.trafficRecords?.count)!/3
        }
        if model1?.trafficRecords == nil && model1?.visitorRecords != nil{
            return (model1?.visitorRecords?.count)!/3
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if model1?.trafficRecords == nil && model1?.visitorRecords == nil{
            return 0
        }
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if model1?.trafficRecords != nil && model1?.visitorRecords == nil{
            for i in 0..<(model1?.trafficRecords)!.count{
                cell.textLabel?.text=(self.textLabel?.text)! + "通行记录" + (model1?.trafficRecords?[i].modelName)!
            }
        }
        
        if model1?.trafficRecords == nil && model1?.visitorRecords != nil{
            for i in 0..<(model1?.visitorRecords)!.count{
                cell.textLabel?.text=(self.textLabel?.text)! + "访客记录" + (model1?.visitorRecords?[i].modelName)!
            }
        }
        return cell
    }
    
    
}

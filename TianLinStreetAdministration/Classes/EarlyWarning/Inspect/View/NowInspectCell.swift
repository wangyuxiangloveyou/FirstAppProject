//
//  NowInspectCell.swift
//  TianLinStreetAdministration
//
//  Created by wangyuxiang on 2018/6/4.
//  Copyright © 2018年 TianLinStreetAdministration. All rights reserved.
//

import UIKit

class NowInspectCell: UITableViewCell {
    @IBOutlet weak var AdressLabel: UILabel!
    
    @IBOutlet weak var FirstImageView: UIImageView!
    
    @IBOutlet weak var TimeLabel: UILabel!
    
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var NumberLabel: UILabel!
    
    @IBOutlet weak var bakView: UIView!
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    
    
    @IBOutlet weak var twoTableView: UITableView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bakView.layer.shadowColor = UIColor.black.cgColor;
        self.bakView.layer.shadowOpacity = 0.3;
        self.bakView.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.twoTableView?.isScrollEnabled = true
        self.twoTableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        self.twoTableView?.allowsSelection = false
        twoTableView.delegate=self
        twoTableView.dataSource=self
        twoTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension NowInspectCell:UITableViewDataSource,UITableViewDelegate{
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

//
//  PTCalendarPickerCollectionViewCell.swift
//  WeiShop
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年 zou. All rights reserved.
//

import UIKit

class PTCalendarPickerCollectionViewCell: UICollectionViewCell {
    
    var dateLabel: UILabel?
    var backView: UIView?
    var typeLabel: UILabel?
    
    var selectedBackgroundColor: UIColor = UIColor(red: 74/255.0 ,green: 137/255.0 ,blue: 220/255.0, alpha: 1)
    var startTitle: String = "起始"
    var endTitle: String = "结束"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let backWidth: CGFloat = self.bounds.width > self.bounds.height ? self.bounds.height : self.bounds.width
        
        backView = UIView(frame: CGRectMake((self.bounds.width - backWidth) / 2, (self.bounds.height - backWidth) / 2, backWidth, backWidth))
        backView?.backgroundColor = selectedBackgroundColor
        backView?.layer.cornerRadius = (backView?.frame.size.height)! / 2
        backView?.hidden = true
        
        self.addSubview(backView!)
        
        dateLabel = UILabel(frame: self.bounds)
        dateLabel?.textAlignment = .Center
        dateLabel?.textColor = UIColor.darkGrayColor()
        self.addSubview(dateLabel!)
        
        typeLabel = UILabel(frame: CGRectMake(0, self.bounds.height * 0.4, self.bounds.width, self.bounds.height / 2))
        typeLabel?.textColor = UIColor.whiteColor()
        typeLabel?.textAlignment = .Center
        typeLabel?.font = UIFont.systemFontOfSize(13)
        typeLabel?.hidden = true
        
        self.addSubview(typeLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeCell() {
        dateLabel?.frame = self.bounds
        dateLabel?.font = UIFont.systemFontOfSize(17)
        typeLabel?.hidden = true
        backView?.hidden = true
    }
    
    func selectedCell(isStart isStart: Bool) {
        dateLabel?.frame = CGRectMake(0, self.bounds.height * 0.05, self.bounds.width, self.bounds.height / 2)
        dateLabel?.textColor = UIColor.whiteColor()
        dateLabel?.font = UIFont.systemFontOfSize(13)
        
        backView?.hidden = false
        
        typeLabel?.hidden = false
        
        if isStart {
            typeLabel?.text = startTitle
        }else {
            typeLabel?.text = endTitle
        }
    }
}

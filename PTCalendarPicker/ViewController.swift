//
//  ViewController.swift
//  PTCalendarPicker
//
//  Created by apple on 16/9/23.
//  Copyright © 2016年 apple403. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PTCalendarPickerViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let calendarPickerView: PTCalendarPickerView = PTCalendarPickerView(delegete: self)
        calendarPickerView.showCalendarPickerView(parentView: self.view, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // called when selected Finish
    func selectedFinish(startDate: NSDate, endDate: NSDate) {
        print(startDate, endDate)
    }
    
    // called when click bacoground
    func clickBacogroundDismissCalendar() {
        
        print("点击背景取消")
    }
}


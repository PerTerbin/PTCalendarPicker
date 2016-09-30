//
//  PTCalendarPickerView.swift
//  WeiShop
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年 zou. All rights reserved.
//

import UIKit

let PTDeviceWidth: CGFloat = UIScreen.mainScreen().bounds.size.width
let PTDeviceHeight: CGFloat = UIScreen.mainScreen().bounds.size.height

public enum PTCalendarType {
    case DAY
    case MONTH
    case YEAR
}

public protocol PTCalendarPickerViewDelegate {
    // called when selected Finish
    func selectedFinish(startDate: NSDate, endDate: NSDate)
    // called when click bacoground
    func clickBacogroundDismissCalendar()
}

public class PTCalendarPickerView: UIView {

    //样式
    public var topViewBackgroundColor: UIColor = UIColor(red: 74/255.0 ,green: 137/255.0 ,blue: 220/255.0, alpha: 1)
    
    public var delegete: PTCalendarPickerViewDelegate?
    
    private var calenderCollectionView: UICollectionView?
    private var bodyView: UIView?
    private var monthButton: UIButton?
    private var collectionViewDelegate: PTCalendarCollectionViewDelegate
    
    //MARK: - 初始化
    public init(delegete: PTCalendarPickerViewDelegate) {
        
        let today: NSDate = NSDate()
        collectionViewDelegate = PTCalendarCollectionViewDelegate(today: today, date: today)
        
        super.init(frame: CGRectMake(0, 0, PTDeviceWidth, PTDeviceHeight))
        self.delegete = delegete
        collectionViewDelegate.delegete = delegete
        collectionViewDelegate.dismissCalendarPickerView = self.dismissCalendarPickerView
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        
        //创建蒙版
        let coverView: UIView = UIView(frame: CGRectMake(0, 0, PTDeviceWidth, PTDeviceHeight))
        coverView.backgroundColor = UIColor.blackColor()
        coverView.alpha = 0.6
        coverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickBacogroundDismissCalendar)))
        self.addSubview(coverView)
        
        bodyView = UIView(frame: CGRectMake(0, PTDeviceHeight * 0.3, PTDeviceWidth, PTDeviceHeight * 0.4))
        let upRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.nextPage))
        upRecognizer.direction = .Up
        bodyView?.addGestureRecognizer(upRecognizer)
        let downRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.beforePage))
        downRecognizer.direction = .Down
        bodyView?.addGestureRecognizer(downRecognizer)
        
        let topView: UIView = UIView(frame: CGRectMake(0, 0, bodyView!.frame.size.width, bodyView!.frame.size.height / 7))
        topView.backgroundColor = topViewBackgroundColor
        
        let leftButton: UIButton = UIButton(frame: CGRectMake(topView.frame.size.width * 0.01, topView.frame.size.height * 0.1, topView.frame.size.height * 0.8, topView.frame.size.height * 0.8))
        leftButton.setImage(UIImage(named: "PTCalendarPicker_left"), forState: .Normal)
        leftButton.addTarget(self, action: #selector(self.beforePage), forControlEvents: .TouchUpInside)
        
        let rightButton: UIButton = UIButton(frame: CGRectMake(topView.frame.size.width * 0.99 - leftButton.frame.size.width, topView.frame.size.height * 0.1, leftButton.frame.size.height, leftButton.frame.size.width))
        rightButton.setImage(UIImage(named: "PTCalendarPicker_right"), forState: .Normal)
        rightButton.addTarget(self, action: #selector(self.nextPage), forControlEvents: .TouchUpInside)
        
        monthButton = UIButton(frame: CGRectMake(topView.bounds.width / 3, leftButton.frame.origin.y, topView.bounds.width / 3, leftButton.frame.size.height))
        monthButton?.addTarget(self, action: #selector(self.titleButtonAction), forControlEvents: .TouchUpInside)
        collectionViewDelegate.monthButton = monthButton
        collectionViewDelegate.setCalenderTitle(collectionViewDelegate.date)
        
        topView.addSubview(leftButton)
        topView.addSubview(rightButton)
        topView.addSubview(monthButton!)
        bodyView!.addSubview(topView)
        
        //CollectionView
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let itemWidth:CGFloat = topView.frame.size.width / 7
        let itemHeight:CGFloat = (bodyView!.frame.size.height - topView.frame.size.height) / 7
        flowLayout.itemSize = CGSize(width: itemWidth , height: itemHeight)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        calenderCollectionView = UICollectionView(frame: CGRectMake(0, topView.frame.origin.y + topView.frame.size.height, topView.frame.size.width, bodyView!.frame.size.height - topView.frame.size.height), collectionViewLayout: flowLayout)
        calenderCollectionView?.backgroundColor = UIColor.whiteColor()
        calenderCollectionView?.registerClass(PTCalendarPickerCollectionViewCell.self, forCellWithReuseIdentifier: "PTCalendarPickerCollectionViewCell")
        calenderCollectionView?.dataSource = collectionViewDelegate
        calenderCollectionView?.delegate = collectionViewDelegate
        collectionViewDelegate.calenderCollectionView = calenderCollectionView
        
        bodyView!.addSubview(calenderCollectionView!)
        
        self.addSubview(bodyView!)
    }
    
    //MARK: - 显示日历
    public func showCalendarPickerView(parentView parentView: UIView, animated: Bool) {
        self.initView()
        
        parentView.addSubview(self)
    }
    
    //MARK: 隐藏日历
    func dismissCalendarPickerView() {
        self.removeFromSuperview()
    }
    
    //MARK: 点击遮罩层隐藏日历
    func clickBacogroundDismissCalendar() {
        self.dismissCalendarPickerView()
        if let dele = self.delegete {
            dele.clickBacogroundDismissCalendar()
        }
    }
    
    //MARK: - 上一页
    func beforePage() {
        let dateComponents: NSDateComponents = NSDateComponents()
        switch collectionViewDelegate.type {
        case .DAY:
            dateComponents.month = -1
        case .MONTH:
            dateComponents.year = -1
        case .YEAR:
            dateComponents.year = -12
        }
        
        UIView.transitionWithView(bodyView!, duration: 0.5, options: .TransitionCurlDown, animations: {
            self.collectionViewDelegate.date = NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: self.collectionViewDelegate.date, options: NSCalendarOptions(rawValue: 0))!
            }, completion: nil)
        collectionViewDelegate.setCalenderTitle(collectionViewDelegate.date)

        calenderCollectionView!.reloadData()
    }
    
    //MARK: 下一页
    func nextPage() {
        let dateComponents: NSDateComponents = NSDateComponents()
        switch collectionViewDelegate.type {
        case .DAY:
            dateComponents.month = +1
        case .MONTH:
            dateComponents.year = +1
        case .YEAR:
            dateComponents.year = +12
        }
        
        UIView.transitionWithView(bodyView!, duration: 0.5, options: .TransitionCurlUp, animations: {
            self.collectionViewDelegate.date = NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: self.collectionViewDelegate.date, options: NSCalendarOptions(rawValue: 0))!
            }, completion: nil)
        collectionViewDelegate.setCalenderTitle(collectionViewDelegate.date)

        calenderCollectionView!.reloadData()
    }
    
    func titleButtonAction() {
        
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let itemWidth:CGFloat = calenderCollectionView!.frame.size.width / 4
        let itemHeight:CGFloat = calenderCollectionView!.frame.size.height / 3
        flowLayout.itemSize = CGSize(width: itemWidth , height: itemHeight)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        calenderCollectionView!.collectionViewLayout = flowLayout
        
        switch collectionViewDelegate.type {
        case .DAY:
            collectionViewDelegate.type = .MONTH
            collectionViewDelegate.setCalenderTitle(collectionViewDelegate.date)
            
            calenderCollectionView!.reloadData()
        case .MONTH:
           collectionViewDelegate.type = .YEAR
            collectionViewDelegate.setCalenderTitle(collectionViewDelegate.date)
            
            calenderCollectionView!.reloadData()
        default:
            break
        }
    }
    
    //MARK: - 设置样式
    public func setTodayTextColor(todayTextColor: UIColor) {
        self.collectionViewDelegate.todayTextColor = todayTextColor
    }
    
    public func setNormalTextColor(normalTextColor: UIColor) {
        self.collectionViewDelegate.normalTextColor = normalTextColor
    }
    
    public func setInvalidTextColor(invalidTextColor: UIColor) {
        self.collectionViewDelegate.invalidTextColor = invalidTextColor
    }
    
    public func setWeekdayTextColor(weekdayTextColor: UIColor) {
        self.collectionViewDelegate.weekdayTextColor = weekdayTextColor
    }
    
    public func setSelectedBackgroundColor(selectedBackgroundColor: UIColor) {
        self.collectionViewDelegate.selectedBackgroundColor = selectedBackgroundColor
    }
    
    public func setStartTitle(startTitle: String) {
        self.collectionViewDelegate.startTitle = startTitle
    }
    
    public func setEndTitle(endTitle: String) {
        self.collectionViewDelegate.endTitle = endTitle
    }
}

class PTCalendarCollectionViewDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var todayTextColor: UIColor = UIColor.redColor()
    var normalTextColor: UIColor = UIColor.darkGrayColor()
    var invalidTextColor: UIColor = UIColor.lightGrayColor()
    var weekdayTextColor: UIColor = UIColor(red: 74/255.0 ,green: 137/255.0 ,blue: 220/255.0, alpha: 1)
    var selectedBackgroundColor: UIColor = UIColor(red: 74/255.0 ,green: 137/255.0 ,blue: 220/255.0, alpha: 1)
    var startTitle: String = "起始"
    var endTitle: String = "结束"
    
    private let weekArray: [String] = ["日","一","二","三","四","五","六"]
    private let monthArray: [String] = ["一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月"]
    private var today: NSDate
    private var date: NSDate
    private var startDate: NSDate?
    private var startIndex: NSIndexPath?
    
    private var type: PTCalendarType = .DAY
    
    private var delegete: PTCalendarPickerViewDelegate?
    private var calenderCollectionView: UICollectionView?
    private var monthButton: UIButton?
    
    private var dismissCalendarPickerView: (()->())?
    
    init(today: NSDate, date: NSDate) {
        
        self.today = today
        self.date = date
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if type == .DAY {
            return 2
        }else {
            return 1
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if type == .DAY {
            if section == 0 {
                return 7
            }else {
                return 42
            }
        }else {
            return 12
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: PTCalendarPickerCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("PTCalendarPickerCollectionViewCell", forIndexPath: indexPath) as! PTCalendarPickerCollectionViewCell
        cell.selectedBackgroundColor = selectedBackgroundColor
        cell.startTitle = startTitle
        cell.endTitle = endTitle
        cell.changeCell()
        
        switch type {
        case .DAY:
            if indexPath.section == 0 {
                cell.dateLabel?.text = weekArray[indexPath.row]
                cell.dateLabel?.textColor = weekdayTextColor
            }else {
                let totaldays: Int = totaldaysInThisMonth(date)
                let firstWeekday: Int = firstWeekdayInThisMonth(date)
                var day: Int = 0
                
                if indexPath.row >= firstWeekday && indexPath.row < firstWeekday + totaldays {
                    let thisDate: NSDate = NSDate(timeInterval: Double(indexPath.row - firstWeekdayInThisMonth(date) + 1 - getDay(date))  * 24 * 60 * 60, sinceDate: date)
                    if thisDate == startDate {
                        cell.selectedCell(isStart: true)
                        return cell
                    }
                    
                    day = indexPath.row - firstWeekday + 1
                    cell.dateLabel?.text = String(day)
                    cell.dateLabel?.textColor = normalTextColor
                    
                    //本月
                    if today.isEqualToDate(date) {
                        if day == getDay(date) {
                            cell.dateLabel?.textColor = todayTextColor
                        }else if day > getDay(date) {
                            cell.dateLabel?.textColor = invalidTextColor
                        }
                    }else {
                        if today.compare(date) == .OrderedAscending {
                            cell.dateLabel?.textColor = invalidTextColor
                        }
                    }
                }else {
                    cell.dateLabel?.text = ""
                    cell.dateLabel?.textColor = invalidTextColor
                    cell.backView?.hidden = true
                }
            }
        case .MONTH:
            cell.dateLabel?.text = monthArray[indexPath.row]
            cell.changeCell()
            cell.dateLabel?.textColor = normalTextColor
            cell.backView?.hidden = true
        case .YEAR:
            cell.dateLabel?.text = String(getYear(date) - 11 + indexPath.row)
            cell.changeCell()
            cell.dateLabel?.textColor = normalTextColor
            cell.backView?.hidden = true
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell: PTCalendarPickerCollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath) as! PTCalendarPickerCollectionViewCell
        
        guard cell.dateLabel?.textColor == normalTextColor || cell.dateLabel?.textColor == todayTextColor else {
            
            return
        }
        
        switch type {
        case .DAY:
            if let start = startDate {
                let endDate: NSDate = NSDate(timeInterval: Double(indexPath.row - firstWeekdayInThisMonth(date) + 1 - getDay(date))  * 24 * 60 * 60, sinceDate: date)
                if start.compare(endDate) == .OrderedAscending {
                    cell.selectedCell(isStart: false)
                    startIndex = indexPath
                    let time: NSTimeInterval = 0.5
                    let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC)))
                    dispatch_after(delay, dispatch_get_main_queue()) {
                        if let dismiss = self.dismissCalendarPickerView {
                            dismiss()
                        }
                        //代理返回结果
                        if let dele = self.delegete {
                            dele.selectedFinish(self.startDate!, endDate: endDate)
                        }
                    }
                }else {
                    let oldCell: PTCalendarPickerCollectionViewCell = collectionView.cellForItemAtIndexPath(startIndex!) as! PTCalendarPickerCollectionViewCell
                    oldCell.changeCell()
                    if start.isEqualToDate(today) {
                        oldCell.dateLabel?.textColor = todayTextColor
                    }else {
                        oldCell.dateLabel?.textColor = normalTextColor
                    }
                    cell.selectedCell(isStart: true)
                    startDate = endDate
                    startIndex = indexPath
                }
                
            }else {
                cell.selectedCell(isStart: true)
                startDate = NSDate(timeInterval: Double(indexPath.row - firstWeekdayInThisMonth(date) + 1 - getDay(date))  * 24 * 60 * 60, sinceDate: date)
                startIndex = indexPath
            }
        case .MONTH:
            type = .DAY
            let dateComponents: NSDateComponents = NSDateComponents()
            dateComponents.month = indexPath.row + 1 - getMonth(date)
            date = NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: self.date, options: NSCalendarOptions(rawValue: 0))!
            
            let itemWidth:CGFloat = calenderCollectionView!.frame.size.width / 7
            let itemHeight:CGFloat = calenderCollectionView!.frame.size.height / 7
            (calenderCollectionView!.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = CGSize(width: itemWidth , height: itemHeight)
            
            setCalenderTitle(date)
            
            calenderCollectionView!.reloadData()
            
        case.YEAR:
            type = .MONTH
            let dateComponents: NSDateComponents = NSDateComponents()
            dateComponents.year = indexPath.row - 11
            date = NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: self.date, options: NSCalendarOptions(rawValue: 0))!
            setCalenderTitle(date)
            
            calenderCollectionView!.reloadData()
        }
        
    }
    
    //MARK: - Date基本操作
    private func totaldaysInThisMonth(date: NSDate) -> Int {
        
        let totaldaysInMonth: NSRange = NSCalendar.currentCalendar().rangeOfUnit(.Day, inUnit: .Month, forDate: date)
        
        return totaldaysInMonth.length
    }
    
    private func firstWeekdayInThisMonth(date: NSDate) -> Int {
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        calendar.firstWeekday = 1
        let comp: NSDateComponents = calendar.components([.Year, .Month, .Day], fromDate: date)
        comp.day = 1
        let firstDayOfMonthDate: NSDate = calendar.dateFromComponents(comp)!
        
        let firstWeekday: Int = calendar.ordinalityOfUnit(.Weekday, inUnit: .WeekOfMonth, forDate: firstDayOfMonthDate)
        return firstWeekday - 1
    }
    
    private func getDay(date: NSDate) -> Int {
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        calendar.firstWeekday = 1
        
        return calendar.component(.Day, fromDate: date)
    }
    
    private func getMonth(date: NSDate) -> Int {
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        calendar.firstWeekday = 1
        
        return calendar.component(.Month, fromDate: date)
    }
    
    private func getYear(date: NSDate) -> Int {
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        calendar.firstWeekday = 1
        
        return calendar.component(.Year, fromDate: date)
    }
    
    //MARK: - 设置日历标题
    private func setCalenderTitle(date: NSDate) {
        
        let month: Int = getMonth(date)
        let year: Int = getYear(date)
        
        let title: String = monthArray[month - 1] + "-" + String(year)
        
        switch type {
        case .DAY:
            monthButton?.setTitle(title, forState: .Normal)
        case .MONTH:
            monthButton?.setTitle(String(getYear(date)), forState: .Normal)
        case .YEAR:
            monthButton?.setTitle(String(getYear(date) - 11) + "-" + String(getYear(date)), forState: .Normal)
        }
        
    }
}


//
//  babyChartViewController.swift
//  bliss
//
//  Created by Hanslen Chen on 16/2/15.
//  Copyright © 2016年 G52GRP-peter. All rights reserved.
//

import UIKit
import QuartzCore
import CoreData

class babyChartViewController: UIViewController, LineChartDelegate {

    @IBOutlet var subNavBar: UINavigationBar!
    @IBOutlet var chartView: UIView!
    @IBOutlet var chartButton: UIButton!
    @IBOutlet var generalButton: UIButton!
    
    var label = UILabel()
    var lineChart: LineChart!
    
    var chartDataL:[BabyChart]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        subNavBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        subNavBar.shadowImage = UIImage()
        self.fetchLocalData()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        let add = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addTapped")
        self.navigationItem.rightBarButtonItem = add
        
        
        let newBackButton = UIBarButtonItem(image: UIImage(named: "back.png"), style: .Plain, target: self, action: "back:")
        newBackButton.image = UIImage(named: "back.png")
        self.navigationItem.leftBarButtonItem = newBackButton;

        
        generalButton.backgroundColor = UIColor(netHex: 0x0D616D)
        generalButton.layer.cornerRadius = 5
        generalButton.layer.borderWidth = 3
        generalButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        chartButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        chartButton.layer.cornerRadius = 5
        
        //draw chart
        var views: [String: AnyObject] = [:]
        
        label.text = "Click the chart to see detailed information"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        label.font = UIFont(name: "Gill Sans", size: 17)
        
        self.chartView.addSubview(label)
        views["label"] = label
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-80-[label]", options: [], metrics: nil, views: views))
        
        // simple arrays
//        let data: [CGFloat] = [6.4, 6.7, 6.9, 7.2, 7.3, 7.5, 7.8, 7.9, 8.0, 8.2,8.5,8.7,8.8,8.9,9.2, 9.3,9.4,9.6,9.7]

        var data:[CGFloat]! = []
        var xLabels: [String]! = []
        var month:[Int]! = []
        var data2: [CGFloat]! = []
        let avg: [CGFloat] = [5.9, 6.2, 6.4, 6.6, 6.8, 7, 7.2, 7.4, 7.6, 7.9, 8.0, 8.1, 8.2, 8.4, 8.5, 8.6,8.7,8.8,9]
        
        
        if(self.chartDataL.count == 0){
            data = [6.4, 6.7, 6.9, 7.2, 7.3, 7.5, 7.8, 7.9, 8.0, 8.2,8.5,8.7,8.8,8.9,9.2, 9.3,9.4,9.6,9.7]
            data2 = avg
            xLabels = ["6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24"]

        }else{
            
//            Construct the data for weight
            for(var i = 0; i < self.chartDataL.count; i++){
                data.append(CGFloat(self.chartDataL[i].weight!))
            }
            
//            When the chart only contains one dot, we can not draw a line, so let append a same number as the previous dot for drawing a horizontical line
            if(self.chartDataL.count == 1){
                data.append(CGFloat(self.chartDataL[0].weight!))
            }
            for(var i = 0 ; i < self.chartDataL.count; i++){
                month.append(Int(self.chartDataL[i].month!))
            }
            if(self.chartDataL.count == 1){
                month.append(Int(self.chartDataL[0].month!)+1)
            }
            
//            sort the month
            month = self.bubbleSort(month)
            for(var i = 0; i < month.count; i++){
                data2.append(avg[Int(month[i]-6)])
            }
//            data2 = avg
            for(var i = 0; i < month.count; i++){
                xLabels.append(String(month[i]))
            }
        }
        
//        Drawing the chart
        lineChart = LineChart()
        lineChart.animation.enabled = true
        lineChart.area = true
        lineChart.x.labels.visible = true
        lineChart.x.grid.count = CGFloat(data.count)
        lineChart.y.grid.count = 5
        lineChart.x.labels.values = xLabels
        lineChart.y.labels.visible = true
        lineChart.addLine(data)
        lineChart.addLine(data2)
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.delegate = self
        self.chartView.addSubview(lineChart)
        
//        Drawing a y-axis label
        let test:UILabel = UILabel()
        test.text = "Age post-term in calendar months"
        test.translatesAutoresizingMaskIntoConstraints = false
        test.textAlignment = NSTextAlignment.Center
        test.textColor = UIColor.whiteColor()
        test.font = UIFont(name: "Gill Sans", size: 17)
        self.chartView.addSubview(test)
        
//        Drawing a intro label
        let info:UILabel = UILabel()
        info.text = "Date boxes on this page are per calendar month. To complete, use the EDD day. d.g If EDD = 23/1/10, enter 23/7/10 at 6m, 23/8 at 7m, 23/9 at 8m, etc"
        info.translatesAutoresizingMaskIntoConstraints = false
        info.textAlignment = NSTextAlignment.Center
        info.textColor = UIColor.whiteColor()
        info.numberOfLines = 0
        info.font = UIFont(name: "Gill Sans", size: 17)
        self.chartView.addSubview(info)
        
        views["test"] = test
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[test]-|", options: [], metrics: nil, views: views))
        views["info"] = info
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[info]-|", options: [], metrics: nil, views: views))
        views["chart"] = lineChart
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[chart]-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[label]-[chart(==200)]-[test]-[info]", options: [], metrics: nil, views: views))
        
    }
    
//    This algorithm is for sort the month and it's weight for the user
    func bubbleSort(var array:[Int]) -> [Int]{
        var temp:Int!
        for(var i = 0; i < array.count-1; i++){
            for(var j = 0; j < array.count-1; j++){
                if(array[j] > array[j+1]){
                    temp = array[j]
                    array[j] = array[j+1]
                    array[j+1] = temp
                }
            }
        }
        return array
    }
    
    
    
//    Fetch the local chart data
    func fetchLocalData(){
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let request = NSFetchRequest(entityName: "BabyChart")
        var result:[AnyObject]?
        do{
            result = try context.executeFetchRequest(request)
        }catch _{
            result = nil
        }
        if(result != nil)
        {
            if(result?.count == 0){
                let warning = UIAlertController(title: "Please add data for your baby!", message: "This data is the sample data", preferredStyle: .Alert)
                let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
                warning.addAction(cancel)
                warning.addAction(ok)
                self.presentViewController(warning, animated: true, completion: nil)
            }else{
                print("FetchData: ",result?.count)
                self.chartDataL = result as! [BabyChart]
                print("Fetchdata")
            }
        }
    }
    
//    Go back to the main view Controller
    func back(sender: UIBarButtonItem) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let MainVC : UIViewController = storyBoard.instantiateViewControllerWithIdentifier("mainStoryBoard")
        self.navigationController?.pushViewController(MainVC, animated: true)
    }
    
    func addTapped(){
        performSegueWithIdentifier("addChartData", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didSelectDataPoint(x: CGFloat, yValues: Array<CGFloat>) {
        label.text = "Month: \(x+6)  Your baby: \(yValues[0]) kg  Avg: \(yValues[1]) kg"
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        if let chart = lineChart {
            chart.setNeedsDisplay()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

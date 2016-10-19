//
//  FiltersViewController.swift
//  GithubDemo
//
//  Created by Eden on 10/18/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String: AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SliderCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    weak var delegate : FiltersViewControllerDelegate?
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    var sliderStates = [Int:Float]()
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func onSearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        var filters = [String:AnyObject]()
        filters["minStars"] = sliderStates[0]
        delegate?.filtersViewController?(self, didUpdateFilters: filters)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("sliderCell") as! SliderCell
        
        cell.delegate = self
        
        cell.slider.value = sliderStates[indexPath.row] ?? 0
        
        cell.sliderLabel.text = "Minimum stars"
        return cell
        
    }
    
    func sliderCell(sliderCell: SliderCell, didChangeValue value: Float) {
        let indexPath = tableView.indexPathForCell(sliderCell)!
        sliderStates[indexPath.row] = value
    }
    
}

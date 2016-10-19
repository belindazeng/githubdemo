//
//  SliderCell.swift
//  GithubDemo
//
//  Created by Eden on 10/18/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

@objc protocol SliderCellDelegate {
    optional func sliderCell(sliderCell: SliderCell, didChangeValue value: Float)
    
}

class SliderCell: UITableViewCell {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderLabel: UILabel!
    
    weak var delegate: SliderCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func sliderValueChanged(sender: AnyObject) {
        delegate?.sliderCell?(self, didChangeValue: slider.value)
       
    }
    
}

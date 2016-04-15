/*
 * @authors                 Tyler Brockett, Shikha Mehta, Tam Le
 * @course                  ASU CSE 394
 * @project                 Group Project
 * @version                 April 15, 2016
 * @project-description     Allows users to track Geocaches
 * @class-name              NearbyFoodTableCell.swift
 * @class-description       Custom TableViewCell for the Restaurant TableView
 */

import UIKit
import Foundation

class NearbyFoodTableCell: UITableViewCell {
    
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var restaurantName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

/*
 * @authors                 Tyler Brockett, Shikha Mehta, Tam Le
 * @course                  ASU CSE 394
 * @project                 Group Project
 * @version                 April 15, 2016
 * @project-description     Allows users to track Geocaches
 * @class-name              LogTableCell.swift
 * @class-description       Custom TableViewCell for the Logs TableView
 */

import UIKit
import Foundation

class LogTableCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

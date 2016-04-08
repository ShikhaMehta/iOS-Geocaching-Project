//
//  LogEntryViewController.swift
//  Appa
//
//  Created by Tyler Brockett on 4/6/16.
//  Copyright © 2016 ASU. All rights reserved.
//

import UIKit
import Foundation

class LogEntryViewController: UIViewController {
    var log:Log?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var itemTakenLabel: UILabel!
    @IBOutlet weak var itemLeftLabel: UILabel!
    @IBOutlet weak var notesTV: UITextView!
    
    let formatter = NSDateFormatter()
    
    override func viewDidLoad() {
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .MediumStyle
        
        if log != nil {
            nameLabel.text = log!.name
            timestampLabel.text = formatter.stringFromDate(log!.timestamp!)
            itemTakenLabel.text = log!.itemTaken
            itemLeftLabel.text = log!.itemLeft
            notesTV.text = log!.notes
        } else {
            nameLabel.text = "Error"
            timestampLabel.text = "Error"
            itemTakenLabel.text = "Error"
            itemLeftLabel.text = "Error"
            notesTV.text = "Error"
        }
    }
}
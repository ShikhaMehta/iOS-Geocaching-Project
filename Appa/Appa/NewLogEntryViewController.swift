//
//  NewLogEntryViewController.swift
//  Appa
//
//  Created by Tyler Brockett on 4/6/16.
//  Copyright © 2016 ASU. All rights reserved.
//


import Foundation
import UIKit
import CoreData
import MapKit
import CoreLocation

class NewLogEntryViewController: UIViewController {
    
    //geocache that will have the log recorded to
    //this was pass from the SearchResultView
    var geocacheName: String? = nil
    // IBOutlets
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var itemTaken: UITextField!
    
    @IBOutlet weak var itemLeft: UITextField!
    
    @IBOutlet weak var notes: UITextView!
    
    // Initialize variables
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var log:Log? = nil
    // viewDidLoad() - Initialize the view and setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // show the keyboard
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        
        //hide the keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
    }
    
    // didReceiveMemoryWarning() - handles low memory conditions
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    // saveData() - save the data from the text field into core data
    
    @IBAction func saveData(sender: AnyObject) {
        if log == nil
        {
            let context = self.context
            let ent = NSEntityDescription.entityForName("Log", inManagedObjectContext: context)
            
            let nlog = Log(entity: ent!, insertIntoManagedObjectContext: context)
            nlog.name = name.text!
            nlog.itemTaken = itemTaken.text!
            nlog.itemLeft = itemLeft.text!
            nlog.notes = notes.text!
            
            //print(geocacheName)
            
            
            do {
                //try context.save()
                try nlog.managedObjectContext?.save()
            } catch _ {
            }
        } else {
            
            log!.name = name.text!
            log!.itemTaken = itemTaken.text!
            log!.itemLeft = itemLeft.text!
            log!.notes = notes.text!
            do {
                //try context.save()
                try log!.managedObjectContext?.save()
            } catch _ {
            }
        }
        navigationController!.popViewControllerAnimated(true)
    }
    // move the view upwards as keyboard appears
    func keyboardWillShow(sender: NSNotification) {
        if(self.view.frame.origin.y >= 0) {
            self.view.frame.origin.y -= 100
        }
    }
    
    // move the keyboard back as keyboard disapears
    func keyboardWillHide(sender: NSNotification) {
        if(self.view.frame.origin.y < 0) {
            self.view.frame.origin.y += 100
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        self.name.resignFirstResponder()
        self.itemLeft.resignFirstResponder()
        self.itemTaken.resignFirstResponder()
        self.notes.resignFirstResponder()
        
    }
    
}
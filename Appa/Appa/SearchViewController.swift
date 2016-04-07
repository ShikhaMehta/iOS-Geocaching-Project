//
//  SearchViewController.swift
//  Appa
//
//  Created by tam le on 3/25/16.
//  Copyright © 2016 ASU. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MapKit
import CoreLocation

class SearchViewController: UIViewController, UINavigationControllerDelegate, CLLocationManagerDelegate, NSFetchedResultsControllerDelegate {
    
    
    
    @IBOutlet weak var searchName: UITextField!
    
    // Initialize variables
    // Places - initialize core data entity
    var geocache:Geocache? = nil
    var context: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var dataViewController: NSFetchedResultsController = NSFetchedResultsController()
    
    //let conText = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    //var nItem:Places? = nil

    @IBAction func searchBegin(sender: UIButton) {
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        //let entityDescription = NSEntityDescription.entityForName("Places", inManagedObjectContext: context)
        let entityDescription = NSEntityDescription.entityForName("Geocache", inManagedObjectContext: self.context)
        
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try self.context.executeFetchRequest(fetchRequest)
            //print(result)
            
            if (result.count > 0) {
                for(var i = 0;i < result.count; i++)
                {
                    let person = result[i] as! NSManagedObject
                    
                    if let geocacheNameStr = person.valueForKey("name"), geocacheDescriptionStr = person.valueForKey("desc") {
                        
                        if geocacheNameStr.isEqual(self.searchName.text){
                            print("love")
                        }
                        
                        //print("\(placenameStr) \(placedescriptionStr)")
                    }
                    
                }
                //  print("1 - \(person)")
                
                
                // print("2 - \(person)")
            }
            
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
    }
    
    
    // getFetchResultsController() - get results returned from a Core Data fetch request
    func getFetchResultsController() -> NSFetchedResultsController {
        
        dataViewController = NSFetchedResultsController(fetchRequest: listFetchRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        return dataViewController
        
    }
    
    // listFetchRequest() - list results returned from a Core Data fetch request
    func listFetchRequest() -> NSFetchRequest {
        
        let fetchRequest = NSFetchRequest(entityName: "Geocache")
        let sortDescripter = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescripter]
        return fetchRequest
        
    }
    
    // viewDidLoad() - loads view into the memory and does view initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataViewController = getFetchResultsController()
        
        dataViewController.delegate = self
        do {
            try dataViewController.performFetch()
        } catch _ {
        }
        
        // show the keyboard
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        
        //hide the keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
    }
    
    // didReceiveMemoryWarning() - handles low memory conditions
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        self.searchName.resignFirstResponder()
        
        
    }
    

    
}


//
//  ViewController.swift
//  Appa - It is a Geocaching Application where users can add geocache locations and other users can view location od these geocaches and log their visits.
//
//  Created by Shikha Mehta on 3/8/16.
//  Copyright © 2016 ASU. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, NSFetchedResultsControllerDelegate {

    // Initialize variables
    // Places - initialize core data entity
    var places:Places? = nil
    var context: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var dataViewController: NSFetchedResultsController = NSFetchedResultsController()

    // getFetchResultsController() - get results returned from a Core Data fetch request
    func getFetchResultsController() -> NSFetchedResultsController {

        dataViewController = NSFetchedResultsController(fetchRequest: listFetchRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)

        return dataViewController

    }

    // listFetchRequest() - list results returned from a Core Data fetch request
    func listFetchRequest() -> NSFetchRequest {

        let fetchRequest = NSFetchRequest(entityName: "Places")
        let sortDescripter = NSSortDescriptor(key: "placeName", ascending: true)
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

    }

    // didReceiveMemoryWarning() - handles low memory conditions
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "search"){
            if let viewController: HomeViewController = segue.destinationViewController as? HomeViewController {
                // do something here
                
            }
        }
    }


}


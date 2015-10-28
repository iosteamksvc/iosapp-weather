//
//  FavoritePlaceTableViewController.swift
//  kzWeather
//
//  Created by Vinh Hua on 10/22/15.
//  Copyright © 2015 iosteamksvc. All rights reserved.
//

import UIKit

class FavoritePlaceTableViewController: UITableViewController {
    // MARK: Properties
    var favoritePlaces = [FavoritePlace]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Use the edit button item provided by the table view controller.
        navigationItem.rightBarButtonItem = editButtonItem()
        
        // Load the sample data.
        if let savedFavoritePlaces = loadFavoritePlaces() {
            favoritePlaces += savedFavoritePlaces
        }
        
        // Set navigation bar style
        navigationController!.navigationBar.barTintColor = Constant.NAVIGATION_BAR_COLOR
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : Constant.NAVIGATION_TITLE_TEXT_COLOR]

    }
    
    /*
    func loadSampleFavoritePlace(){
        let place1 = FavoritePlace(name: "Place Test 1", latitude: 0 , longtitude: 0)!
        
        let place2 = FavoritePlace(name: "Place Test 2", latitude: 0 , longtitude: 0)!
        
        let place3 = FavoritePlace(name: "Place Test 3", latitude: 0 , longtitude. 0)!
        
        favoritePlaces += [place1, place2, place3]
        
    }
    */

    // MARK: NSCoding
    func saveFavoritePlaces() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(favoritePlaces, toFile: FavoritePlace.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save favorite place...")
        }
        print(FavoritePlace.ArchiveURL.path)
    }
    
    func loadFavoritePlaces() -> [FavoritePlace]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(FavoritePlace.ArchiveURL.path!) as? [FavoritePlace]
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "rowSelectNavigate" {
            print("Go to this event")
            let mainViewController = segue.destinationViewController as! ViewController
            // Get the cell that generated this segue.
            if let selectedPlaceCell = sender as? FavoritePlaceTableViewCell {
                
                let indexPath = tableView.indexPathForCell(selectedPlaceCell)!
                let selectedFavoritePlace = favoritePlaces[indexPath.row]
                mainViewController.currentPlace = selectedFavoritePlace
                print("mainViewController.currentPlace.Name" + mainViewController.currentPlace!.name)
            }
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePlaces.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "FavoritePlaceTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! FavoritePlaceTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let favoritePlace = favoritePlaces[indexPath.row]
        
        cell.nameLabel.text = favoritePlace.name
        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            favoritePlaces.removeAtIndex(indexPath.row)
            
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(favoritePlaces, toFile: FavoritePlace.ArchiveURL.path!)
            
            if !isSuccessfulSave {
                print("Failed to save favorite place...")
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

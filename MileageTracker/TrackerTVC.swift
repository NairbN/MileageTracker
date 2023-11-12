//
//  TrackerTVC.swift
//  MileageTracker
//
//  Created by Brian Nguyen on 6/29/23.
//

import UIKit
import CoreData


class TrackerTVC: UITableViewController, NSFetchedResultsControllerDelegate {

//    let trackerEntities = [
//        TrackerEntity("Foothill College","De Anza College",Calendar.current),
//        TrackerEntity("Independence Highschool","De Anza College",Calendar.current)
//    ]
    
    var TrackerEntities : [TrackerMO] = []
    
    var fetchedResultsController : NSFetchedResultsController<TrackerMO>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest : NSFetchRequest<TrackerMO> = TrackerMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateAndTime", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
            
            do{
                try fetchedResultsController.performFetch()
                if let fetchedObjects = fetchedResultsController.fetchedObjects {
                    TrackerEntities = fetchedObjects
                }
            } catch {
                print(error)
            }
            if TrackerEntities.count == 0 {
                let seedTrackerEntities = [
                    TrackerEntity("Foothill College","De Anza College",Date()),
                    TrackerEntity("Independence Highschool","De Anza College",Date())
                ]
                
                for seedEntity in seedTrackerEntities{
                    let seedTracker = TrackerMO(context: context)
                    seedTracker.fromAddress = seedEntity.fromAddress
                    seedTracker.toAddress = seedEntity.toAddress
                    seedTracker.dateAndTime = seedEntity.dateAndTime
                    
                    appDelegate.saveContext()
                }
            }
        }
        

        
        
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath:IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let insertIndexPath = newIndexPath {
                tableView.insertRows(at: [insertIndexPath], with: .fade)
            }
            
        case .delete:
            if let deleteIndexPath = newIndexPath {
                tableView.deleteRows(at: [deleteIndexPath], with: .fade)
            }
            
        case .update:
            if let changeIndexPath = indexPath{
                tableView.reloadRows(at: [changeIndexPath], with: .fade)
            }
            
        default:
            tableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects{
            TrackerEntities = fetchedObjects as! [TrackerMO]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0;//Choose your custom row height
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return TrackerEntities.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TrackerCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TrackerTableCell
        
        var cellItem : TrackerMO
        cellItem = TrackerEntities[indexPath.row]

        // Configure the cell...
        cell.fromAddressLabel?.text = cellItem.fromAddress
        cell.toAddressLabel?.text = cellItem.toAddress
        cell.dateAndTimeLabel?.text = cellItem.dateAndTime?.description

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
                let context = appDelegate.persistentContainer.viewContext
                let deleteItem = self.fetchedResultsController.object(at: indexPath)
                context.delete(deleteItem)
                appDelegate.saveContext()
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTracker" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let detailVC = segue.destination as! TrackerCellVC
                detailVC.fromAddress = TrackerEntities[indexPath.row].fromAddress
                detailVC.toAddress = TrackerEntities[indexPath.row].toAddress
                detailVC.dateAndTime = TrackerEntities[indexPath.row].dateAndTime
            }
        }
    }

}

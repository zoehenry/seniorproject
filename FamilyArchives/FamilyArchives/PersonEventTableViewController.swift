//
//  PersonEventTableViewController.swift
//  FamilyArchives
//
//  Created by Zoe Henry on 4/15/19.
//  Copyright © 2019 Zoe Henry. All rights reserved.
//

import UIKit
import os.log

class PersonEventTableViewController: UITableViewController, UISearchBarDelegate {
    
    //MARK: Properties
    
    var personEvents = [PersonEvent]()
    @IBOutlet weak var searchBar: UISearchBar!
    var searchPersonEvents = [PersonEvent]()
    var searching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.tableView.backgroundColor = UIColor(red: 0.9882, green: 0.9569, blue: 0.851, alpha: 1.0)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 1, green: 0.4784, blue: 0.3529, alpha: 1.0)
        
        /*if let savedPersonEvents = loadPersonEvents() {
            personEvents += savedPersonEvents
        }*/
        let savedPersonEvents = loadPersonEvents()
        
        if savedPersonEvents?.count ?? 0 > 0 {
            personEvents = savedPersonEvents ?? [PersonEvent]()
        }
        else {
            // load sample data
            loadSamplePersonEvent()
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchPersonEvents.count
        } else {
            return personEvents.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "PersonEventTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PersonEventTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PersonEventTableViewCell.")
        }
        
        let personEvent:PersonEvent
        
        if searching {
            personEvent = searchPersonEvents[indexPath.row]
        } else {
            personEvent = personEvents[indexPath.row]
        }
        
        cell.backgroundColor = UIColor(red: 0.9882, green: 0.9569, blue: 0.851, alpha: 1.0)
        cell.personEventNameLabel.text = personEvent.name
        cell.personEventNameLabel.textColor = UIColor(red: 0, green: 0.6667, blue: 0.6275, alpha: 1.0)
        cell.photoImageView.image = personEvent.photo
        cell.personEventDescriptionTextField.text = personEvent.personEventDescription
        cell.personEventDescriptionTextField.textColor = UIColor(red: 0.5216, green: 0.7686, blue: 0.7333, alpha: 1.0)
        cell.personEventDescriptionTextField.isUserInteractionEnabled = false

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            personEvents.remove(at: indexPath.row)
            
            // Save personEvents
            savePersonEvents()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
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
        super.prepare(for: segue, sender: sender)
//        let selectedPersonEvent: PersonEvent
//        if let selectedPersonEventCell = sender as? PersonEventTableViewCell {
//            if let indexPath = tableView.indexPath(for: selectedPersonEventCell) {
//                selectedPersonEvent = personEvents[indexPath.row]
//                if selectedPersonEvent.audioURL == URL(string: "") {
//                    // PhotoViewController
//                    segueType = "ShowPhotoDetail"
//                } else {
//                    // AudioViewController
//                    segueType = "ShowAudioDetail"
//                }
//            }
//        }
        
        switch(segue.identifier ?? "") {
            case "AddPhoto":
                os_log("Adding a new personEvent.", log: OSLog.default, type: .debug)
            case "AddAudio":
                os_log("Adding a new personEvent.", log: OSLog.default, type: .debug)
            case "ShowPhotoDetail":
                guard let detailViewController = segue.destination as? PhotoViewController else {
                        fatalError("Unexpected destination: \(segue.destination)")
                }

                guard let selectedPersonEventCell = sender as? PersonEventTableViewCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }

                guard let indexPath = tableView.indexPath(for: selectedPersonEventCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }

                let selectedPersonEvent = personEvents[indexPath.row]
                detailViewController.personEvent = selectedPersonEvent
            
            case "ShowAudioDetail":
                guard let detailViewController = segue.destination as? AudioViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }

                guard let selectedPersonEventCell = sender as? PersonEventTableViewCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }

                guard let indexPath = tableView.indexPath(for: selectedPersonEventCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                
                let selectedPersonEvent = personEvents[indexPath.row]
                detailViewController.personEvent = selectedPersonEvent
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPersonEvent = personEvents[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)

        print(self)
        if selectedPersonEvent.audioURL == URL(string: "") {
            // PhotoViewController
            searching = false
        } else {
            // AudioViewController
            performSegue(withIdentifier: "ShowAudioDetail", sender: cell)
            searching = false
        }
    }
 
    
    //MARK: Actions
    @IBAction func unwindToPersonEventList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? PhotoViewController, let personEvent = sourceViewController.personEvent {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing person or event.
                personEvents[selectedIndexPath.row] = personEvent
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new person or event.
                let newIndexPath = IndexPath(row: personEvents.count, section: 0)
                personEvents.append(personEvent)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            //Save the personEvents
            savePersonEvents()
        } else if let sourceViewController = sender.source as? AudioViewController, let personEvent = sourceViewController.personEvent {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing person or event.
                personEvents[selectedIndexPath.row] = personEvent
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new person or event.
                let newIndexPath = IndexPath(row: personEvents.count, section: 0)
                personEvents.append(personEvent)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            //Save the personEvents
            savePersonEvents()
        }
       
    }
    
    //MARK: Private Methods
    private func loadSamplePersonEvent() {
        let photo = UIImage(named: "samplePhoto")
        let audioURL = URL(string: "")
        
        guard let personEvent1 = PersonEvent(name: "Summer Vacation 1", photo: photo, audioURL: audioURL, personEventDescription: "Example Event") else {
            fatalError("Unable to instantiate personEvent1")
        }
        
        guard let personEvent2 = PersonEvent(name: "Summer Vacation 2", photo: photo, audioURL: audioURL, personEventDescription: "duplicate") else {
            fatalError("Unable to instantiate personEvent2")
        }
        
        personEvents += [personEvent1, personEvent2]
    }
    
    /*
    private func savePersonEvents() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(personEvents, toFile: PersonEvent.ArchiveURL.path)
        
        
        if isSuccessfulSave {
            os_log("PersonEvents successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save personEvents...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadPersonEvents() -> [PersonEvent]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: PersonEvent.ArchiveURL.path) as? [PersonEvent]
    }
    */
    
    private func savePersonEvents() {
        
        let fullPath = getDocumentsDirectory().appendingPathComponent("personEvents")
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: personEvents, requiringSecureCoding: false)
            try data.write(to: fullPath)
            os_log("PersonEvents successfully saved.", log: OSLog.default, type: .debug)
        } catch {
            os_log("Failed to save personEvents...", log: OSLog.default, type: .error)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func loadPersonEvents() -> [PersonEvent]? {
        let fullPath = getDocumentsDirectory().appendingPathComponent("personEvents")
        if let nsData = NSData(contentsOf: fullPath) {
            do {
                
                let data = Data(referencing:nsData)
                
                if let loadedPersonEvents = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Array<PersonEvent> {
                    return loadedPersonEvents
                }
            } catch {
                print("Couldn't read file.")
                return nil
            }
        }
        return nil
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var personEventNames = [String]()
        searchPersonEvents = []
        for event in personEvents {
            personEventNames.append(event.name)
        }

        personEventNames = personEventNames.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
      
        for event in personEvents {
            if personEventNames.contains(event.name) {
                searchPersonEvents.append(event)
            }
        }
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }

}

//
//  NoteTableView.swift
//  coreDataExample
//
//  Created by Maximiliano Riquelme Vera on 10/02/2022.
//

import Foundation
import UIKit
import CoreData

var noteList = [Note]()

class NoteTableView: UITableViewController
{
    var firstLoad = true
    
    override func viewDidLoad() {
        if(firstLoad) {
            firstLoad = false
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            
            do {
                let results:NSArray = try context.fetch(request) as NSArray
                
                for result in results {
                    let note = result as! Note
                    noteList.append(note)
                }
            }
            catch
            {
                print("Fetch Failed")
            }
        }
    }
    
    func nonDeletedNotes() -> [Note] {
        var noDeleteNoteList = [Note]()
        
        for note in noteList
        {
            if(note.deletedDate == nil)
            {
                noDeleteNoteList.append(note)
            }
        }
        
        return noDeleteNoteList
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let noteCell = tableView.dequeueReusableCell(withIdentifier: "noteCellID", for: indexPath) as! NoteCell
        
        let thisNote: Note!
        thisNote = nonDeletedNotes()[indexPath.row]
        
        noteCell.titleLabel.text = thisNote.title
        noteCell.descriptionLabel.text = thisNote.desc
        
        return noteCell
    }
        
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nonDeletedNotes().count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "editNote", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editNote")
        {
            let indexPath = tableView.indexPathForSelectedRow!
            
            let noteDetail = segue.destination as? NoteDetailVC
            
            let selectedNote : Note!
            selectedNote = nonDeletedNotes()[indexPath.row]
            noteDetail!.selectedNote = selectedNote
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

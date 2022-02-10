//
//  ViewController.swift
//  coreDataExample
//
//  Created by Maximiliano Riquelme Vera on 04/02/2022.
//

import UIKit
import CoreData

class NoteDetailVC: UIViewController {

    //@IBOutlet var titleTextField: UILabel!
    //@IBOutlet var descriptionTextField: UILabel!
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    
    
    var selectedNote: Note? = nil
        
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if(selectedNote != nil)
        {
            titleTextField.text = selectedNote?.title
            descriptionTextView.text = selectedNote?.desc
        }
    }
    
    
    @IBAction func saveAction(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        if(selectedNote == nil)
        {
            let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)
            let newNote = Note(entity: entity!, insertInto: context)
            
            newNote.id = noteList.count as NSNumber
            newNote.title = titleTextField.text
            newNote.desc = descriptionTextView.text
            
            do {
                try context.save()
                
                noteList.append(newNote)
                navigationController?.popViewController(animated: true)
            } catch {
                print("Context save error.")
            }
        }
        else { //Else, edit note!
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            
            do {
                let results:NSArray = try context.fetch(request) as NSArray
                
                for result in results {
                    let note = result as! Note
                    
                    if(note == selectedNote) {
                        note.title = titleTextField.text
                        note.desc = descriptionTextView.text
                        
                        try context.save()
                        navigationController?.popViewController(animated: true)
                    }
                }
            }
            catch
            {
                print("Fetch Failed")
            }
        }
        
    }
    
    @IBAction func deleteNote(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        do {
            let results:NSArray = try context.fetch(request) as NSArray
            
            for result in results {
                let note = result as! Note
                
                if(note == selectedNote) {
                    note.deletedDate = Date()
                    
                    try context.save()
                    navigationController?.popViewController(animated: true)
                }
            }
        }
        catch
        {
            print("Fetch Failed")
        }
    }
    
}


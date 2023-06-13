import UIKit
import CoreData

class NoteDetailVC: UIViewController {
	@IBOutlet weak var titleTF: UITextField!
	@IBOutlet weak var descTV: UITextView!
    @IBOutlet weak var deleteBtn: UIButton!
	
	var selectedNote: Note? = nil
    var index: Int? = nil
	
	override func viewDidLoad() {
		super.viewDidLoad()
        // If edit note
		if(selectedNote != nil) {
			titleTF.text = selectedNote?.title
			descTV.text = selectedNote?.desc
            deleteBtn.isHidden = false
		}
	}

    // Save button action
	@IBAction func saveAction(_ sender: Any) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        // Add Note
		if(selectedNote == nil) {
			let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)
			let newNote = Note(entity: entity!, insertInto: context)
			newNote.id = noteList.count as NSNumber
			newNote.title = titleTF.text
			newNote.desc = descTV.text
            newNote.updatedAt = Date()

			do {
				try context.save()
				noteList.append(newNote)
				navigationController?.popViewController(animated: true)
			}
			catch {
				print("context save error")
			}
		}
        // Update Note
		else {
			let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
			do {
				let results:NSArray = try context.fetch(request) as NSArray
				for result in results {
					let note = result as! Note
					if(note == selectedNote) {
						note.title = titleTF.text
						note.desc = descTV.text
                        note.updatedAt = Date()

						try context.save()
						navigationController?.popViewController(animated: true)
					}
				}
			}
			catch {
				print("Fetch Failed")
			}
		}
        sortNote()
	}
	
    // Delete button action
	@IBAction func DeleteNote(_ sender: Any) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
		do {
            context.delete(selectedNote!)
            try context.save()
            if let index {
                noteList.remove(at: index)
            }
            navigationController?.popViewController(animated: true)
		}
		catch {
			print("Fetch Failed")
		}
	}
	
}


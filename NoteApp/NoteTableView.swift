import UIKit
import CoreData

// All notes
var noteList = [Note]()

// Sort notes by updated date
func sortNote() {
    noteList.sort(by: { $0.updatedAt > $1.updatedAt })
}

// Notes Table
class NoteTableView: UITableViewController {
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
                sortNote()
			}
			catch {
				print("Fetch Failed")
			}
		}
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let noteCell = tableView.dequeueReusableCell(withIdentifier: "noteCellID", for: indexPath) as! NoteCell
		
		let thisNote: Note!
        thisNote = noteList[indexPath.row]
        
        // Timestamp to dateformat
        let date = thisNote.updatedAt!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let dateString = dateFormatter.string(from: date as Date)
        
		noteCell.titleLabel.text = thisNote.title
		noteCell.descLabel.text = thisNote.desc
        noteCell.dateLabel.text = dateString
		
		return noteCell
	}
	
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteList.count
	}
	
	override func viewDidAppear(_ animated: Bool) {
		tableView.reloadData()
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.performSegue(withIdentifier: "editNote", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if(segue.identifier == "editNote") {
			let indexPath = tableView.indexPathForSelectedRow!
			
			let noteDetail = segue.destination as? NoteDetailVC
			
			let selectedNote: Note! = noteList[indexPath.row]
			noteDetail!.selectedNote = selectedNote
            noteDetail!.index = indexPath.row
			
			tableView.deselectRow(at: indexPath, animated: true)
		}
	}
}

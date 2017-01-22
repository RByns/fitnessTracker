//
//  fitnessTracker
//
//  Copyright © 2017 RByns. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

   
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var navbar: UINavigationBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listTableView.dataSource = self
        self.title = "Exercises"
        
        listTableView.delegate = self
        listTableView.dataSource = self
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Exercise")
        
        do {
            exercises = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print ("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var exercises: [NSManagedObject] = []
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let exercise = exercises[indexPath.row]
        let cell:CustomTableCell = listTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableCell
        
        cell.nameLabel?.text = exercise.value(forKeyPath: "name") as? String
        return cell
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?, cellForRowAt indexPath: IndexPath){
        if segue.identifier == "SaveWorkout" {
            let dvc = segue.destination as! DiaryViewController
           // dvc.woName = listTableView[listTableView.indexPathForSelectedRow?.row]
            var indexPath = self.listTableView.indexPathForSelectedRow
            
            let exercise = exercises[(indexPath?.row)!]
            dvc.data = (exercise.value(forKeyPath: "name") as? String)!
            
            
            dvc.woName = sender as! String
            //lvc.name = nameTextField.text!
        }
    }
    
    @IBAction func saveExercise(segue:UIStoryboardSegue){
        if let addExerciseViewController = segue.source as? AddExerciseViewController {
            
            let exName = addExerciseViewController.nameTextField.text!
            self.save(name: exName)
            
            //array.append(exName)
            listTableView.beginUpdates()
            listTableView.insertRows(at: [IndexPath(row: exercises.count-1, section: 0)], with: .automatic)
            listTableView.endUpdates()
        }
    }
    
    func save(name: String){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Exercise", in: managedContext)!
        
        let exercise = NSManagedObject(entity: entity, insertInto: managedContext)
        
        exercise.setValue(name, forKeyPath: "name")
        
        do {
            try managedContext.save()
            exercises.append(exercise)
        }catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    // @IBAction func buttonPressed(_ sender: UIButton) {
    //array.append("isthisthingon?")
    //diaryTableView.beginUpdates()
    //diaryTableView.insertRows(at: [IndexPath(row: array.count-1, section: 0)], with: .automatic)
    //diaryTableView.endUpdates()
    //   saveExercise(segue: )
    
    //}
    
    /*
     func tableView(_ diaryTableView: UITableView, didSelectRowAt indexPath: IndexPath){
     performSegue(withIdentifier:"SaveWorkout", sender: exercises[indexPath.row])
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
 */
    
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}

//
//  fitnessTracker
//
//  Copyright © 2017 RByns. All rights reserved.
//

import UIKit
import CoreData

class DiaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellReuseIdentifier = "cell"
    var woName = ""
    var data = ""
    
    let date = NSDate()
    
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var diaryTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
        override func viewDidLoad() {
        super.viewDidLoad()
            
        self.diaryTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        diaryTableView.delegate = self
        diaryTableView.dataSource = self
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        setDate()
        woName = self.data
    }
    
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Activity")
        
        do {
            activities = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print ("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var activities: [NSManagedObject] = []
    
    func setDate(){
        
        let dateString = "\(dateFormatter.string(from: Date() as Date))"
        navigationController?.navigationBar.topItem?.title = String(dateString)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ diaryTableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    return self.activities.count
    }
    
    func tableView(_ diaryTableView: UITableView, cellForRowAt indexPath : IndexPath) -> UITableViewCell{
        
        let activity = activities[indexPath.row]
        let cell:UITableViewCell = self.diaryTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        cell.textLabel?.text = activity.value(forKeyPath: "name") as? String
        return cell
    }
    
    @IBAction func saveWorkout(segue:UIStoryboardSegue){
        if segue.source is ListViewController {
            
            woName = self.data
            self.save(name: woName)
            
            //activities.append(woName)
            diaryTableView.beginUpdates()
            diaryTableView.insertRows(at: [IndexPath(row: activities.count-1, section: 0)], with: .automatic)
            diaryTableView.endUpdates()
        }
    }
    
    func save(name: String){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Activity", in: managedContext)!
        
        let exercise = NSManagedObject(entity: entity, insertInto: managedContext)
        
        exercise.setValue(name, forKeyPath: "name")
        
        do {
            try managedContext.save()
            activities.append(exercise)
        }catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    /*
    func tableView(_ diaryTableView: UITableView, didSelectRowAt indexPath: IndexPath){
       // let vcName = identities[indexPath.row]
       // let viewController = storyboard?.instantiateViewController(withIdentifier: vcName)
     //self.navigationController?.pushViewController(viewController!, animated:true)
        performSegue(withIdentifier:"addWorkout", sender: nil)
    }
 */
    
}


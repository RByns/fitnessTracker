//
//  fitnessTracker
//
//  Copyright © 2017 RByns. All rights reserved.
//

import UIKit

class AddExerciseViewController: UIViewController {
   
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if segue.identifier == "SaveExercise" {
            _ = segue.destination as! ListViewController
            }
    }

}

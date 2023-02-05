//
//  CreationViewController.swift
//  Flashcards
//
//  Created by Kavey Zheng on 2/4/23.
//

import UIKit

class CreationViewController: UIViewController {

    var flashcardsController: ViewController!
    
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerTextField: UITextField!
    
    var initialQuestion: String?
    var initialAnswer: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        questionTextField.text = initialQuestion
        answerTextField.text = initialAnswer
    }
    
    @IBAction func tapOnCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func tapOnDone(_ sender: Any) {
        // Get text from question and answer text fields
        let questionText = questionTextField.text
        let answerText = answerTextField.text
        
        // Check if empty
        if questionText == nil || answerText == nil || questionText!.isEmpty || answerText!.isEmpty {
            let alert = UIAlertController(title: "Missing Text", message: "Fill in both Question and Answer fields", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true)
        } else {
            // Check if flashcard already exists
            var isExisting = false
            if initialQuestion != nil { isExisting = true }
            
            // Call function to update the flashcard
            flashcardsController.updateFlashcard(question: questionText!, answer: answerText!, isExisting: isExisting)
            dismiss(animated: true)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ViewController.swift
//  Flashcards
//
//  Created by Kavey Zheng on 2/4/23.
//

import UIKit

struct Flashcard {
    var question: String
    var answer: String
}

class ViewController: UIViewController {
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var buttons: UIView!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var gameBtn: UIButton!
    // Array to hold flashcards
    var flashcards = [Flashcard]()
    // Current flashcard index
    var currentIdx = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        readSavedFlashcards()
        
        // Initialize default question if needed (no history of previous flashcards)
        if flashcards.count == 0 {
            updateFlashcard(question: "What is the capital of Brazil?", answer: "Brasilia", isExisting: false)
        } else {
            updateLabels()
            updateNextPrevButtons()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Flashcard starts small and invisible
        card.alpha = 0.0
        card.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        // Buttons start small and invisible
        buttons.alpha = 0.0
        buttons.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        
        // Animation
        UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.card.alpha = 1.0
            self.card.transform = CGAffineTransform.identity
        })
        UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.buttons.alpha = 1.0
            self.buttons.transform = CGAffineTransform.identity
        })
    }

    @IBAction func tapOnFlashcard(_ sender: Any) {
        flipFlashcard()
    }
    
    func flipFlashcard() {
        if (questionLabel.isHidden == false) {
            // Animate flashcard flip
            UIView.transition(with: card, duration: 0.35, options: .transitionFlipFromRight) {
                self.questionLabel.isHidden = true
            }
        } else {
            questionLabel.isHidden = false
            
            // Animate flashcard flip
            UIView.transition(with: card, duration: 0.35, options: .transitionFlipFromRight) {
                self.questionLabel.isHidden = false
            }
        }
    }
    
    func updateFlashcard(question: String, answer: String, isExisting: Bool) {
        let flashcard = Flashcard(question: question, answer: answer)
        
        if isExisting { flashcards[currentIdx] = flashcard }
        else {
            // Add flashcard to flashcard array
            flashcards.append(flashcard)
            
            // Log to console
            print("Added new flashcard")
            print("\(flashcards.count) flashcard(s)")
            
            // Update current index
            currentIdx = flashcards.count - 1
            print("Current Index: \(currentIdx)")
        }
        
        // Update buttons
        updateNextPrevButtons()
        
        // Update labels
        updateLabels()
        
        // Save to disk
        saveAllFlashcardsToDisk()
    }
    
    
    @IBAction func tapOnPrev(_ sender: Any) {
        // Increase current index
        currentIdx -= 1
        
        // Update labels
        // updateLabels()
        
        // Update buttons
        updateNextPrevButtons()
        print("current: \(currentIdx)")
        
        // Animate
        animateCardOut()
    }
    
    @IBAction func tapOnNext(_ sender: Any) {
        // Increase current index
        currentIdx += 1
        
        // Update labels updateLabels()
        
        // Update buttons
        updateNextPrevButtons()
        print("current: \(currentIdx)")
        
        // Animate
        animateCardOut()
    }
    
    func updateNextPrevButtons() {
        // Disable next button if at the end
        if currentIdx == flashcards.count - 1 {
            nextButton.isEnabled = false
            //nextButton.backgroundColor = .white
        } else {
            nextButton.isEnabled = true
            //nextButton.backgroundColor = .systemIndigo
        }

        // Disable prev button if at the beginning
        if currentIdx == 0 {
            prevButton.isEnabled = false
            //prevButton.backgroundColor = .white
        } else {
            prevButton.isEnabled = true
            //prevButton.backgroundColor = .systemIndigo
        }
    }
    
    func updateLabels() {
        // Get current flashcard
        let currentFlashcard = flashcards[currentIdx]
        
        // Update labels
        questionLabel.text = currentFlashcard.question
        answerLabel.text = currentFlashcard.answer
        
        questionLabel.isHidden = false
    }
    
    func animateCardOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -400.0, y: 0.0)
        }, completion: { finished in
            // Update labels
            self.updateLabels()
            
            // Run other animation
            self.animateCardIn()
        })
    }
    
    func animateCardIn() {
        // Start at right side of screen
        card.transform = CGAffineTransform.identity.translatedBy(x: 400.0, y: 0.0)
        
        // Animate card going back to original position
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    func deleteCurrentFlashcard() {
        // Delete current flashcard
        // Check if there is only one card left
        if (flashcards.count != 1) {
            flashcards.remove(at: currentIdx)
        }
        
        // Special case: Check if last card was deleted
        if currentIdx > flashcards.count - 1 {
            currentIdx = flashcards.count - 1
        }
        
        // Update labels
        updateLabels()
        
        // Update buttons
        updateNextPrevButtons()
        
        // Save to disk
        saveAllFlashcardsToDisk()
    }
    
    @IBAction func tapOnDelete(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Flashcard", message: "Are you sure you want to delete it?", preferredStyle: .actionSheet)
        
        // Create delete action
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in self.deleteCurrentFlashcard()
        }
        // Create cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // We know the destination of the segue is the Navigation Controller
        let navigationController = segue.destination as! UINavigationController
                
        // We know the Navigation Controller only contains a Creation View Controller
        let creationController = navigationController.topViewController as! CreationViewController
        
        if segue.identifier == "EditSegue" {
            creationController.initialQuestion = questionLabel.text
            creationController.initialAnswer = answerLabel.text
        }
        
        // We set the flashcardsController property to self
        creationController.flashcardsController = self
    }
    
    func saveAllFlashcardsToDisk() {
        // From flashcard array to dictionary array
        let dictionaryArray = flashcards.map {
            (card) -> [String: String] in return ["question": card.question, "answer": card.answer]
        }
        
        // Save array on disk using Userdefaults
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        
        // Log to console
        print("Flashcards saved to UserDefaults")
    }
    
    func readSavedFlashcards() {
        // Read dictionary array from disk (if any)
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]] {
            // Inside if statement means there is definitely array
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!) }
            
            // Put all cards into flashcards array
            flashcards.append(contentsOf: savedCards)
         }
    }
    
    
    @IBAction func didTapPlay(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gameController = storyboard.instantiateViewController(withIdentifier: "Game_Controller")
        
        gameController.loadViewIfNeeded()        
        self.present(gameController, animated: true, completion: nil)
    }
    
}


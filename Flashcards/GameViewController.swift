//
//  GameViewController.swift
//  Flashcards
//
//  Created by Kavey Zheng on 2/4/23.
//

import UIKit

class GameViewController: UIViewController {
    let fruits: [String] = [
        "🍌", "🍎", "🍏", "🍑", "🍆", "🥦", "🥑", "🍋", "🍍", "🍒"
    ]
    var labels: [UILabel] = []
    var firstLabel: UILabel?
    var secondLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        createLabel()
    }
    
    func createLabel() {
        let labelWidth: CGFloat = 60
        let labelHeight: CGFloat = 60
        let numberOfRows = 4
        let numberOfColumns = 5
        let spacing: CGFloat = 10
        let offset: CGFloat = -60
        var usedNumbers: [String: Int] = [:]
        
        for row in 0..<numberOfRows {
            for column in 0..<numberOfColumns {
                var fruit = fruits.randomElement()
                while usedNumbers[fruit!] == 2 {
                    fruit = fruits.randomElement()
                }
                usedNumbers[fruit!] = (usedNumbers[fruit!] ?? 0) + 1
                let x = (view.frame.width - CGFloat(numberOfColumns) * labelWidth - CGFloat(numberOfColumns - 1) * spacing) / 2 + CGFloat(column) * (labelWidth + spacing)
                let y = (view.frame.height - CGFloat(numberOfRows) * labelHeight - CGFloat(numberOfRows - 1) * spacing) / 2 + CGFloat(row) * (labelHeight + spacing) + offset
                let label = UILabel(frame: CGRect(x: x, y: y, width: labelWidth, height: labelHeight))
                
                label.backgroundColor = .systemIndigo
                label.text = fruit
                label.textAlignment = .center
                label.font = label.font.withSize(31)
                label.textColor = .clear
                
                labels.append(label)
                view.addSubview(label)
                
                label.isUserInteractionEnabled = true
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
                label.addGestureRecognizer(tapGesture)
            }
        }
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel else { return }
        if firstLabel == nil { // First Guess
            UIView.transition(with: label, duration: 0.35, options: .transitionFlipFromRight) {
                self.firstLabel = label
                label.textColor = .black
                label.isUserInteractionEnabled = false
            }
        } else if secondLabel == nil { // Second Guess
            UIView.transition(with: label, duration: 0.35, options: .transitionFlipFromRight) {
                self.secondLabel = label
                label.textColor = .black
                label.isUserInteractionEnabled = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if self.firstLabel?.text == self.secondLabel?.text { // Match
                    self.view.backgroundColor = .systemGreen
                    
                    self.firstLabel = nil
                    self.secondLabel = nil
                } else { // Not Match
                    self.view.backgroundColor = .systemRed
                    
                    self.firstLabel?.textColor = .clear
                    self.secondLabel?.textColor = .clear

                    self.firstLabel?.isUserInteractionEnabled = true
                    self.secondLabel?.isUserInteractionEnabled = true
                    self.firstLabel = nil
                    self.secondLabel = nil
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.view.backgroundColor = .white
                }
            }
            var allMatched = true
                for label in self.labels {
                    if !(label.textColor == .black) {
                        allMatched = false
                        break
                    }
                }
                if allMatched {
                    print("All labels have been revealed and matched!")
                    self.view.backgroundColor = .systemGreen
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
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

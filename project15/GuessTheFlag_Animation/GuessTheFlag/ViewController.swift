//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Arvin Shen on 11/9/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var numberOfQuestions = 1
    var bestScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        if let savedBest = defaults.object(forKey: "best") as? Data {
            do {
                bestScore = try JSONDecoder().decode(Int.self, from: savedBest)
            } catch {
                print("Failed to load best score")
            }
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearScore))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Best: \(bestScore)", style: .plain, target: self, action: #selector(showScore))
        
        countries += ["estonia", "france", "germany", "ireland",
                      "italy", "monaco", "nigeria", "poland",
                      "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        navigationItem.rightBarButtonItem?.title = "Best: \(bestScore)"
        
        title = "#\(numberOfQuestions)   |   " + countries[correctAnswer].uppercased() + "   |   Score: \(score)"
    }


    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        numberOfQuestions += 1
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            if countries[sender.tag].count == 2 {
                title = "Wrong! That's the flag of \(countries[sender.tag].uppercased())"
            } else {
                title = "Wrong! That's the flag of \(countries[sender.tag].capitalized)"
            }
            score -= 1
        }
        
        var ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)

        if numberOfQuestions > 10 {
            if score > bestScore {
                ac = UIAlertController(title: title, message: "New High Score of \(score)!!", preferredStyle: .alert)
                bestScore = score
                save()
                ac.addAction(UIAlertAction(title: "New Game", style: .default, handler: askQuestion))
            } else {
                ac = UIAlertController(title: title, message: "Your final score is \(score)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "New Game", style: .default, handler: askQuestion))
            }
            score = 0
            numberOfQuestions = 1
        } else {
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        }
        present(ac, animated: true)
    }
    
    @objc func showScore() {
        let vc = UIActivityViewController(activityItems: ["Best Score: \(bestScore)"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    @objc func clearScore() {
        let ac = UIAlertController(title: "Reset Best Score?", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Reset", style: .default) {
            [weak self] _ in
            self?.bestScore = 0
            self?.save()
            self?.navigationItem.rightBarButtonItem?.title = "Best: \(self!.bestScore)"
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func save() {
        if let savedData = try? JSONEncoder().encode(bestScore) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "best")
        } else {
            print("Failed to save best score")
        }
    }
}


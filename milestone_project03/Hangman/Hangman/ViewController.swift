//
//  ViewController.swift
//  Hangman
//
//  Created by Arvin Shen on 12/13/21.
//

import UIKit

class ViewController: UIViewController {
    var scoreLabel: UILabel!
    var lifeLabel: UILabel!
    var answerLabel: UILabel!
    let buttonsView = UIView()
    var letterButtons = [UIButton]()
    var movie = ""
    var movies = [Movie]()
    var answer = ""
    var guessedLetters: [String: Int] = [:]
    var wrongGuess = 0
    var correctGuess = 1
    
    let alphabet = UnicodeScalar("A").value...UnicodeScalar("Z").value
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    let startLife = 7
    lazy var life = startLife {
        didSet {
            lifeLabel.text = "Life: \(life)"
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        lifeLabel = UILabel()
        lifeLabel.translatesAutoresizingMaskIntoConstraints = false
        lifeLabel.text = "Life: \(startLife)"
        view.addSubview(lifeLabel)
        
        answerLabel = UILabel()
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.textAlignment = .center
        answerLabel.lineBreakMode = .byWordWrapping
        answerLabel.numberOfLines = 0
        answerLabel.text = "???????"
        answerLabel.font = UIFont.systemFont(ofSize: 44)
//        answerLabel.adjustsFontSizeToFitWidth = true
        answerLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answerLabel)
        
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
//        buttonsView.backgroundColor = .systemRed
        buttonsView.layer.borderWidth = 1
        buttonsView.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

            lifeLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            lifeLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            
            answerLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 0),
            answerLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0),
            answerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            answerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            answerLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answerLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            
            buttonsView.topAnchor.constraint(equalTo: answerLabel.bottomAnchor, constant: 20),
            buttonsView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            buttonsView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: 0.5),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
//        answerLabel.backgroundColor = .systemBlue
        
        let width = 62
        let height = 101
        
        for (index, letter) in alphabet.enumerated() {
            let letterButton = UIButton(type: .system)
            letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
            letterButton.layer.borderWidth = 1
            letterButton.layer.borderColor = UIColor.lightGray.cgColor
            
            letterButton.setTitle(String(UnicodeScalar(letter)!), for: .normal)
            letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            
            let frame = CGRect(x: (index % 6) * width, y: index / 6 * height, width: width, height: height)
            letterButton.frame = frame
            
            buttonsView.addSubview(letterButton)
            
            letterButtons.append(letterButton)
//            letterButtons[0].backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.5)
//            letterButtons[0].alpha = 0.5

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGame()
    }
    
    func loadGame() {
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            if let fileURL = Bundle.main.url(forResource: "movies-list", withExtension: "json") {
                if let data = try? Data(contentsOf: fileURL) {
                    self?.parse(json: data)
                    self?.movies.shuffle()
                    self?.answer = (self?.movies[0].title)!
                    for char in self!.answer {
                        if char.isLetter {
                            self?.movie.append("?")
                        } else{
                            self?.movie.append(char)
                        }
                    }
                }
            }
        }
        
        DispatchQueue.main.async {
            [weak self] in
            print(self?.answer as Any)
            self?.answerLabel.text = self?.movie
        }
    }

    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonData = try? decoder.decode(Movies.self, from: json) {
            movies = jsonData.movies.filter({$0.title.count <= 18})
        }
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        let letter = sender.titleLabel?.text ?? ""
        sender.isEnabled = false
        
        movie.removeAll()
        if answer.uppercased().contains(letter) {
            guessedLetters[letter] = correctGuess

            for char in answer {
                if char.isLetter {
                    if guessedLetters.keys.contains(String(char).uppercased()) {
                        movie.append(char)
                    } else {
                        movie.append("?")
                    }
                } else {
                    movie.append(char)
                }
            }
            score += 1
            answerLabel.text = movie
            
            if answerLabel.text == answer {
                let ac = UIAlertController(title: "You live another day!!", message: "Are you ready for the next game?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: nextGame))
//                ac.addAction(UIAlertAction(title: "No", style: .default))
                present(ac, animated: true)
            }
        } else {
            guessedLetters[letter] = wrongGuess
            life -= 1
            if life <= 0 {
                let ac = UIAlertController(title: "You've been hanged to death!!", message: "Would you to play again?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: newGame))
                present(ac, animated: true)
            }
        }
    }
    
    func nextGame(action: UIAlertAction) {
        score += life
        reset()

        if movies.count >= 1 {
            movies.remove(at: 0)
            answer = movies[0].title
            for char in answer {
                if char.isLetter {
                    movie.append("?")
                } else{
                    movie.append(char)
                }
            }
            print(answer)
            answerLabel.text = movie
        } else {
            let ac = UIAlertController(title: "Congratulations, you've beaten the game!!", message: "Would you like to start a new game?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: newGame))
            ac.addAction(UIAlertAction(title: "No", style: .default))
            present(ac, animated: true)
        }
        
    }
    
    func newGame(action: UIAlertAction) {
        score = 0
        reset()
        loadGame()
    }
    
    func reset() {
        life = startLife
        letterButtons.forEach({$0.isEnabled = true})
        guessedLetters.removeAll()
        movie.removeAll()
    }
}


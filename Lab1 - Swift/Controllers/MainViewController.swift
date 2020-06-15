//
//  ViewController.swift
//  Lab1 - Swift
//
//  Created by Jimmie Määttä on 2019-03-13.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit
import Foundation

struct ProgressCount {
    static var progressCount:Int = 0
    static var progress = Progress()
}

class MainViewController: UIViewController {
    
    
    // MARK: -- STATUS BAR
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: -- PROPERTIES
    
    private var stackMenu = UIStackView()
    
    // MARK: -- OUTLETS
    
    @IBOutlet weak var imageViewBackground: UIImageView!
    @IBOutlet weak var viewMenu: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var labelProgress: UILabel!
    
    
    // MARK: -- VIEW CONTROLLER
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !CardData.data.loadCards() {
            CardsAPI.collection.fetchData()
        }
        
        DeckData.data.loadDecks()
        Profile.data.loadData()
        
        setupMenu()
    }
    
    // MARK: -- SETUP MENU
    
    func setupMenu() {
        stackMenu = UIStackView(arrangedSubviews: createButtons(named: "NEWS", "DECKS", "SETTINGS"))
        stackMenu.translatesAutoresizingMaskIntoConstraints = false
        stackMenu.axis = .vertical
        stackMenu.spacing = 8
        stackMenu.distribution = .fillEqually
        
        viewMenu.addSubview(stackMenu)
        
        var delay = 0.0
        for button in stackMenu.arrangedSubviews {
            delay += 0.15
            UIView.animate(withDuration: 0.5, delay: delay, options: .curveEaseIn, animations: {
                button.alpha = 1
            })
        }
    }
    
    func createButtons(named: String...) -> [Button] {
        return named.map { name in
            let button = Button()
            button.setTitle(name, for: .normal)
            button.alpha = 0
            button.configure()
            
            button.addTarget(self, action: #selector(self.buttonPressed(sender:)), for: .touchUpInside)
            return button
        }
    }
    
    @objc func buttonPressed(sender: Button!) {
        if let title = sender.titleLabel!.text {
            performSegue(withIdentifier: title, sender: self)
        }
    }
    
    
    // MARK: -- SEGUE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "NEWS":
            let controller = segue.destination as! NewsViewController
            controller.modalTransitionStyle = .flipHorizontal
        case "DECKS":
            let controller = segue.destination as! DeckListViewController
            controller.modalTransitionStyle = .flipHorizontal
        case "SETTINGS":
            let controller = segue.destination as! SettingsViewController
            controller.modalPresentationStyle = .overCurrentContext
            controller.modalTransitionStyle = .crossDissolve
        default:
            return
        }
    }
    
}

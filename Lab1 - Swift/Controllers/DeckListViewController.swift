//
//  DecklistViewController.swift
//  Swift - Lab1
//
//  Created by Jimmie Määttä on 2019-03-23.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit

class DeckListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    // MARK: -- STATUS BAR
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: -- PROPERTIES
    
    private var backButton = Button()
    private var stackMenu = UIStackView()
    var searchResults:[Deck] = []
    
    
    // MARK: -- OUTLES
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var labelSearchDeck: UILabel!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var viewMenu: UIView!
    @IBOutlet weak var tableViewDecks: UITableView!
    
    
    // MARK: -- VIEW CONTROLLER
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableViewDecks.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelSearchDeck.font = labelSearchDeck.font.bold
        labelSearchDeck.shadowOffset = CGSize(width: 2, height: 2)
        labelSearchDeck.shadowColor = UIColor.black
        
        self.viewBackground.backgroundColor = UIColor.init(patternImage: UIImage(named: "DarkWood2")!)
        setupMenu()
    }
    
    
    // MARK: SETUP BUTTONS
    
    func setupMenu() {
        stackMenu = UIStackView(arrangedSubviews: createButtons(named: "BACK", "NEW DECK"))
        
        stackMenu.translatesAutoresizingMaskIntoConstraints = false
        stackMenu.axis = .horizontal
        stackMenu.spacing = 8
        stackMenu.distribution = .fillEqually
        
        viewMenu.addSubview(stackMenu)
    }
    
    func createButtons(named: String...) -> [Button] {
        return named.map { name in
            let button = Button()
            button.setTitle(name, for: .normal)
            button.configure()
            
            button.addTarget(self, action: #selector(self.buttonPressed(sender:)), for: .touchUpInside)
            return button
        }
    }
    
    @objc func buttonPressed(sender: Button!) {
        if let title:String = sender.titleLabel!.text {
            switch title {
            case "BACK":
                if let navController = self.navigationController {
                    navController.popViewController(animated: true)
                }
            case "NEW DECK":
                performSegue(withIdentifier: "NEWDECK", sender: self)
            default:
                print("No button found")
                return
            }
        }
    }
    
    
    // MARK: ACTIONS
    
    @IBAction func onEnterPressed(_ sender: UITextField) {
        searchResults.removeAll()
        
        if sender.text! != "" {
            searchResults = DeckData.data.decks.filter {
                $0.deckName.lowercased().contains(sender.text!.lowercased())
            }
        }
        
        print("\(sender.text!)")
        print("\(searchResults.count)")
        
        sender.resignFirstResponder()
        tableViewDecks.reloadData()
    }
    
    @IBAction func onSearchValueChanged(_ sender: UITextField) {
        searchResults.removeAll()
        
        if sender.text! != "" {
            searchResults = DeckData.data.decks.filter {
                $0.deckName.lowercased().contains(sender.text!.lowercased())
            }
        }
        
        print("\(sender.text!)")
        print("\(searchResults.count)")
        
        tableViewDecks.reloadData()
    }
    
    
    // MARK: -- TABLE VIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResults.count > 0 {
            return searchResults.count
        } else {
            return DeckData.data.decks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deckCell", for: indexPath) as! DeckListTableViewCell
        
        let deck:Deck?
        
        if searchResults.count > 0 {
            deck = searchResults[indexPath.item]
        } else {
            deck = DeckData.data.decks[indexPath.item]
        }
        
        cell.configure(with: deck!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let deck:Deck = DeckData.data.decks[indexPath.row]
        
        DeckTemplate.deckUUID = deck.deckUUID
        DeckTemplate.deckType = deck.deckType
        DeckTemplate.deckClass = deck.deckClass
        DeckTemplate.deckName = deck.deckName
        DeckTemplate.deckCards = deck.deckCards
        
        performSegue(withIdentifier: "EDITDECK", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            print("\(DeckData.data.decks[indexPath.item].deckName) removed")
            DeckData.data.decks.remove(at: indexPath.item)
            DeckData.data.saveDecks()
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    
    // MARK: -- SEGUE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EDITDECK" {
            print("Prepare for segue: EDIT DECK")
            let controller = segue.destination as! CardsViewController
            controller.setupVisibleCards()
            controller.view.layoutIfNeeded()
        }
    }
    
}

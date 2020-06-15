//
//  DeckViewController.swift
//  Lab1 - Swift
//
//  Created by Jimmie Määttä on 2019-03-27.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit


class DeckViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    private var buttons = UIStackView()
    
    var cardsDelegate:CardsDelegate?
    
    @IBOutlet weak var labelCurrentDeckName: UILabel!
    @IBOutlet weak var viewButtons: UIView!
    @IBOutlet weak var textFieldDeckName: UITextField!
    @IBOutlet weak var labelCardCount: UILabel!
    @IBOutlet weak var tableViewDeck: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelCurrentDeckName.font = labelCurrentDeckName?.font.bold
        labelCurrentDeckName.shadowOffset = CGSize(width: 2, height: 2)
        labelCurrentDeckName.shadowColor = UIColor.black
        
        setupButtons()
        updateOutlets()
        addTapGestureToView()
    }
    
    
    func addTapGestureToView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.textFieldDeckName?.resignFirstResponder()
    }
    
    
    // MARK: SETUP OUTLETS
    
    func updateOutlets() {
        self.labelCardCount.text = "\(DeckTemplate.deckCards.count)/30"
        if DeckTemplate.deckName != "" {
            self.textFieldDeckName.text = DeckTemplate.deckName
        } else {
            DeckTemplate.deckName = "\(DeckTemplate.deckType) \(DeckTemplate.deckClass)"
            self.textFieldDeckName.text = DeckTemplate.deckName
        }
        self.labelCurrentDeckName.text = self.textFieldDeckName.text
    }
    
    
    // MARK: -- SETUP BUTTONS
    
    func setupButtons() {
        buttons = UIStackView(arrangedSubviews: createButtons(named: "BACK", "SAVE"))
        
        buttons.translatesAutoresizingMaskIntoConstraints = false
        buttons.axis = .horizontal
        buttons.spacing = 8
        buttons.distribution = .fillEqually
        
        viewButtons.addSubview(buttons)
    }
    
    func createButtons(named: String...) -> [Button] {
        return named.map { name in
            let button = Button()
            button.setTitle(name, for: .normal)
            button.configure()
            if button.titleLabel?.text == "SAVE" {
                button.setTitleColor(UIColor(named: "colorGreen"), for: .normal)
                button.setTitleColor(UIColor(named: "colorGreenDark"), for: .highlighted)
            }
            
            button.addTarget(self, action: #selector(self.buttonPressed(sender:)), for: .touchUpInside)
            return button
        }
    }
    
    @objc func buttonPressed(sender: Button!) {
        if let title:String = sender.titleLabel!.text {
            switch title {
            case "BACK":
                dismiss(animated: true, completion: nil)
            case "SAVE":
                if !nameEmpty() {
                    if !deckExists() {
                        saveDeck()
                    } else {
                        showAlertDialog(title: "Overwrite", message: "Overwrite existing deck?")
                    }
                } else {
                    showAlertDialog(title: "Error", message: "Deck Name can not be empty!")
                }
            default:
                print("No button found")
                return
            }
        }
    }
    
    func nameEmpty() -> Bool {
        if textFieldDeckName.text != "" {
            return false
        } else {
            return true
        }
    }
    
    func deckExists() -> Bool {
        var doesExist:Bool = false
        for deck in DeckData.data.decks {
            if DeckTemplate.deckUUID == deck.deckUUID {
                doesExist = true
            }
        }
        return doesExist
    }
    
    
    // MARK: -- SAVE DECK
    
    func saveDeck() {
        let deck = Deck(deckUUID: DeckTemplate.deckUUID, deckType: DeckTemplate.deckType, deckClass: DeckTemplate.deckClass, deckName: DeckTemplate.deckName, deckCards: DeckTemplate.deckCards)
        DeckData.data.decks.append(deck)
        DeckData.data.saveDecks()
        showAlertDialog(title: "Saved", message: "\(DeckTemplate.deckName) has been saved")
    }
    
    func overwriteDeck() {
        for deck in DeckData.data.decks {
            if DeckTemplate.deckUUID == deck.deckUUID {
                deck.deckName = DeckTemplate.deckName
                deck.deckCards = DeckTemplate.deckCards
            }
        }
        DeckData.data.saveDecks()
        showAlertDialog(title: "Saved", message: "\(DeckTemplate.deckName) has been saved")
    }
    
    
    // MARK: -- ACTIONS
    
    @IBAction func onEnterPressed(_ sender: UITextField) {
        DeckTemplate.deckName = sender.text!
        self.labelCurrentDeckName.text = sender.text!
        sender.resignFirstResponder()
    }
    
    @IBAction func onDeckNameValueChanged(_ sender: UITextField) {
        DeckTemplate.deckName = sender.text!
        self.labelCurrentDeckName.text = sender.text!
    }
    
    
    // MARK: TABLE VIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DeckTemplate.deckCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deckCardCell") as! DeckTableViewCell
        
        let card:Card = DeckTemplate.deckCards[indexPath.item]
        cell.configure(with: card)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let card = DeckTemplate.deckCards[indexPath.item]
            if (cardsDelegate!.removeCardFromDeck(card: card)) {
                updateOutlets()
                print("This seems to work!")
            }
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    
    // MARK: -- ALERT
    
    func showAlertDialog(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        switch title {
        case "Overwrite":
            alert.addAction(UIAlertAction(title: "YES",
                                          style: .default,
                                          handler: {(alert: UIAlertAction!) in
                                            self.overwriteDeck()
            }))
            alert.addAction(UIAlertAction(title: "NO",
                                          style: .destructive,
                                          handler: nil))
        case "Saved":
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: {(alert: UIAlertAction!) in
                                            }))
        case "Error":
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: nil))
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
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

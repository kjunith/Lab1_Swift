//
//  CardsViewController.swift
//  Lab1 - Swift
//
//  Created by Jimmie Määttä on 2019-03-24.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit
import SDWebImage


class CardsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    // MARK: -- PROPERTIES
    
    private var buttons = UIStackView()
    
    let zoomView = UIView()
    let startingFrame = CGRect(x: 0, y: 0, width: 200, height: 100)
    
    @objc dynamic var cardCount:Int = 0
    @objc dynamic var deckName:String = ""
    private var visibleCards:[Card] = []
    private var searchResults:[Card] = []
    
    
    // MARK: -- OUTLETS
    
    @IBOutlet weak var viewButtons: UIView!
    @IBOutlet weak var labelDeckName: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var labelSearchCard: UILabel!
    @IBOutlet weak var textFieldSearchCard: UITextField!
    @IBOutlet weak var labelCardCount: UILabel!
    
    @IBOutlet weak var collectionViewCards: UICollectionView!
    
    
    // MARK: -- VIEW CONTROLLER
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionViewCards.layoutIfNeeded()
        collectionViewCards.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewBackground.backgroundColor = UIColor.init(patternImage: UIImage(named: "DarkWood")!)
        
        setupButtons()
        setupLabels()
        updateCardCount()
        updateDeckName()
        collectionViewCards.reloadData()
        
        addTapGestureToView()
    }
    
    
    // MARK: -- SETUP LABELS
    
    func setupLabels() {
        labelDeckName.text = "\(DeckTemplate.deckType) \(DeckTemplate.deckClass)"
        labelDeckName.font = labelDeckName.font.bold
        labelDeckName.shadowOffset = CGSize(width: 2, height: 2)
        labelDeckName.shadowColor = UIColor.black
        
        labelSearchCard.font = labelSearchCard.font.bold
        labelSearchCard.shadowOffset = CGSize(width: 2, height: 2)
        labelSearchCard.shadowColor = UIColor.black
        
        labelCardCount.font = labelCardCount.font.bold
        labelCardCount.shadowOffset = CGSize(width: 2, height: 2)
        labelCardCount.shadowColor = UIColor.black
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let animationHandler: ((UIViewControllerTransitionCoordinatorContext) -> Void) = { [weak self] (context) in
            self!.collectionViewCards.reloadData()
        }
        
        let completionHandler: ((UIViewControllerTransitionCoordinatorContext) -> Void) = { [weak self] (context) in
            self!.collectionViewCards.reloadData()
        }
        
        coordinator.animate(alongsideTransition: animationHandler, completion: completionHandler)
    }
    
    
    func addTapGestureToView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    
    // MARK: -- SETUP VISIBLE CARDS
    
    func setupVisibleCards() {
        visibleCards.removeAll()
        
        print("Deck Type: " + DeckTemplate.deckType)
        
        switch DeckTemplate.deckType {
        case "Standard":
            withStandardCards()
        case "Wild":
            withWildCards()
        default:
            break
        }
    }
    
    func withStandardCards() {
        visibleCards = CardsAPI.collection.standardCards
        print("Standard cards: \(visibleCards.count)")
        
        let playerClass = DeckTemplate.deckClass
        let neutral = "Neutral"
        
        visibleCards = visibleCards.filter {
            $0.playerClass == playerClass || $0.playerClass == neutral
        }
        print("Standard cards: \(visibleCards.count)")
    }
    
    func withWildCards() {
        visibleCards = CardsAPI.collection.allCards
        print("Wild cards: \(visibleCards.count)")
        
        let playerClass = DeckTemplate.deckClass
        let neutral = "Neutral"
        
        visibleCards = visibleCards.filter {
            $0.playerClass == playerClass || $0.playerClass == neutral
        }
        print("Wild cards: \(visibleCards.count)")
    }
    
    
    // MARK: -- UPDATE CARD COUNT / DECK NAME
    
    func updateCardCount() {
        self.cardCount = DeckTemplate.deckCards.count
        self.labelCardCount.text = "\(self.cardCount)/30"
    }
    
    func increaseCardCount() {
        self.cardCount += 1
        self.labelCardCount.text = "\(self.cardCount)/30"
    }
    
    func decreaseCardCount() {
        self.cardCount -= 1
        self.labelCardCount.text = "\(self.cardCount)/30"
    }
    
    func updateDeckName() {
        self.deckName = DeckTemplate.deckName
        self.labelDeckName.text = self.deckName
    }
    
    
    // MARK: -- SETUP BUTTONS
    
    func setupButtons() {
        buttons = UIStackView(arrangedSubviews: createButtons(named: "DECK", "BACK"))
        
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
            if button.titleLabel?.text == "BACK" {
                button.setTitleColor(UIColor(named: "colorRed"), for: .normal)
                button.setTitleColor(UIColor(named: "colorRedDark"), for: .highlighted)
            }
            
            button.addTarget(self, action: #selector(self.buttonPressed(sender:)), for: .touchUpInside)
            return button
        }
    }
    
    @objc func buttonPressed(sender: Button!) {
        if let title:String = sender.titleLabel!.text {
            switch title {
            case "DECK":
                performSegue(withIdentifier: "DECK", sender: self)
            case "BACK":
                showAlertDialog(title: "Warning", message: "Any unsaved changes will be lost!")
            default:
                print("No button found")
                return
            }
        }
    }
    
    
    // MARK: ADD / REMOVE CARD
    
    func addCard(card: Card) -> Bool {
        if !DeckTemplate.isFull {
            let cardId = card.cardId
            var cardIds:[String] = []
            
            for existingCard in DeckTemplate.deckCards {
                if existingCard.cardId == cardId {
                    cardIds.append(existingCard.cardId)
                }
            }
            
            if cardIds.count == 2 {
                print("Deck already contains two copies of \(card.name)")
                return false
            } else {
                DeckTemplate.deckCards.append(card)
                return true
            }
        } else {
            print("Deck is full")
            return false
        }
    }
    
    func removeCard(card: Card) -> Bool {
        if !DeckTemplate.deckCards.isEmpty {
            let cardId = card.cardId
            var cardPosition = Int()
            
            for i in 0..<DeckTemplate.deckCards.count {
                if DeckTemplate.deckCards[i].cardId == cardId {
                    cardPosition = i
                }
            }
            
            DeckTemplate.deckCards.remove(at: cardPosition)
            return true
        } else {
            print("Deck is empty")
            return false
        }
    }
    
    
    // MARK: ACTIONS
    
    @IBAction func onEnterPressed(_ sender: UITextField) {
        searchResults.removeAll()
        
        if sender.text! != "" {
            searchResults = visibleCards.filter {
                $0.name.lowercased().contains(sender.text!.lowercased())
            }
        }
        
        print("\(sender.text!)")
        print("\(searchResults.count)")
        
        sender.resignFirstResponder()
        collectionViewCards.reloadData()
    }
    
    @IBAction func onSearchEditingChanged(_ sender: UITextField) {
        searchResults.removeAll()
        
        if sender.text! != "" {
            searchResults = visibleCards.filter {
                $0.name.lowercased().contains(sender.text!.lowercased())
            }
        }
        
        print("\(sender.text!)")
        print("\(searchResults.count)")
        
        collectionViewCards.reloadData()
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.textFieldSearchCard?.resignFirstResponder()
    }
    
    
    // MARK: COLLECTION VIEW
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchResults.count > 0 {
            return searchResults.count
        } else {
            return visibleCards.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardsCollectionViewCell
        
        let card:Card?
        if searchResults.count > 0 {
            card = searchResults[indexPath.item]
        } else {
            card = visibleCards[indexPath.item]
        }
        cell.configure(with: card!)
        cell.cardsDelegate = self
        
        return cell
    }
    
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        let card:Card = visibleCards[indexPath.item]
    //        print("\(card.name) pressed")
    //        //        self.performSegue(withIdentifier: "CARDDETAILS", sender: card)
    //    }
    
    
    // MARK: -- SEGUE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //            if segue.identifier == "CARDDETAILS" {
        //                let controller = segue.destination as! CardDetailsViewController
        //
        //                controller.view.layoutIfNeeded()
        //                controller.modalPresentationStyle = .overCurrentContext
        //            }
        if segue.identifier == "DECK" {
            let controller = segue.destination as! DeckViewController
            controller.cardsDelegate = self
            controller.modalPresentationStyle = .overCurrentContext
        }
    }
    
    
    // MARK: -- ALERT
    
    func showAlertDialog(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "CANCEL",
                                      style: .cancel,
                                      handler: nil))
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .destructive,
                                      handler: {(alert: UIAlertAction!) in
                                        self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}


// MARK: -- EXTENSIONS

extension CardsViewController: CardsDelegate {
    
    func removeCardFromDeck(card: Card) -> Bool {
        if self.removeCard(card: card) {
            decreaseCardCount()
            self.collectionViewCards.reloadData()
            print("Removed \(card.name) from deck")
            return true
        } else {
            print("Couldn't remove card")
            return false
        }
    }
    
    func addCardToDeck(card: Card) -> Bool {
        if self.addCard(card: card) {
            increaseCardCount()
            self.collectionViewCards.reloadData()
            print("Added \(card.name) to deck")
            return true
        } else {
            print("Couldn't add card")
            return false
        }
    }
}

extension CardsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height:CGFloat = 0.0
        var width:CGFloat = 0.0
        
        if UIDevice.current.orientation.isLandscape {
            height = self.collectionViewCards.frame.height / 2
            width = self.view.frame.width / 6
        } else {
            height = self.collectionViewCards.frame.height / 3
            width = self.view.frame.width / 4
        }
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

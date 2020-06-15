//
//  DecksChooseClassViewController.swift
//  Lab1 - Swift
//
//  Created by Jimmie Määttä on 2019-03-17.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit


class ChooseClassViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var heroClasses:[String] = [
        "Warrior",
        "Shaman",
        "Rogue",
        "Paladin",
        "Hunter",
        "Druid",
        "Mage",
        "Warlock",
        "Priest"
    ]
    
    var classIcon = UIImage()
    var buttons = UIStackView()
    
    
    // MARK: -- OUTLETS
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var collectionViewClasses: UICollectionView!
    @IBOutlet weak var imageViewStandard: UIImageView!
    @IBOutlet weak var labelStandard: UILabel!
    @IBOutlet weak var imageViewWild: UIImageView!
    @IBOutlet weak var labelWild: UILabel!
    @IBOutlet weak var viewMenu: UIView!
    
    
    // MARK: -- VIEW CONTROLLER
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        imageViewStandard.alpha = 0.5
        imageViewWild.alpha = 0.5
        labelStandard.alpha = 0.5
        labelWild.alpha = 0.5
        DeckTemplate.deckClass = ""
        DeckTemplate.deckType = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewBackground.backgroundColor = UIColor.init(patternImage: UIImage(named: "DarkWood")!)
        
        setupMenu()
        setupLabels()
        resetDeckTemplate()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let animationHandler: ((UIViewControllerTransitionCoordinatorContext) -> Void) = { [weak self] (context) in
            self!.collectionViewClasses.reloadData()
        }
        
        let completionHandler: ((UIViewControllerTransitionCoordinatorContext) -> Void) = { [weak self] (context) in
            self!.collectionViewClasses.reloadData()
        }
        
        coordinator.animate(alongsideTransition: animationHandler, completion: completionHandler)
    }
    
    
    // MARK: RESET DECKTEMPLATE
    
    func resetDeckTemplate() {
        DeckTemplate.deckName = ""
        DeckTemplate.deckType = ""
        DeckTemplate.deckClass = ""
        DeckTemplate.deckCards = []
    }
    
    
    // MARK: -- SETUP LABELS
    
    func setupLabels() {
        self.labelStandard.font = self.labelStandard.font.bold
        self.labelStandard.shadowColor   = UIColor.black
        self.labelStandard.shadowOffset  = CGSize(width: 2, height: 2)
        
        self.labelWild.font = self.labelWild.font.bold
        self.labelWild.shadowColor   = UIColor.black
        self.labelWild.shadowOffset  = CGSize(width: 2, height: 2)
    }
    
    
    // MARK: -- SETUP STACKMENU
    
    func setupMenu() {
        buttons = UIStackView(arrangedSubviews: createButtons(named: "BACK", "CONTINUE"))
        
        buttons.translatesAutoresizingMaskIntoConstraints = false
        buttons.axis = .horizontal
        buttons.spacing = 8
        buttons.distribution = .fillEqually
        
        viewMenu.addSubview(buttons)
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
                self.navigationController?.popViewController(animated: true)
            case "CONTINUE":
                performSegue(withIdentifier: "CONTINUE", sender: self)
            default:
                print("No button found")
                return
            }
        }
    }
    
    
    // MARK: -- ACTIONS
    
    @IBAction func onStandardPressed(_ sender: Any) {
        DeckTemplate.deckType = "Standard"
        imageViewStandard.alpha = 1
        labelStandard.alpha = 1
        imageViewWild.alpha = 0.5
        labelWild.alpha = 0.5
    }
    
    @IBAction func onWildPressed(_ sender: Any) {
        DeckTemplate.deckType = "Wild"
        imageViewWild.alpha = 1
        labelWild.alpha = 1
        imageViewStandard.alpha = 0.5
        labelStandard.alpha = 0.5
    }
    
    
    // MARK: -- COLLECTION VIEW
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heroClasses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClassCell", for: indexPath) as! ChooseClassCollectionViewCell
        
        let heroClass = heroClasses[indexPath.item]
        let portrait = UIImage(named: "\(heroClass)")
        let heroPower = UIImage(named: "\(heroClass)HeroPower")
        
        cell.configure(with: portrait!, icon: heroPower!, name: heroClass)
        cell.alpha = 0.5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ChooseClassCollectionViewCell
        
        cell.alpha = 1
        
        DeckTemplate.deckClass = heroClasses[indexPath.item]
        classIcon = UIImage(named: "\(DeckTemplate.deckClass)HeroPower")!
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        cell!.alpha = 0.5
    }
    
    
    // MARK: -- SEGUE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CONTINUE" {
            if DeckTemplate.deckClass == "" {
                showAlertDialog(error: "Class")
                return
            } else if DeckTemplate.deckType == "" {
                showAlertDialog(error: "Type")
                return
            } else {
                let controller = segue.destination as! CardsViewController
                setupUUID()
                controller.setupVisibleCards()
                controller.view.layoutIfNeeded()
                
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func setupUUID() {
        let uuId = UUID()
        DeckTemplate.deckUUID = uuId.uuidString
        print("UUID: \(DeckTemplate.deckUUID)")
    }
    
    
    // MARK: -- ALERT
    
    func showAlertDialog(error:String) {
        let alert = UIAlertController(title: "Unable To Continue", message: "You need to choose \(error)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ChooseClassViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height:CGFloat = 0.0
        var width:CGFloat = 0.0
        
        if UIDevice.current.orientation.isLandscape {
            height = self.collectionViewClasses.frame.height / 1
            width = self.view.frame.width / 9
        } else {
            height = self.collectionViewClasses.frame.height / 3
            width = self.view.frame.width / 3
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

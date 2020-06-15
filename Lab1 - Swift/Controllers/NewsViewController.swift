//
//  NewsTableViewController.swift
//  Swift - Lab1
//
//  Created by Jimmie Määttä on 2019-03-22.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    // MARK: -- STATUS BAR
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: -- PROPERTIES
    
    private var stackMenu = UIStackView()
    
    let defaultUrl = "https://articles.hsreplay.net/rss/"
    let userDefaults = UserDefaults.standard
    
    private var feedItems:[FeedItem]?
    var feedUrl = String()
    
    
    // MARK: -- OUTLETS
    
    @IBOutlet weak var viewMenu: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewBackground: UIView!
    
    @IBOutlet weak var labelFeed: UILabel!
    @IBOutlet weak var textFieldFeedUrl: UITextField!
    @IBOutlet weak var tableViewFeed: UITableView!
    @IBOutlet weak var buttonReset: UIButton!
    
    @IBOutlet weak var buttonSave: UIButton!
    
    
    // MARK: -- VIEW CONTROLLER
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        labelFeed.font = labelFeed.font.bold
        labelFeed.shadowOffset = CGSize(width: 2, height: 2)
        labelFeed.shadowColor = UIColor.black
        
        loadFeedUrl()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewBackground.backgroundColor = UIColor.init(patternImage: UIImage(named: "DarkWood2")!)
        setupBackButton()
        addTapGestureToView()
    }
    
    
    func addTapGestureToView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.textFieldFeedUrl?.resignFirstResponder()
    }
    
    
    // MARK: SETUP BUTTON
    
    func setupBackButton() {
        let backButton = BackButton()
        backButton.configure()
        backButton.addTarget(self, action: #selector(self.backPressed(_:)), for: .touchUpInside)
        stackMenu.addArrangedSubview(backButton)
        
        stackMenu.translatesAutoresizingMaskIntoConstraints = false
        stackMenu.axis = .horizontal
        stackMenu.spacing = 8
        stackMenu.distribution = .fillEqually
        
        viewMenu.addSubview(stackMenu)
    }
    
    @objc func backPressed(_ sender: Button!) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: -- SAVE, LOAD & FETCH
    
    func saveFeedUrl() {
        userDefaults.set(feedUrl, forKey: SaveKeys.newsFeedKey)
        print("\(feedUrl) saved")
    }
    
    func loadFeedUrl() {
        if let savedFeedUrl:String = userDefaults.object(forKey: SaveKeys.newsFeedKey) as? String {
            feedUrl = savedFeedUrl
            self.textFieldFeedUrl.text = feedUrl
            fetchFeed()
            print("Feed loaded: \(savedFeedUrl)")
        } else {
            feedUrl = defaultUrl
            self.textFieldFeedUrl.text = feedUrl
            fetchFeed()
            print("No feed saved")
        }
    }
    
    func fetchFeed() {
        print("Fetcing from: \(feedUrl)")
        let feedParser = FeedParser()
        feedParser.parseFeed(url: feedUrl) { (rssItems) in
            self.feedItems = rssItems
            
            OperationQueue.main.addOperation {
                self.tableViewFeed.reloadSections(IndexSet(integer: 0), with: .fade)
            }
        }
    }
    
    
    // MARK: -- ACTIONS
    
    
    @IBAction func onEnterPressed(_ sender: UITextField) {
        if let newFeedUrl:String = sender.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            if newFeedUrl != "" {
                feedUrl = newFeedUrl
                self.textFieldFeedUrl.text = newFeedUrl
                print("New feed: \(newFeedUrl)")
                fetchFeed()
            } else {
                showAlertDialog()
            }
        }
        
        sender.resignFirstResponder()
    }
    
    @IBAction func onSavePressed(_ sender: Any) {
        if let newFeedUrl:String = self.textFieldFeedUrl.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            if newFeedUrl != "" {
                feedUrl = newFeedUrl
                self.textFieldFeedUrl.text = newFeedUrl
                print("New feed: \(newFeedUrl)")
                fetchFeed()
            } else {
                showAlertDialog()
            }
        }
        
        resignFirstResponder()
        saveFeedUrl()
    }
    
    @IBAction func onResetPressed(_ sender: Any) {
        feedUrl = defaultUrl
        self.textFieldFeedUrl.text = feedUrl
        print("FeedUrl reset")
    }
    
    
    // MARK: -- TABLE VIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let feedItems = feedItems else {
            return 0
        }
        return feedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! NewsTableViewCell
        
        if let item = feedItems?[indexPath.item] {
            cell.item = item
        }
        
        return cell
    }
    
    @objc func cellPressed(_ sender: Button!) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: -- ALERT
    
    func showAlertDialog() {
        let alert = UIAlertController(title: "Input Error", message: "Feed can not be empty!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

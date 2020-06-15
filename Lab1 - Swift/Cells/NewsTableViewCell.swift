//
//  NewsTableViewCell.swift
//  Lab1 - Swift
//
//  Created by Jimmie Määttä on 2019-03-14.
//  Copyright © 2019 MaeWik. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    
    // MARK: -- OUTLETS
    
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelPubDate: UILabel!
    
    // MARK: -- INIT
    
    var item: FeedItem! {
        didSet {
            configure()
        }
    }
    
    func configure() {
        self.backgroundColor = UIColor.clear
        cleanText()
        setupLabels()
    }
    
    private func cleanText() {
        let title = item.title.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
        labelTitle.text = title.replacingOccurrences(of: "&nbsp;", with: " ", options: String.CompareOptions.regularExpression, range: nil)
        
        let description = item.description.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
        labelDescription.text = description.replacingOccurrences(of: "&nbsp;", with: " ", options: String.CompareOptions.regularExpression, range: nil)
        
        let pubDate = item.pubDate.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
        labelPubDate.text = pubDate.replacingOccurrences(of: "&nbsp;", with: " ", options: String.CompareOptions.regularExpression, range: nil)
    }
    
    private func setupLabels() {
        labelTitle.textColor = UIColor(named: "colorYellow")
        labelTitle.font = labelTitle.font.bold
        labelTitle.numberOfLines = 2
        
        labelDescription.textColor = UIColor.white
        labelDescription.numberOfLines = 0
        labelDescription.textAlignment = .justified
        
        labelPubDate.textColor = UIColor.lightGray
        labelPubDate.font = labelPubDate.font.italic
        labelPubDate.numberOfLines = 1
        labelPubDate.textAlignment = .right
    }
    
}

//
//  MovieInfoLabel.swift
//  MovieApp
//
//  Created by Münevver Elif Ay on 9.11.2023.
//

import UIKit

class MovieInfoLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        textAlignment = .left
        text = "Not Found"
        numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAttributedText(title: String, value: String) {
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: AppFonts.infoBlackFont as Any,
                .foregroundColor: UIColor.movieInfoTitle
            ]
            
            let valueAttributes: [NSAttributedString.Key: Any] = [
                .font: AppFonts.desRegularFont as Any,
                .foregroundColor: UIColor.moviePrimary
            ]
            
            let attributedText = NSMutableAttributedString()
            
            let titleString = NSAttributedString(string: title, attributes: titleAttributes)
            let valueString = NSAttributedString(string: value, attributes: valueAttributes)
            
            attributedText.append(titleString)
            attributedText.append(NSAttributedString(string: " : "))
            attributedText.append(valueString)
            
            self.attributedText = attributedText
      
    }
}

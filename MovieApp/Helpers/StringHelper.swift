//
//  StringHelper.swift
//  MovieApp
//
//  Created by Münevver Elif Ay on 8.11.2023.
//

import UIKit

class StringHelper {
    static let shared = StringHelper()
    func createCustomAttributedString(iconColor: UIColor, labelColor: UIColor, icon: String, font: UIFont, text: String) -> NSAttributedString {
        let iconString = NSMutableAttributedString(string: icon, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: iconColor])
        let textString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: labelColor])
        iconString.append(textString)
        return iconString
    }
}

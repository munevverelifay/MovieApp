//
//  TypeView.swift
//  MovieApp
//
//  Created by Münevver Elif Ay on 7.11.2023.
//

import UIKit

class GenreView : UIView {
 
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFonts.typeBoldFont
        label.textAlignment = .center
        label.textColor = .typeLabel
        label.numberOfLines = 0
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .typeView
        setupUI()
        self.layer.cornerRadius = 10
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        self.backgroundColor = .typeView
        self.layer.cornerRadius = 10
    }
    
    private func setupUI() {
        addSubview(genreLabel)
        NSLayoutConstraint.activate([
            genreLabel.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            genreLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
            genreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            genreLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
        
    }
    func configure(with labelText: String) {
        genreLabel.text = labelText
        setNeedsLayout()
    }
    
    
}

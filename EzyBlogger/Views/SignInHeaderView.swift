//
//  SignInHeaderView.swift
//  EzyBlogger
//
//  Created by M. Ahmad Ali on 22/06/2023.
//

import UIKit

class SignInHeaderView: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemPink
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.text = "Explore Millions of Articles!"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(label)
        addSubview(imageView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        let size: CGFloat = screenWidth / 4
        imageView.frame = CGRect(x: (screenWidth-size)/2, y: 10, width: size, height: size)
        label.frame = CGRect(x: 20, y: size-(3.08*size), width: screenWidth-40, height: screenHeight-size-30)
    }

}

//
//  CustomBtn.swift
//  NaverShopping
//
//  Created by youngkyun park on 1/15/25.
//

import UIKit

class CustomBtn: UIButton {
    
    init(title: String, status: Bool, tagNum: Int) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        if status {
            setTitleColor(.black, for: .normal)
            backgroundColor = .white
        } else {
            setTitleColor(.white, for: .normal)
            backgroundColor = .black
        }
        tag = tagNum
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        titleLabel?.font = .systemFont(ofSize: 15)
        
        
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    
    init(imgName: String){
        super.init(frame: .zero)
        setImage(UIImage(systemName: imgName), for: .normal)
        setTitleColor(.black, for: .normal)
        backgroundColor = .clear
        tintColor = .black
    }
    
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
}

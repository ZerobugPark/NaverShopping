//
//  SearchView.swift
//  NaverShopping
//
//  Created by youngkyun park on 2/6/25.
//

import UIKit

class SearchView: BaseView {

    let searchBar = UISearchBar()
    let bgImage = UIImageView()
    
    
    override func configureHierarchy() {
        self.addSubview(searchBar)
        self.addSubview(bgImage)

    }
    
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(4)
            
        }
        bgImage.snp.makeConstraints { make in
            make.center.equalTo(self.safeAreaLayoutGuide)
        }
        

    }
    
    override func configureView() {
        let placeholder = "브랜드, 상품, 프로필, 태그 등"
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: placeholder,attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        searchBar.layer.borderWidth = 10
        searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.1098035797, green: 0.1098041758, blue: 0.122666128, alpha: 1)
        searchBar.searchTextField.layer.cornerRadius = 10
        searchBar.searchTextField.clipsToBounds = true
        searchBar.searchTextField.leftView?.tintColor = .lightGray
        searchBar.searchTextField.tokenBackgroundColor = .white
        searchBar.searchTextField.textColor = .white
        searchBar.searchBarStyle = .minimal
       

        bgImage.image = UIImage(named: "flex")
        backgroundColor = .black

    }

}

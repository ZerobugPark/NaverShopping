//
//  ViewController.swift
//  NaverShopping
//
//  Created by youngkyun park on 1/15/25.
//

import UIKit

import Alamofire
import SnapKit


class ViewController: UIViewController {

    let searchBar = UISearchBar()
    let bgImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfigure()
        view.backgroundColor = .black
        navigationItem.title = "도봉쇼핑쇼핑"
        
        searchBar.delegate = self
    }

    
    

}

extension ViewController: ConfigureView {
    
    func setupConfigure() {
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(bgImage)
    }
    
    func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(4)
            
        }
        bgImage.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureView() {
        let placeholder = "브랜드, 상품, 프로필, 태그 등"
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: placeholder,attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        searchBar.layer.borderWidth = 10
        searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.1098035797, green: 0.1098041758, blue: 0.122666128, alpha: 1)
        searchBar.searchTextField.layer.cornerRadius = 10
        searchBar.searchTextField.clipsToBounds = true
        searchBar.searchTextField.leftView?.tintColor = .lightGray
        searchBar.searchTextField.tokenBackgroundColor = .white
        searchBar.searchBarStyle = .minimal
       

        bgImage.image = UIImage(named: "flex")
    }
    
    
}

extension ViewController: UISearchBarDelegate {
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print(#function)
    }
    
    // search button clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        
        view.endEditing(true)
    }
}

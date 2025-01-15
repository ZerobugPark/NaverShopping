//
//  ViewController.swift
//  NaverShopping
//
//  Created by youngkyun park on 1/15/25.
//

import UIKit

class ViewController: UIViewController {

    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        navigationItem.title = "도봉쇼핑쇼핑"
    }

    
    

}

extension ViewController: ConfigureView {
    
    func configureHierarchy() {
        view.addSubview(searchBar)
    }
    
    func configureLayout() {
        <#code#>
    }
    
    func configureView() {
        <#code#>
    }
    
    
}


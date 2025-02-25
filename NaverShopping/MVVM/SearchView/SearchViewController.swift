//
//  SearchViewController.swift
//  NaverShopping
//
//  Created by youngkyun park on 2/6/25.
//

import UIKit

final class SearchViewController: UIViewController {
    
    let searchView = SearchView()
    let searchModel = SearchViewModel()
    
    

    override func loadView() {
        view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationtitle()
        searchView.searchBar.delegate = self
        bindData()
    
    }
    

    
    private func bindData() {
  
        
        searchModel.outputSignal.lazyBind { (status, str) in
            if status {
                let vc = ResultViewController()
                
                vc.resultModel.outputSearchText.value = str
                
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.showAlertMsg()
            }
        }
    }
    
    private func setNavigationtitle() {
        
        navigationItem.title = searchModel.navigationTitle
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
    }
    
    
    
    
}

// MARK: - SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    
    // search button clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchModel.inputSearchText.value = searchBar.text
    }
    
    
}

// MARK: - Alert
extension SearchViewController {
    
    private func showAlertMsg() {
        let alert = UIAlertController(title: "알림", message: "2글자 이상 입력해주세요", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .cancel)
        
        alert.addAction(ok)
        present(alert,animated: true)
        
    }
    
}


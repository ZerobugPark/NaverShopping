//
//  SearchViewController.swift
//  NaverShopping
//
//  Created by youngkyun park on 2/6/25.
//

import UIKit

class SearchViewController: UIViewController {

    let serachView = SearchView()
    let serachModel = SearchViewModel()
    
    override func loadView() {
        view = serachView
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
    
    
        navigationItem.title = serachModel.navigationTitle
        
        serachView.searchBar.delegate = self
        bindData()
    }
    
    
    
    private func bindData() {

        serachModel.outputSignal.lazyBind { status in
            if status {
                
            } else {
                self.showAlertMsg()
            }
        }
    }
    

 

}


extension SearchViewController: UISearchBarDelegate {
    
    
    // search button clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        serachModel.inputSearchText.value = searchBar.text
//        let vc = ItemViewController()
//        
//        if let text = searchBar.text {
//            let str = text.replacingOccurrences(of: " ", with: "")
//            if str.count < 2 {
//                let msg = "2글자 이상 입력해주세요"
//                
//                showAlertMsg()
//                return
//            } else {
//                vc.navigationTitle = str
//            }
//        }
//        navigationController?.pushViewController(vc, animated: true)
//        view.endEditing(true)
    }
    
}

// MARK: - Alert Controller
extension SearchViewController {
    
    private func showAlertMsg() {
        let alert = UIAlertController(title: "알림", message: "2글자 이상 입력해주세요", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .cancel)
        
        alert.addAction(ok)
        present(alert,animated: true)
        
    }
    
}


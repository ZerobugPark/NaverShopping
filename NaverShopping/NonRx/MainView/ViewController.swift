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


    var mainView = MainView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationItem.title = "네이버마켓"
        
        mainView.searchBar.delegate = self
    }

}


// MARK: - SearchBarDelegate
extension ViewController: UISearchBarDelegate {
    
    
    // search button clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let vc = ItemViewController()
        
        if let text = searchBar.text {
            let str = text.replacingOccurrences(of: " ", with: "")
            if str.count < 2 {
                let msg = "2글자 이상 입력해주세요"
                
                showAlertMsg(msg) {
                }
                return
            } else {
                vc.navigationTitle = str
            }
        }
        navigationController?.pushViewController(vc, animated: true)
        view.endEditing(true)
    }
    
}

// MARK: - Alert Controller
extension ViewController {
    
    private func showAlertMsg(_ msg: String, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "알림", message: msg, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .cancel)
        
        alert.addAction(ok)
        present(alert,animated: true)
        
    }
    
}

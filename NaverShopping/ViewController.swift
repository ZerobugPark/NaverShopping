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
        navigationItem.title = "네이버마켓"
        
        searchBar.delegate = self
    }

}

// MARK: - View Setting

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
        searchBar.searchTextField.textColor = .white
        searchBar.searchBarStyle = .minimal
       

        bgImage.image = UIImage(named: "flex")
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

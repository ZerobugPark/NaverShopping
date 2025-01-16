//
//  ItemViewController.swift
//  NaverShopping
//
//  Created by youngkyun park on 1/15/25.
//

import UIKit

import Alamofire
import SnapKit


class ItemViewController: UIViewController {
    
    static let id = "ItemViewController"
    
 
    var itemView = ItemView()
    var navigationTitle = ""
    var items: [Item] = []
    var apiParm = APIParameter(display: 30, sort: Sorts.sim.rawValue, startIndex: 1)
    
    override func loadView() {
        view = itemView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        itemView.collectionView.delegate = self
        itemView.collectionView.dataSource = self
        itemView.collectionView.prefetchDataSource = self
        itemView.collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: "ItemCollectionViewCell")

        navigationItem.title = navigationTitle
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
   
        callRequest(apiParm.startIndex, selectedButton: false)
        
        buttonAddTarget()
    }
    
    private func buttonAddTarget() {
        
        for i in 0..<itemView.buttons.count {
            itemView.buttons[i].addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        }
    }
    

}

// MARK: - Objc Function

extension ItemViewController {
    
    @objc private func filterButtonTapped(_ sender: UIButton) {
        changeButtonColor(tag: sender.tag)
        switch sender.tag {
        case 0:
            apiParm.sort = Sorts.sim.rawValue
        case 1:
            apiParm.sort = Sorts.date.rawValue
        case 2:
            apiParm.sort = Sorts.dsc.rawValue
        case 3:
            apiParm.sort = Sorts.asc.rawValue
        default:
            apiParm.sort = Sorts.sim.rawValue
        }
        
        apiParm.startIndex = 1
        callRequest(apiParm.startIndex, selectedButton: true)
    }
    
    
    private func changeButtonColor(tag: Int) {

        for i in 0..<itemView.buttons.count {
            if i == tag {
                itemView.buttons[i].setTitleColor(.black, for: .normal)
                itemView.buttons[i].backgroundColor = .white
            } else {
                itemView.buttons[i].setTitleColor(.white, for: .normal)
                itemView.buttons[i].backgroundColor = .black
            }
        }
    }
}


// MARK: - CollectionView Delegate
extension ItemViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.id, for: indexPath) as? ItemCollectionViewCell else {
            return UICollectionViewCell()
        }

        let item = items[indexPath.item]
        cell.updateItemList(item: item)
        
        return cell
    }
    
    
}

extension ItemViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print(#function,indexPaths)
        for item in indexPaths {
            if items.count - 2 == item.item {
                apiParm.startIndex += 30
                if items.count >= apiParm.maxNum {
                    let msg = "더 이상 조회할 데이터가 없습니다"
                    showAlertMsg(msg) {
                        
                    }

                    return
                }
                callRequest(apiParm.startIndex, selectedButton: false)
            }
        }
    }

}

// MARK: - 네이버 쇼핑 API 통신

extension ItemViewController {
    
    func callRequest(_ page: Int, selectedButton: Bool) {
        print(#function)
                
        let searchItem = navigationTitle
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(searchItem)&display=\(apiParm.display)" + "&sort=\(apiParm.sort)&start=\(apiParm.startIndex)"
        
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.clientId, "X-Naver-Client-Secret": APIKey.clientSecret]
        
        if false {
            AF.request(url, method: .get, headers: header).responseString { value in
                print(value)
            }
        }
        
        AF.request(url, method: .get, headers: header).validate(statusCode: 0..<300).responseDecodable(of: NaverShoppingInfo.self) { response in
        
            switch response.result {
            case .success(let value):
                if !selectedButton {
                    self.items.append(contentsOf: value.items)
                } else {
                    self.items = value.items
                }
                
                self.itemView.collectionView.reloadData()
               
                self.itemView.resultCountLabel.text = value.total.formatted() + " 개의 검색 결과"

                if self.apiParm.startIndex == 1 && value.total != 0 {
                    self.itemView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                }
                
                if value.total < self.apiParm.totalCount {
                    self.apiParm.totalCount =  value.total
                }
                
            case.failure(let error):

                self.showAlertMsg(error.localizedDescription) {
                    
                }

            }
        }
        
    }
    
}

// MARK: - Alert
extension ItemViewController {
    
    private func showAlertMsg(_ msg: String, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "알림", message: msg, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .cancel)
        
        alert.addAction(ok)
        present(alert,animated: true)
        
    }
    
}

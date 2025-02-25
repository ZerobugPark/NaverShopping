//
//  ResultViewModel.swift
//  NaverShopping
//
//  Created by youngkyun park on 2/6/25.
//

import Foundation

class ResultViewModel {
    
    
    let outputSearchText: Observable<String?> = Observable(nil)
    
    let outputItems: Observable<[Item]> = Observable([])
    let outputTotal: Observable<String> = Observable("")
    
    
    let inputViewDidLoad: Observable<String?> = Observable((""))
    let inputFilterButtonTapped: Observable<Int> = Observable(0)
    let inputPagenagtion: Observable<[IndexPath]> = Observable(([]))
    
    
    var apiParm = APIParameter(display: 100, sort: Sorts.sim.rawValue, startIndex: 1)
    
    private var query = ""
    private var sort = Sorts.sim.rawValue
    
    init() {
        print("ResultViewModel init")
        
        inputViewDidLoad.lazyBind { [weak self] text in
            guard let text = text else {
                print("바인딩 오류")
                return
            }
            self?.callRequest(text: text, sort: Sorts.sim.rawValue, status: false)
        }
        
        inputFilterButtonTapped.lazyBind { [weak self] value in
            let sort = self?.findFilterTag(val: value)
            self?.callRequest(text: self!.query, sort: sort!, status: false)
        }
        
        inputPagenagtion.lazyBind { [weak self] indexPath in
            self?.pagenation(indexPaths: indexPath)
           
        }
        
    }
    
    func callRequest(text: String, sort: String, status: Bool) {
        
        query = text
        
        NetworkManagerMVVM.shared.callRequest(api: .getInfo(query: query, display: apiParm.display, sort: sort, startIndex: apiParm.startIndex), type: NaverShoppingInfo.self, completionHandler: { response in
            
            switch response {
            case .success(let value):
                if !status {
                    self.outputItems.value = value.items
                } else {
                    self.outputItems.value.append(contentsOf: value.items)
                }
                
                self.outputTotal.value = value.total.formatted() + " 개의 검색 결과"
                
                //print(value)
                
                if value.total < self.apiParm.totalCount {
                    self.apiParm.totalCount =  value.total
                }
            case.failure(let error):
                print(error)
            }
            
        })
    }
    
    private func findFilterTag(val: Int) -> String {
        switch val {
        case 0:
            sort = Sorts.sim.rawValue
        case 1:
            sort = Sorts.date.rawValue
        case 2:
            sort = Sorts.dsc.rawValue
        case 3:
            sort = Sorts.asc.rawValue
        default:
            sort = Sorts.sim.rawValue
        }
        return sort
    }
    
    private func pagenation(indexPaths: [IndexPath]) {
        for item in indexPaths {
            if outputItems.value.count - 2 == item.item {
                if outputItems.value.count >= apiParm.maxNum {
                    print("더 이상 조회할 데이터가 없습니다")
                    return
                }
                apiParm.startIndex += 100
                print(apiParm.startIndex)
                callRequest(text: query, sort: sort, status: true)
            }
        }
    }
    
    
    
    deinit {
        print("ResultViewModel deinit")
    }
    
}


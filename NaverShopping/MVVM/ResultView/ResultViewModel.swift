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
    
    private var query = ""
    
    init() {
        print("ResultViewModel init")
        
        inputViewDidLoad.lazyBind { [weak self] text in
            guard let text = text else {
                print("바인딩 오류")
                return
            }
            self?.callRequest(text: text, sort: Sorts.sim.rawValue)
        }
        
        inputFilterButtonTapped.lazyBind { [weak self] value in
            let sort = self?.findFilterTag(val: value)
            self?.callRequest(text: self!.query, sort: sort!)
        }
        
    }
    
    func callRequest(text: String, sort: String) {
        

        query = text
        
        NetworkManagerMVVM.shared.callRequest(api: .getInfo(query: query, display: 100, sort: sort, startIndex: 1), type: NaverShoppingInfo.self, completionHandler: { response in
            
            switch response {
            case .success(let value):
                self.outputItems.value = value.items
                self.outputTotal.value = value.total.formatted() + " 개의 검색 결과"
                
                //print(value)
            case.failure(let error):
                print(error)
            }
            
        })
    }
    
    private func findFilterTag(val: Int) -> String {
        print(val)
        switch val {
        case 0:
           return Sorts.sim.rawValue
        case 1:
            return Sorts.date.rawValue
        case 2:
            return Sorts.dsc.rawValue
        case 3:
            return Sorts.asc.rawValue
        default:
           return Sorts.sim.rawValue
        }
    }
    
    
    deinit {
        print("ResultViewModel deinit")
    }
    
    
    
    
    
}

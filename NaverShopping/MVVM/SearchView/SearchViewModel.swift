//
//  SearchViewModel.swift
//  NaverShopping
//
//  Created by youngkyun park on 2/6/25.
//

import Foundation

class SearchViewModel {
    
    
    let navigationTitle = "네이버마켓"
    
    var inputSearchText: Observable<String?> = Observable("")
    
    
    var outputSignal: Observable<Bool> = Observable(false)
    
    init() {
        
        print("inputSearchText Init")
        
        inputSearchText.lazyBind { text in
            print("inputSearchText Bind")
            self.validation(text)
        }
    }
    
    
    private func validation(_ text: String?) {
        
        guard let str = text else {
            // 서치바는 무조건 텍스트가 입력된 후 버튼이 클릭되기 때문에, nil일 가능성이 있을까? 없을거 같은데
            return
        }
        
        let resultStr = str.replacingOccurrences(of: " ", with: "")
        
        if resultStr.count < 2 {
            outputSignal.value = false
        } else {
            outputSignal.value = true
        }
        
    }
    
   deinit {
        print("SearchViewModel deinit")
    }
}

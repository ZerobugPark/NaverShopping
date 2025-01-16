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


    let resultCountLabel = UILabel()
    let buttonStackView = UIStackView()
    var buttons: [CustomBtn] = []
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
    
    static let id = "ItemViewController"
    
    var navigationTitle = ""
    
    var items: [Item] = []
    
    var apiParm = APIParameter(display: 30, sort: Sorts.sim.rawValue, startIndex: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupConfigure()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        
        collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: "ItemCollectionViewCell")
        collectionView.backgroundColor = .clear
        navigationItem.title = navigationTitle
     
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
    }
    
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
        items.removeAll()
        apiParm.startIndex = 1
        callRequest(apiParm.startIndex)
    }
}

// MARK: - View Setting

extension ItemViewController: ConfigureView {
    func setupConfigure() {
        
        customButtonConfigure()
        configureHierarchy()
        configureLayout()
        configureView()
        callRequest(apiParm.startIndex)
    }
    
    func configureHierarchy() {
        view.addSubview(resultCountLabel)
        view.addSubview(buttonStackView)
        view.addSubview(collectionView)
        
        for i in 0..<buttons.count {
            buttonStackView.addArrangedSubview(buttons[i])
        }
    }
    
    func configureLayout() {
        resultCountLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(4)
            make.width.equalTo(200)
            make.height.equalTo(20)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(resultCountLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(4)
            make.height.equalTo(40)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    func configureView() {
        resultCountLabel.text = ""
        resultCountLabel.textColor = #colorLiteral(red: 0.4514093995, green: 0.8566667438, blue: 0.5799819827, alpha: 1)
        resultCountLabel.font = .systemFont(ofSize: 14)
        resultCountLabel.textAlignment = .left
        
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillProportionally
        buttonStackView.spacing = 15
        
    }
    
    private func customButtonConfigure() {
        // 스택뷰를 사용했을 때, 텍스트 사이즈에 맞게 동적조절은 되지만, 버튼 텍스트의 여백을 주려면 어떻게 해야 할까요?..
        let buttonTitle = [" 정확도 ", " 날짜순 ", " 가격높은순 ", " 가격낮은순 "]
        for i in 0...3 {
            if i > 0 {
                let button = CustomBtn(title: buttonTitle[i], status: false, tagNum: i)
                button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
                buttons.append(button)
            } else {
                let button = CustomBtn(title: buttonTitle[i], status: true, tagNum: i)
                button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
                buttons.append(button)
            }
        }
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let deviceWidth = UIScreen.main.bounds.size.width
        let spacing: CGFloat = 16
        let inset: CGFloat = 16
        let objectWidth = (deviceWidth - (spacing + (inset*2))) / 2
        
        layout.itemSize = CGSize(width: objectWidth, height:  objectWidth * 1.5)
        layout.sectionInset = UIEdgeInsets(top: 16, left: inset, bottom: 0, right: inset)
        layout.scrollDirection = .vertical
        
        return layout
    }
    
    private func changeButtonColor(tag: Int) {
        
        for i in 0..<buttons.count {
            if i == tag {
                buttons[i].setTitleColor(.black, for: .normal)
                buttons[i].backgroundColor = .white
            } else {
                buttons[i].setTitleColor(.white, for: .normal)
                buttons[i].backgroundColor = .black
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
            if items.count - 4 == item.item {
                apiParm.startIndex += 30
                if items.count >= apiParm.maxNum {
                    // 알렛추가

                    return
                }
                callRequest(apiParm.startIndex)
            }
        }
    }

}

// MARK: - 네이버 쇼핑 API 통신

extension ItemViewController {
    
    func callRequest(_ page: Int) {
        print(#function)
                
        // 검색된 문자열이 이전과 같은 경우, 다시 검색 되지 않게 설정 (빈칸, 띄어쓰기 등)
        // 클라이언트는 가급적 정해진 틀안에서만 동작하게만 할 수 있도록 구현
        let searchItem = navigationTitle
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(searchItem)&display=\(apiParm.display)" + "&sort=\(apiParm.sort)&start=\(apiParm.startIndex)"
        
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.clientId, "X-Naver-Client-Secret": APIKey.clientSecret]
        
        if false {
            AF.request(url, method: .get, headers: header).responseString { value in
                print(value)
            }
        }

        AF.request(url, method: .get, headers: header).validate(statusCode: 0..<300).responseDecodable(of: NaverShoppingInfo.self) { response in
           // print(response.response?.statusCode)
            
            
            switch response.result {
            case .success(let value):
               // dump(value)

                self.items.append(contentsOf: value.items)
                self.resultCountLabel.text = value.total.formatted() + " 개의 검색 결과"

                if value.total < self.apiParm.totalCount {
                    self.apiParm.totalCount =  value.total

                }
      
                self.collectionView.reloadData()
                
                if self.apiParm.startIndex == 1 {
                    self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                }
                
            case.failure(let error):
                dump(error)
            }
        }
        
    }
    
}

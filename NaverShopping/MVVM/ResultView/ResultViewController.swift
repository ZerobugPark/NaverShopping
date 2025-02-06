//
//  ResultViewController.swift
//  NaverShopping
//
//  Created by youngkyun park on 2/6/25.
//

import UIKit

final class ResultViewController: UIViewController {

    
    let resultView = ResultView()
    let resultModel = ResultViewModel()
    
    override func loadView() {
        view = resultView
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        addTargetButton()
        bindData()
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    private func setupDelegate() {
        resultView.collectionView.delegate = self
        resultView.collectionView.dataSource = self
        //resultView.collectionView.prefetchDataSource = self
        
        resultView.collectionView.register(ResultViewCollectionViewCell.self, forCellWithReuseIdentifier: "ResultViewCollectionViewCell")
    }
    
    private func addTargetButton() {
        for i in 0..<resultView.buttons.count {
            resultView.buttons[i].addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        }
    }
 
    private func bindData() {
        
        resultModel.outputSearchText.bind { [weak self] text in
            print("outputSearchText bind")
            
            self?.navigationItem.title = text
            self?.resultModel.inputViewDidLoad.value = text
            
        }
        
        resultModel.outputItems.lazyBind { [weak self] _ in
            self?.resultView.collectionView.reloadData()
        }
        
        resultModel.outputTotal.lazyBind { [weak self] text in
            self?.resultView.resultCountLabel.text = text
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function)
    }
    
    deinit {
        print("ResultViewController deinit")
    }
    
}


// MARK: - CollectionView Delegate
extension ResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return resultModel.outputItems.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultViewCollectionViewCell.id, for: indexPath) as? ResultViewCollectionViewCell else {
            return UICollectionViewCell()
        }

        let item = resultModel.outputItems.value[indexPath.item]
        cell.updateItemList(item: item)
        
        return cell
    }
    
    
}

// MARK: - Objc Function

extension ResultViewController {
    
    @objc private func filterButtonTapped(_ sender: UIButton) {
        changeButtonColor(tag: sender.tag)
        resultModel.inputFilterButtonTapped.value = sender.tag
    }
    
    
    private func changeButtonColor(tag: Int) {

        for i in 0..<resultView.buttons.count {
            if i == tag {
                resultView.buttons[i].configuration?.baseForegroundColor = .black
                resultView.buttons[i].configuration?.baseBackgroundColor = .white

            } else {
                resultView.buttons[i].configuration?.baseForegroundColor = .white
                resultView.buttons[i].configuration?.baseBackgroundColor = .black

            }
        }
    }
}

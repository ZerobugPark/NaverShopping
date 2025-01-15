//
//  ItemCollectionViewCell.swift
//  NaverShopping
//
//  Created by youngkyun park on 1/15/25.
//

import UIKit

import Kingfisher
import SnapKit

class ItemCollectionViewCell: UICollectionViewCell{
    
    static let id = "ItemCollectionViewCell"
    
    let mainImage = UIImageView()
    let circleView = UIView()
    let likeBtn = CustomBtn(imgName: "heart")
    let labelStackView = UIStackView()
    let mallNameLabel = CustomLabel(title: "", fontSize: 12, color: .lightGray, bold: false)
    let titleLabel = CustomLabel(title: "", fontSize: 14, color: .white, bold: false)
    let lpriceLabel = CustomLabel(title: "", fontSize: 20, color: .white, bold: true)
    var status: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateItemList(item: Item) {
        
        
        let url = URL(string: item.image)
        mainImage.kf.setImage(with: url)
        
        mallNameLabel.text = item.mallName
        titleLabel.text = item.title.replacingOccurrences(of: "<[^>]+>|&quot;",
                                                          with: "",
                                                          options: .regularExpression,
                                                          range: nil)
        
        // 콤마 추가
        if let price = Int(item.lprice) {
            lpriceLabel.text = price.formatted()
        } else {
            lpriceLabel.text = item.lprice
        }
        
    }
    
    @objc private func likeButtonTapped(_ sender: UIButton) {
        print(#function)
        
        if !status {
            likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        // 왜 status는 하나의 변수인데, 다 각자 개별로 동작을 하는걸까?... 의문이네..
        print(status)
        status.toggle()
        
    }
    
}

extension ItemCollectionViewCell: ConfigureView {
    func setupConfigure() {
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() {
        contentView.addSubview(mainImage)
        contentView.addSubview(labelStackView)
        contentView.addSubview(circleView)
        contentView.addSubview(likeBtn)
        
        labelStackView.addArrangedSubview(mallNameLabel)
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(lpriceLabel)
    }
    
    func configureLayout() {
        mainImage.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(160)
        }
        
        circleView.snp.makeConstraints { make in
            make.bottom.equalTo(mainImage).offset(-10)
            make.trailing.equalTo(mainImage).offset(-10)
            make.height.equalTo(30)
            make.width.equalTo(30)
            
        }
        
        likeBtn.snp.makeConstraints { make in
            make.edges.equalTo(circleView)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(mainImage.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(4)
            make.height.equalTo(85)
        }
    }
    
    func configureView() {
        mainImage.clipsToBounds = true
        mainImage.layer.cornerRadius = 10
        
        titleLabel.numberOfLines = 2
       
        likeBtn.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        circleView.backgroundColor = .white
        DispatchQueue.main.async {
            self.circleView.layer.cornerRadius = self.circleView.frame.width / 2
        }
        
        labelStackView.axis = .vertical
        labelStackView.distribution = .fillProportionally
        
    }
    
    
}

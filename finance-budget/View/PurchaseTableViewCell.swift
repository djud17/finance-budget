//
//  PurchaseTableViewCell.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 16.06.2021.
//

import UIKit
import SnapKit

final class PurchaseTableViewCell: UITableViewCell {
    let purchaseTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = Constants.blackColor
        label.textAlignment = .center
        return label
    }()
    let purchaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = Constants.blackColor
        label.textAlignment = .center
        return label
    }()
    let purchaseValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = Constants.blackColor
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        stackView.addArrangedSubview(purchaseTitleLabel)
        stackView.addArrangedSubview(purchaseDateLabel)
        stackView.addArrangedSubview(purchaseValueLabel)
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().inset(5)
        }
    }
}

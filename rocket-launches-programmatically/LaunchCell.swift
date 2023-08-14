//
//  LaunchCell.swift
//  rocket-launches-programmatically
//
//  Created by Кирилл Васильев on 25.06.2023.
//

import UIKit
import SnapKit

// Финальный класс LaunchCell, наследуемый от UITableViewCell
final class LaunchCell: UITableViewCell {
    
    // Создаем лейблы для основного и второстепенного текста
    private let mainTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let secondaryTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    // Инициализация ячейки и настройка представлений
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Функция configureWith принимает текст и второстепенный текст, и настраивает ячейку в соответствии с полученными данными
    func configureWith(text: String, secondaryText: String) {
        // Устанавливаем основной текст ячейки, равный переданному тексту
        mainTextLabel.text = text
        // Устанавливаем второстепенный текст ячейки, равный переданному второстепенному тексту
        secondaryTextLabel.text = secondaryText
    }
    
    // Функция для настройки представлений
    private func setupViews() {
        contentView.addSubview(mainTextLabel)
        contentView.addSubview(secondaryTextLabel)
    }
    
    // Функция для настройки ограничений с использованием SnapKit
    private func setupConstraints() {
        mainTextLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(15)
            make.right.lessThanOrEqualToSuperview().offset(-15)
        }
        
        secondaryTextLabel.snp.makeConstraints { make in
            make.top.equalTo(mainTextLabel.snp.bottom).offset(5)
            make.left.right.equalTo(mainTextLabel)
            make.bottom.lessThanOrEqualToSuperview().offset(-15)
        }
    }
}

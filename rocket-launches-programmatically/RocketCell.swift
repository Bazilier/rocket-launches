//
//  RocketsCell.swift
//  rocket-launches-programmatically
//
//  Created by Кирилл Васильев on 25.06.2023.
//

import UIKit
import SpaceXAPI
import SnapKit

// Класс RocketCell, наследуемый от UITableViewCell
class RocketCell: UITableViewCell {
    
    // Создаем лейблы для основного и второстепенного текста
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let detailLabel: UILabel = {
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
    
    // Функция configureWith принимает экземпляр ракеты и настраивает ячейку в соответствии с полученными данными
    func configureWith(_ rocket: RocketsQuery.Data.Rocket) {
        // Настройка основного текста ячейки равной имени ракеты
        nameLabel.text = rocket.name
        // Настройка второстепенного текста ячейки, который отображает высоту и массу ракеты в метрах и кг соответственно
        // Если данные отсутствуют, используется значение по умолчанию 0
        detailLabel.text = "\(rocket.height?.meters ?? 0) meters / \(rocket.mass?.kg ?? 0) kg"
    }
    
    // Функция для настройки представлений
    private func setupViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(detailLabel)
    }
    
    // Функция для настройки ограничений с использованием SnapKit
    private func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(15)
            make.right.lessThanOrEqualToSuperview().offset(-15)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.right.equalTo(nameLabel)
            make.bottom.lessThanOrEqualToSuperview().offset(-15)
        }
    }
}



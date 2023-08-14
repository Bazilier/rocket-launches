//
//  RocketsViewController.swift
//  rocket-launches-programmatically
//
//  Created by Кирилл Васильев on 25.06.2023.
//

import SpaceXAPI
import UIKit
import SnapKit

// Финальный класс RocketsViewController
final class RocketsViewController: UIViewController {
    
    // Приватный массив rockets, содержащий данные о ракетах
    private var rockets: [RocketsQuery.Data.Rocket] = []
    
    // Приватная переменная для таблицы
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.dataSource = self
        tv.delegate = self
        tv.register(RocketCell.self, forCellReuseIdentifier: "RocketCell")
        return tv
    }()
    
    // Функция, вызываемая после загрузки представления контроллера
    override func viewDidLoad() {
        super.viewDidLoad()
        // Настройка таблицы
        setupViews()
        setupConstraints()
        // Получение данных о ракетах
        fetchRockets()
    }
    
    // Функция для настройки представлений
    private func setupViews() {
        view.addSubview(tableView)
    }
    
    // Функция для настройки констреинтов с использованием SnapKit
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension RocketsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Функция возвращающая количество секций в таблице
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Функция возвращающая количество ячеек в секции таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // Значение соотвествует количеству элементов в массиве rockets
        return rockets.count
    }
    
    // Функция возвращающая заголовок для секции
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Rockets"
    }
    
    // Функция для конфигурации ячейки таблицы
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RocketCell", for: indexPath) as! RocketCell
        let rocket = rockets[indexPath.row]
        cell.configureWith(rocket)
        
        return cell
    }
    
    // Функция, вызываемая при нажатии на ячейку таблицы
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = LaunchesViewController()
        vc.rocket = rockets[indexPath.row]
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .pageSheet
        self.present(navController, animated: true, completion: nil)
    }
}

// MARK: - Network
private extension RocketsViewController {
    // Приватная функция для получения данных о ракетах
    func fetchRockets() {
        let query = RocketsQuery()
        NetworkService.shared.apollo.fetch(query: query) { [weak self] result in
            switch result {
            case .success(let value):
                // Получение данных о ракетах и обновление таблицы, из-за строгой типизации в Apollo часто используются опционалы, поэтому используем compactMap
                self?.rockets = value.data?.rockets?.compactMap { $0 } ?? []
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                // Вывод ошибки в консоль
                debugPrint(error.localizedDescription)
            }
        }
    }
}

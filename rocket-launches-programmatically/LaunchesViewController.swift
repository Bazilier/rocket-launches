//
//  LaunchesViewController.swift
//  rocket-launches-programmatically
//
//  Created by Кирилл Васильев on 25.06.2023.
//

import SpaceXAPI
import UIKit
import SnapKit

// Финальный класс LaunchesViewController
final class LaunchesViewController: UIViewController {
    
    // Переменная для хранения данных о ракете
    var rocket: RocketsQuery.Data.Rocket!
    
    // Создание форматеров для входной и выходной дат
    private let inDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter
    }()
     
    private let outDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return dateFormatter
    }()
    
    // Массивы для предстоящих и прошедших запусков
    private var launchesUpcoming: [LaunchesQuery.Data.LaunchesUpcoming] = []
    private var launchesPast: [LaunchesQuery.Data.LaunchesPast] = []
    
    // Приватная переменная для таблицы с инициализацией замыканием
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.dataSource = self
        tv.delegate = self
        tv.register(LaunchCell.self, forCellReuseIdentifier: "LaunchCell")
        return tv
    }()
    
    // Функция, вызываемая после загрузки представления контроллера
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = rocket.name
        
        // Настройка таблицы и загрузка данных о запусках
        setupViews()
        setupConstraints()
        fetchLaunches()
    }
    
    // Функция для настройки представлений
    private func setupViews() {
        view.addSubview(tableView)
    }
    
    // Функция для настройки ограничений с использованием SnapKit
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LaunchesViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Функция возвращающая количество секций в таблице
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // Функция возвращающая количество ячеек в секции таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return launchesUpcoming.count
        case 1: return launchesPast.count
        default: return 0
        }
    }
    
    // Функция для конфигурации ячейки таблицы
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LaunchCell", for: indexPath) as! LaunchCell
        let cellText: String
        let cellSecondaryText: String
        
        // Настройка ячеек в зависимости от секции
        switch indexPath.section {
        case 0:
            let launchUpcoming = launchesUpcoming[indexPath.row]
            cellText = launchUpcoming.mission_name ?? ""
            let launchDate = inDateFormatter.date(from: launchUpcoming.launch_date_utc ?? "") ?? .now
            cellSecondaryText = outDateFormatter.string(from: launchDate)
            
        case 1:
            let launchPast = launchesPast[indexPath.row]
            cellText = launchPast.mission_name ?? ""
            let launchDate = inDateFormatter.date(from: launchPast.launch_date_utc ?? "") ?? .now
            cellSecondaryText = outDateFormatter.string(from: launchDate)
            
        default:
            cellText = ""
            cellSecondaryText = ""
        }
        
        // Конфигурация ячейки
        cell.configureWith(text: cellText, secondaryText: cellSecondaryText)
        return cell
    }
    
    // Функция возвращающая заголовок для секции
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Upcoming launches"
        case 1: return "Past launches"
        default: return nil
        }
    }
}

// MARK: - Network
private extension LaunchesViewController {
    // Функция для загрузки данных о запусках
    func fetchLaunches() {
        let launchFind = LaunchFind(rocket_id: rocket.id ?? .none)
        let query = LaunchesQuery(upcomingFind: .some(launchFind), pastFind: .some(launchFind))
        NetworkService.shared.apollo.fetch(query: query) { [weak self] result in
            switch result {
            case .success(let value):
                self?.launchesUpcoming = value.data?.launchesUpcoming?.compactMap { $0 } ?? []
                self?.launchesPast = value.data?.launchesPast?.compactMap { $0 } ?? []
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

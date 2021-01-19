//
//  LogsViewController.swift
//  NumberGame
//
//  Created by sangho Cho on 2021/01/19.
//

import UIKit
import CoreData
import SnapKit

class LogsViewController: UIViewController {

  // MARK: Contstants

  private enum ReuseIdentifier {
    static let Logcell = "LogCell"
  }


  // MARK: Properties

  var score: ScoreMO!

  private lazy var logList: [LogMO] = {
    return self.score.logs?.array as? [LogMO] ?? []
  }()


  // MARK: UI

  private lazy var tableView = UITableView()


  // MARK: Configuring

  private func configureViews() {
    self.title = self.score.date?.dateTransformToTitle()
    self.view.backgroundColor = .systemBackground
    self.configureTableView()
    self.layoutViews()
  }

  private func configureTableView() {
    self.tableView.register(LogCell.self, forCellReuseIdentifier: ReuseIdentifier.Logcell)
    self.tableView.dataSource = self
  }


  // MARK: View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureViews()
  }

  // MARK: Layout

  private func layoutViews() {
    self.view.addSubview(self.tableView)

    self.tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}


extension LogsViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.logList.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let row = self.logList[indexPath.row]

    guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.Logcell) as? LogCell else {
      return UITableViewCell()
    }

    cell.set(inputNumber: Int(row.inputtedNumber), result: row.result ?? "")

    return cell
  }


}

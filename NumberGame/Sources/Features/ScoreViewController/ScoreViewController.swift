//
//  ScoreViewController.swift
//  NumberGame
//
//  Created by sangho Cho on 2021/01/18.
//

import Foundation
import UIKit
import SnapKit
import CoreData

final class ScoreViewController: UIViewController {


  // MARK: Constants

  private enum ReuseIdentifier {
    static let scoreCell = "scoreCell"
  }


  // MARK: Properties

  var coreDataService: CoreDataServiceProtocol!
  private lazy var scoreMOFetchRequest: NSFetchRequest<ScoreMO> = ScoreMO.fetchRequest()
  private lazy var scoreList: [ScoreMO] = {
    self.coreDataService.fetch(self.scoreMOFetchRequest)
  }()


  // MARK: UI

  private let tableView = UITableView()


  // MARK: Configuring

  private func configureViews() {
    self.title = "Score"
    self.view.backgroundColor = .systemBackground
    self.configureTableView()
    self.layoutViews()
  }

  private func configureTableView() {
    self.tableView.register(ScoreCell.self, forCellReuseIdentifier: ReuseIdentifier.scoreCell)
    self.tableView.delegate = self
    self.tableView.dataSource = self
  }


  // MARK: Initialize

  init(coreDataService: CoreDataServiceProtocol) {
    self.coreDataService = coreDataService
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureViews()
  }


  // MARK: Layout

  private func layoutViews() {
    self.view.addSubview(tableView)

    self.tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

extension ScoreViewController {
  private func moveToLogView(score: ScoreMO) {
    let logView = LogsViewController()
    logView.score = score

    self.navigationController?.pushViewController(logView, animated: true)
  }
}

extension ScoreViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.scoreList.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let row = self.scoreList[indexPath.row]

    guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.scoreCell) as? ScoreCell else {
      return UITableViewCell()
    }

    cell.set(title: "\(row.date ?? "")의 게임", subTitle: "\(row.inputCount)회 시도")

    return cell
  }
}

extension ScoreViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let scoreObject = self.scoreList[indexPath.row]

    self.moveToLogView(score: scoreObject)
  }
}
  



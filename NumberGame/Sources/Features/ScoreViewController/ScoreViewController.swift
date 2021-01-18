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

  private lazy var scoreList: [ScoreMO] = {
    self.fetch()
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


  // MARK: Functions

  private func fetch() -> [ScoreMO] {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext

    let fetchRequest: NSFetchRequest<ScoreMO> = ScoreMO.fetchRequest()

    do {
      let result = try context.fetch(fetchRequest)
      return result
    } catch {
      return []
    }
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

}
  



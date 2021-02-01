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
    self.configureNavigationController()
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

  private func delete(objectID: NSManagedObjectID) -> Bool {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext

    let object = context.object(with: objectID)

    context.delete(object)

    do {
      try context.save()
      return true
    } catch {
      context.rollback()
      return false
    }
  }

  private func configureNavigationController() {
    self.navigationItem.rightBarButtonItem = self.editButtonItem
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

  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

    let object = self.scoreList[indexPath.row]

    if self.delete(objectID: object.objectID) {
      self.scoreList.remove(at: indexPath.row)
      self.tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
}
  



//
//  GameListViewController.swift
//  NumberGame
//
//  Created by 윤중현 on 2020/12/21.
//

import UIKit

final class GameListViewController: UIViewController {

  // MARK: Constants

  private enum Constant {
    static let games = ["Number Game"]
  }

  private enum ReuseIdentifier {
    static let gameCell = "gameCell"
  }


  // MARK: UI

  private let tableView = UITableView()


  // MARK: Initializing

  init() {
    super.init(nibName: nil, bundle: nil)
    self.configureViews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  private func configureViews() {
    self.configureTableView()
    self.layoutViews()
  }

  private func configureTableView() {
    self.tableView.register(GameCell.self, forCellReuseIdentifier: ReuseIdentifier.gameCell)
    self.tableView.dataSource = self
  }


  // MARK: Layout

  private func layoutViews() {
    self.view.addSubview(tableView)

    self.tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

extension GameListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Constant.games.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let gameCell = tableView.dequeueReusableCell(
      withIdentifier: ReuseIdentifier.gameCell,
      for: indexPath
    ) as? GameCell else { return UITableViewCell() }
    let gameTitle = Constant.games[indexPath.item]
    gameCell.set(title: gameTitle)
    return gameCell
  }
}

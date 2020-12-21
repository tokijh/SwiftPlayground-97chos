//
//  GameListViewController.swift
//  NumberGame
//
//  Created by 윤중현 on 2020/12/21.
//

import UIKit

import SnapKit

final class GameListViewController: UIViewController {

  // MARK: UI

  private let collectionView = UICollectionView()


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
    self.layoutViews()
  }


  // MARK: Layout

  private func layoutViews() {
    self.view.addSubview(collectionView)

    self.collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

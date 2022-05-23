//
//  ViewController.swift
//  DragAndDropCollectionView
//
//  Created by 신의연 on 2022/05/17.
//

import UIKit
import SnapKit

class CellMovingFromCollectionDelegateViewController: UIViewController {
   
   var longPress: UILongPressGestureRecognizer!
   
   let color: [UIColor] = [.red, .orange, .yellow, .green, .blue, .purple, .brown, .black, .gray, .cyan]
   
   lazy var collectionView: UICollectionView = {
      let layout = UICollectionViewFlowLayout()
      var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
      collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
      return collectionView
   }()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setLayout()
      setGestureRecognizer()
   }
   
   func setLayout() {
      
      collectionView.delegate = self
      collectionView.dataSource = self
      
      view.addSubview(collectionView)
      
      collectionView.snp.makeConstraints { make in
         make.top.equalTo(view.snp.top)
         make.width.equalTo(view.snp.width)
         make.centerX.equalToSuperview()
         make.bottom.equalToSuperview()
      }
      
   }
   
   func setGestureRecognizer() {
      print("longpress")
      if longPress == nil {
         longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
         longPress.minimumPressDuration = 0.2
         collectionView.addGestureRecognizer(longPress)
      }
   }
   @objc func handleLongPressGesture() {
      print("gesture on")
      let location = longPress.location(in: collectionView)
      switch longPress.state {
      case .began: if let indexPath = collectionView.indexPathForItem(at: location) {
         collectionView.beginInteractiveMovementForItem(at: indexPath)
      }
      case .changed:
         collectionView.updateInteractiveMovementTargetPosition(location)
      case .ended:
         collectionView.endInteractiveMovement()
      default:
         collectionView.cancelInteractiveMovement()
      }

   }
   
   
   
}
extension CellMovingFromCollectionDelegateViewController: UICollectionViewDelegate, UICollectionViewDataSource {
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return color.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
      cell.backgroundColor = color[indexPath.row]
      return cell
   }
   
}

extension CellMovingFromCollectionDelegateViewController: UICollectionViewDelegateFlowLayout {
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: 100, height: 100)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return 10
   }
   func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
      return true
   }
   func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
      
   }
}

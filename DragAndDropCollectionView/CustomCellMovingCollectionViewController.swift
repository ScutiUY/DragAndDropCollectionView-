//
//  CustomCellMovingCollectionViewController.swift
//  DragAndDropCollectionView
//
//  Created by 신의연 on 2022/05/23.
//

import UIKit

class CustomCellMovingCollectionViewController: UIViewController {

    var longPress: UILongPressGestureRecognizer!
    
    var originalIndexPath: IndexPath?
    var draggingIndexPath: IndexPath?
    var draggingView: UIView?
    var dragOffset = CGPoint.zero
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
        // Do any additional setup after loading the view.
    }
    
    func setLayout(){
    
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
           make.top.equalTo(view.snp.top)
           make.width.equalTo(view.snp.width)
           make.centerX.equalToSuperview()
           make.bottom.equalToSuperview()
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    func startDragAtLocation(location: CGPoint) {
       let cv = collectionView
       guard let indexPath = cv.indexPathForItem(at: location) else { return }
       guard cv.dataSource?.collectionView?(cv, canMoveItemAt: indexPath) == true else { return }
       guard let cell = cv.cellForItem(at: indexPath) else { return }
       print(cell)
       
    
       originalIndexPath = indexPath
       draggingIndexPath = indexPath
       draggingView = cell.snapshotView(afterScreenUpdates: true)
       draggingView!.frame = cell.frame
       
       cv.addSubview(draggingView!)
       
       dragOffset = CGPoint(x: draggingView!.center.x - location.x, y: draggingView!.center.y - location.y)
       draggingView?.layer.shadowPath = UIBezierPath(rect: draggingView!.bounds).cgPath
       draggingView?.layer.shadowColor = UIColor.black.cgColor
       draggingView?.layer.shadowOpacity = 0.8
       draggingView?.layer.shadowRadius = 10
       
       
       collectionView.collectionViewLayout.invalidateLayout()
       
 //      UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: {
 //
 //         self.draggingView?.alpha = 0.95
 //         self.draggingView?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
 //      }, completion: nil)
    }
    
    func updateDragAtLocation(location: CGPoint) {
       guard let view = draggingView else { return }
       let cv = collectionView
       guard let indexPath = cv.indexPathForItem(at: location) else { return }
       guard let cell = cv.cellForItem(at: indexPath) else { return }
       
       cell.center = CGPoint(x: location.x + dragOffset.x, y: location.y + dragOffset.y)
       
       if let newIndexPath = cv.indexPathForItem(at: location) {
          cv.moveItem(at: draggingIndexPath!, to: newIndexPath)
          draggingIndexPath = newIndexPath
       }
    }
    
    func endDragAtLocation(location: CGPoint) {
       guard let dragView = draggingView else { return }
       guard let indexPath = draggingIndexPath else { return }
       let cv = collectionView
       guard let datasource = cv.dataSource else { return }
       
       let targetCenter = datasource.collectionView(cv, cellForItemAt: indexPath).center
       
       let shadowFade = CABasicAnimation(keyPath: "shadowOpacity")
       shadowFade.fromValue = 0.8
       shadowFade.toValue = 0
       shadowFade.duration = 0.4
       dragView.layer.add(shadowFade, forKey: "shadowFade")
       
 //      UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: {
 //         dragView.center = targetCenter
 //         dragView.transform = CGAffineTransform.identity
 //
 //      }) { [self] (completed) in
 //
 //         if indexPath != (self.originalIndexPath!) {
 //            datasource.collectionView?(cv, moveItemAt: self.originalIndexPath!, to: indexPath)
 //         }
 //
 //         dragView.removeFromSuperview()
 //         self.draggingIndexPath = nil
 //         self.draggingView = nil
 //         collectionView.collectionViewLayout.invalidateLayout()
 //      }
       if indexPath != (self.originalIndexPath!) {
          datasource.collectionView?(cv, moveItemAt: self.originalIndexPath!, to: indexPath)
       }
       
       dragView.removeFromSuperview()
       self.draggingIndexPath = nil
       self.draggingView = nil
       collectionView.collectionViewLayout.invalidateLayout()
       
    }
}

extension CustomCellMovingCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return color.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.backgroundColor = color[indexPath.row]
        return cell
    }
    
    
}

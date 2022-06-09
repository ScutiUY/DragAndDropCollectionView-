//
//  CustomCellMovingCollectionViewController.swift
//  DragAndDropCollectionView
//
//  Created by 신의연 on 2022/05/23.
//

import UIKit

class CustomCellMovingCollectionViewController: UIViewController {
    
    var longPressGestureRecognizer: UILongPressGestureRecognizer!
    
    var originCell: UICollectionViewCell?
    var originalIndexPath: IndexPath?
    var draggingIndexPath: IndexPath?
    var draggingView: UIView?
    var dragOffset = CGPoint.zero
    var color: [UIColor] = [.red, .orange, .yellow, .green, .blue, .purple, .brown, .black, .gray, .cyan]
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        addGesture()
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
        collectionView.dragInteractionEnabled = true
    }
    
    func addGesture() {
        longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    func startDragAtLocation(location: CGPoint) {
        
        guard let indexPath = collectionView.indexPathForItem(at: location) else { return }
        
        guard collectionView.dataSource!.collectionView!(collectionView, canMoveItemAt: indexPath) == true else { return }
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        originalIndexPath = indexPath

        draggingView = cell.snapshotView(afterScreenUpdates: true)
        draggingView!.frame = cell.frame
        
        collectionView.addSubview(draggingView!)
        
        dragOffset = CGPoint(x: cell.center.x - location.x, y: cell.center.y - location.y)
        
        cell.isHidden = true
        
        collectionView.collectionViewLayout.invalidateLayout()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: {
            self.draggingView!.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.collectionView.collectionViewLayout.invalidateLayout()
        })
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
            self.draggingView!.transform = CGAffineTransform.identity
            self.collectionView.collectionViewLayout.invalidateLayout()
        })
    }
    
    func updateDragAtLocation(location: CGPoint) {
        
        guard draggingView != nil else { return }
        
        draggingView!.center = CGPoint(x: location.x + dragOffset.x, y: location.y + dragOffset.y)
        
        if let newIndexPath = collectionView.indexPathForItem(at: location) {
            collectionView.moveItem(at: originalIndexPath!, to: newIndexPath)
            originalIndexPath = newIndexPath
        }
    }
    
    func endDragAtLocation(location: CGPoint) {
        
        guard let dragView = draggingView else { return }
        guard let indexPath = originalIndexPath else { return }
        let cv = collectionView
        guard let datasource = cv.dataSource else { return }

       
        if indexPath != (self.originalIndexPath!) {
            datasource.collectionView?(cv, moveItemAt: self.originalIndexPath!, to: indexPath)
        }
        if let newIndexPath = collectionView.indexPathForItem(at: location) {
            let cell = collectionView.cellForItem(at: newIndexPath)
            cell!.isHidden = false
        } else {
            let cell = collectionView.cellForItem(at: originalIndexPath!)
            cell!.isHidden = false
        }
        
        dragView.removeFromSuperview()
        self.draggingIndexPath = nil
        self.draggingView = nil
        
        collectionView.collectionViewLayout.invalidateLayout()
        
    }
    
    @objc func handleLongPress() {
        
        longPressGestureRecognizer.minimumPressDuration = 0.2
        
        let location = longPressGestureRecognizer.location(in: collectionView)
        
        switch longPressGestureRecognizer.state {
        case .began:
            if collectionView.indexPathForItem(at: location) != nil {
                startDragAtLocation(location: location)
            }
        case .changed:
            updateDragAtLocation(location: location)
        case .ended:
            endDragAtLocation(location: location)
        default:
            endDragAtLocation(location: location)
        }
    }
}

extension CustomCellMovingCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return color.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.backgroundColor = color[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}


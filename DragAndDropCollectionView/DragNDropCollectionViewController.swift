//
//  NewCollectionViewController.swift
//  DragAndDropCollectionView
//
//  Created by 신의연 on 2022/05/17.
//

import UIKit

class DragNDropCollectionViewController: UIViewController {
    
    var longPress: UILongPressGestureRecognizer!
    
    let color: [UIColor] = [.red, .orange, .yellow, .green, .blue, .purple, .brown, .black, .gray, .cyan]
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    func setLayout() {
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.width.equalTo(view.snp.width)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
    
}

extension DragNDropCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return color.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.backgroundColor = color[indexPath.row]
        return cell
    }
    
    
}

//extension DragNDropCollectionViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
//    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        let item = NSItemProvider(object: NSItemProviderWriting)
//        return []
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
//        
//    }
//    
//    
//}

//
//  ViewController.swift
//  WaterfallKit
//
//  Created by woodjobber on 06/10/2021.
//  Copyright (c) 2021 woodjobber. All rights reserved.
//

import UIKit
import WaterfallKit
import SnapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var stickyColumnsLayout: StickyColumnsCollectionViewLayout = {
        let stickyColumnsLayout = StickyColumnsCollectionViewLayout()
        stickyColumnsLayout.isDecoratorEnable = true
        stickyColumnsLayout.decoratorCornerRadius = 10
        stickyColumnsLayout.pinOffsetY = 40
        stickyColumnsLayout.decoratorOfSuperviewColor = .white
        stickyColumnsLayout.decoratorEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return stickyColumnsLayout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.collectionViewLayout = stickyColumnsLayout
        collectionView.reloadData()
        /// 没有完成 demo
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
    }
}

extension ViewController: StickyColumnsCollectionViewDelegateLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountFor section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingFor section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForFooterIn section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForHeaderIn section: Int) -> CGFloat {
   
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingFor section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetsFor section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, excludeDecorationViewFor section: Int) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, decoratorInsetsFor section: Int) -> UIEdgeInsets {
  
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, decoratorCornerFor section: Int) -> UIRectCorner {
        return .allCorners
    }
}

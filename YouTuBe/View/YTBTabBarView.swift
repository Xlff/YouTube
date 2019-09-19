//
//  YTBTabBarView.swift
//  YouTuBe
//
//  Created by Max xie on 2019/9/19.
//

import UIKit

class YTBTabBarView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var whiteBar: UIView!
    @IBOutlet weak var whiteBarLeadingConstraint: NSLayoutConstraint!
    
    private let tabBarImageNames = ["home", "trending", "subscriptions", "account"]
    private var selectedIndex = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customization()
    }
    
    private func customization() {
        NotificationCenter.default.addObserver(self, selector: #selector(animateMenu(notification:)), name: YTBConstant.scrollMenuNotificationName, object: nil)
    }
    
    @objc func animateMenu(notification: Notification) {
        if var userInfo = notification.userInfo as? [String: CGFloat] {
            whiteBarLeadingConstraint.constant = whiteBar.bounds.width * userInfo[YTBConstant.NotificationInfolength]!
            selectedIndex = Int(round(userInfo[YTBConstant.NotificationInfolength]!))
            layoutIfNeeded()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension YTBTabBarView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.selectedIndex != indexPath.item {
            self.selectedIndex = indexPath.item
            
            collectionView.reloadData()
            NotificationCenter.default.post(name: YTBConstant.selectedMenuNotificationName,
                                            object: nil,
                                            userInfo: [YTBConstant.NotificationInfoIndex: self.selectedIndex])
        }
    }
}

extension YTBTabBarView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabBarImageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as!  YTBTabBarCell
        var imageName = tabBarImageNames[indexPath.row]
        if selectedIndex == indexPath.row {
            imageName += "Selected"
        }
        cell.icon.image = UIImage.init(named: imageName)
        return cell
    }
    
}

extension YTBTabBarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 4, height: collectionView.bounds.height)
    }
}


class YTBTabBarCell: UICollectionViewCell {
    @IBOutlet weak var icon: UIImageView!
    
}

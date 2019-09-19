//
//  ViewController.swift
//  YouTuBe
//
//  Created by Max xie on 2019/9/18.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var tabBarView: YTBTabBarView!
    private var views = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        customization()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    private func customization() {
        collectionView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
        view.addSubview(tabBarView)
        tabBarView.snp.makeConstraints { make in
            make.height.equalTo(64)
            make.top.left.right.equalToSuperview()
        }
        
        let viewcontrollers = [UIStoryboard.main.homeViewController, UIStoryboard.main.trendingViewController, UIStoryboard.main.subscriptionViewController, UIStoryboard.main.accountViewController]
        for vc in viewcontrollers {
            addChild(vc)
            vc.didMove(toParent: self)
            vc.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
            views.append(vc.view)
        }
        
        collectionView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(scrollViews(notification:)), name: YTBConstant.selectedMenuNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hiddenBar(notification:)), name: YTBConstant.hiddenMenuNotificationName, object: nil)
    }
    
    
    @objc private func scrollViews(notification: Notification) {
        if var info = notification.userInfo as? [String: Int] {
            collectionView.scrollToItem(at: IndexPath(item: info[YTBConstant.NotificationInfoIndex]!, section: 0),
                                        at: .centeredHorizontally,
                                        animated: true)
        }
        
    }
    
    @objc private func hiddenBar(notification: Notification) {
        let status = notification.object as! Bool
        self.navigationController?.setNavigationBarHidden(status, animated: true)
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return views.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.contentView.addSubview(views[indexPath.row])
        return cell;
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height + 22)
    }
}

extension MainViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollIndex = scrollView.contentOffset.x / view.bounds.width
        NotificationCenter.default.post(name: YTBConstant.scrollMenuNotificationName, object: nil, userInfo: [YTBConstant.NotificationInfolength: scrollIndex])
    }
}


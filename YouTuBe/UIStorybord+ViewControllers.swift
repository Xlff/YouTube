//
//  UIStorybord+ViewControllers.swift
//  YouTuBe
//
//  Created by Max xie on 2019/9/19.
//

import UIKit

extension UIStoryboard {
    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
}


extension UIStoryboard {
//    var loginViewController: LoginViewController {
//        guard let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
//            fatalError("LoginViewController couldn't be found in Storyboard file")
//        }
//        return vc
//    }
    
    var homeViewController: YTBHomeViewController {
        guard let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "YTBHomeViewController") as? YTBHomeViewController else {
            fatalError("DiscoverViewController couldn't be found in Storyboard file")
        }
        return vc
    }
    
    var trendingViewController: YTBTrendingViewController {
        guard let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "YTBTrendingViewController") as? YTBTrendingViewController else {
            fatalError("DetailViewController couldn't be found in Storyboard file")
        }
        return vc
    }
    
    var subscriptionViewController: YTBSubscriptionsViewController {
        guard let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "YTBSubscriptionsViewController") as? YTBSubscriptionsViewController else {
            fatalError("SearchViewController couldn't be found in Storyboard file")
        }
        return vc
    }
    
    var accountViewController: YTBAccountViewController {
        guard let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "YTBAccountViewController") as? YTBAccountViewController else {
            fatalError("SearchViewController couldn't be found in Storyboard file")
        }
        return vc
    }
}

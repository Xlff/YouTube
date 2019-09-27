//
//  YTBPlayerView.swift
//  YouTuBe
//
//  Created by Max xie on 2019/9/23.
//

import UIKit
import AVFoundation

protocol PlayerVCDelegate {
    func didMinimize()
    func didmaximize()
    func swipeToMinimize(translation: CGFloat, toState: StateOfVC)
    func didEndedSwipe(toState: StateOfVC)
    func setPreferStatusBarHidden(_ preferHidden: Bool)
}

class YTBPlayerView: UIView {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var minimizeButton: UIButton!
    @IBOutlet weak var player: UIView!
    
    var video: Video!
    var delegate: PlayerVCDelegate?
    var state = StateOfVC.hidden
    var direction = Direction.none
    var videoPlayer = AVPlayer()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    private func customization() {
        self.backgroundColor = .clear
        self.tableView.estimatedRowHeight = 90
        tableView.tableFooterView = UIView()
        player.layer.anchorPoint.applying(CGAffineTransform(translationX: -0.5, y: -0.5))
        player.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                           action: #selector(tapPlayView)))
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(tapPlayView),
                                               name: YTBConstant.openPlayerViewNotificationName,
                                               object: nil)
    }
    
    private func animate() {
        switch self.state {
        case .fullScreen:
            UIView.animate(withDuration: 0.3) {
                self.minimizeButton.alpha = 1
                self.tableView.alpha = 1
                self.player.transform = CGAffineTransform.identity
                self.delegate?.setPreferStatusBarHidden(true)
            }
        case .minimized:
            UIView.animate(withDuration: 0.3) {
                self.delegate?.setPreferStatusBarHidden(false)
                self.minimizeButton.alpha = 0
                self.tableView.alpha = 0
                let scale = CGAffineTransform(scaleX: 0.5, y: 0.5)
                let transform = scale.concatenating(CGAffineTransform(translationX: -self.player.bounds.width / 4, y: -self.player.bounds.height / 4))
                self.player.transform = transform
            }
        default: break
        }
    }
    
    private func changeValues(scaleFactor: CGFloat) {
        minimizeButton.alpha = 1 - scaleFactor
        tableView.alpha = 1 - scaleFactor
        let scale = CGAffineTransform(scaleX: 1 - 0.5 * scaleFactor, y: 1 - 0.5 * scaleFactor)
        self.player.transform = scale.concatenating(CGAffineTransform(translationX: -self.player.bounds.width / 4 * scaleFactor, y: -self.player.bounds.height / 4 * scaleFactor))
    }
    
    @IBAction func minimize(_ sender: Any) {
        state = .minimized
        delegate?.didMinimize()
        animate()
    }
    @IBAction func minimizeGesture(_ sender: Any) {
    }
    
    @objc func tapPlayView() {
        videoPlayer.play()
        state = .fullScreen
        delegate?.didmaximize()
        animate()
    }
    
    
}

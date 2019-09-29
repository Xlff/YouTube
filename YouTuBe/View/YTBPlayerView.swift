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
        customization()
        Video.fetchVideo { [weak self] downloadedVideo in
            guard let strongSelf = self else { return }
            strongSelf.video = downloadedVideo
            strongSelf.videoPlayer = AVPlayer(url: strongSelf.video.videoLink)
            let playerLayer = AVPlayerLayer(player: strongSelf.videoPlayer)
            playerLayer.frame = strongSelf.player.frame
            playerLayer.videoGravity = .resizeAspectFill
            
            strongSelf.player.layer.addSublayer(playerLayer)
            if strongSelf.state != .hidden {
                strongSelf.videoPlayer.play()
            }
            strongSelf.tableView.reloadData()
        }
    }
    
    private func customization() {
        self.backgroundColor = .clear
        self.tableView.estimatedRowHeight = 90
//        tableView.tableFooterView = UIView()
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
    @IBAction func minimizeGesture(_ sender: UIPanGestureRecognizer) {
        
        if sender.state == .began {
            let velocity = sender.velocity(in: nil)
            self.direction = abs(velocity.x) < abs(velocity.y) ? .up : .left
        }
        
        var finalState = StateOfVC.fullScreen
        switch self.state {
        case .fullScreen:
            let factor = (abs(sender.translation(in: nil).y) / UIScreen.main.bounds.height)
            changeValues(scaleFactor: factor)
            delegate?.swipeToMinimize(translation: factor, toState: .minimized)
            finalState = .minimized
        case .minimized:
            if self.direction == .left {
                finalState = .hidden
                let factor: CGFloat = sender.translation(in: nil).x
                delegate?.swipeToMinimize(translation: factor, toState: .hidden)
            }
            else {
                finalState = .fullScreen
                let factor = 1 - (abs(sender.translation(in: nil).y) / UIScreen.main.bounds.height)
                changeValues(scaleFactor: factor)
                delegate?.swipeToMinimize(translation: factor, toState: .fullScreen)
            }
            
        default:
            break
        }
        
        if sender.state == .ended {
            self.state = finalState
            self.animate()
            delegate?.didEndedSwipe(toState: self.state)
            if state == .hidden {
                videoPlayer.pause()
            }
        }
        
    }
    
    @objc func tapPlayView() {
        videoPlayer.play()
        state = .fullScreen
        delegate?.didmaximize()
        animate()
    }
}

extension YTBPlayerView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = video?.suggestedVideos.count else { return 0 }
        return count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = self.video.suggestedVideos[indexPath.row - 1].channelName
            cell.detailTextLabel?.text = self.video.suggestedVideos[indexPath.row - 1].title
            cell.imageView?.image = self.video.suggestedVideos[indexPath.row - 1].thumbnail
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! YTBHeaderCell
        cell.titleLabel.text = video.title
        cell.contentLabel.text = "\(video.views) views"
        cell.likesLabel.text = String(video.likes)
        cell.disLikesLabel.text = String(video.disLikes)
        cell.channelTitleLabel.text = video.channel.name
        cell.channelSubsribers.text = "\(video.channel.subscribers) subscribers"
        cell.channelImageView.image = video.channel.image
        cell.channelImageView.layer.cornerRadius = 25
        cell.channelImageView.clipsToBounds = true
        cell.selectionStyle = .none
        return cell
    }
}


class YTBHeaderCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var disLikesLabel: UILabel!
    @IBOutlet weak var channelTitleLabel: UILabel!
    @IBOutlet weak var channelSubsribers: UILabel!
    @IBOutlet weak var channelImageView: UIImageView!
    
}

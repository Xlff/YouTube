//
//  YTBHomeViewController.swift
//  YouTuBe
//
//  Created by Max xie on 2019/9/19.
//

import UIKit

class YTBHomeViewController: UITableViewController {
    var videos = [Video]()
    var lastContentOffset: CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.estimatedRowHeight = 300
        fetchData()
    }
    
    private func fetchData() {
        Video.fetchVideos { [weak self] response in
            guard let strongSelf = self else { return }
            strongSelf.videos = response
            strongSelf.videos.shuffle()
            strongSelf.tableView.reloadData()
        }
    }

}

extension YTBHomeViewController: UITableViewDataSource {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! YTBVideoCell
        cell.set(video: videos[indexPath.row])
        return cell
    }
}

extension YTBHomeViewController: UITableViewDelegate {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(YTBConstant.openPlayerViewNotificationName)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: YTBConstant.hiddenMenuNotificationName, object: self.lastContentOffset > scrollView.contentOffset.y ? false : true)
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
}


class YTBVideoCell: UITableViewCell {
    
    @IBOutlet weak var videoThumbnailImageView: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var channelPic: UIImageView!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var videoDescLabel: UILabel!
    
    private func customization() {
        channelPic.layer.cornerRadius = 24
        channelPic.clipsToBounds = true
        durationLabel.layer.borderColor = UIColor.white.cgColor
        durationLabel.layer.borderWidth = 0.5
        durationLabel.sizeToFit()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        videoThumbnailImageView.image = UIImage(named: "emptyThumbnail")
        durationLabel.text = nil
        channelPic.image = nil
        videoTitleLabel.text = nil
        videoDescLabel.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customization()
    }
}

extension YTBVideoCell {
    func set(video: Video) {
        videoThumbnailImageView.image = video.thumbnail
        durationLabel.text = "\(video.duration.secondsToFormattedString())"
        durationLabel.layer.borderColor = UIColor.lightGray.cgColor
        durationLabel.layer.borderWidth = 1.0
        channelPic.image = video.channel.image
        videoTitleLabel.text = video.title
        videoDescLabel.text = "\(video.channel.name)  • \(video.views)"
    }
}

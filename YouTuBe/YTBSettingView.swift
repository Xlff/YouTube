//
//  YTBSettingView.swift
//  YouTuBe
//
//  Created by Max xie on 2019/9/20.
//

import UIKit

class YTBSettingView: UIView {

    @IBOutlet weak var backgroudView: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    private let items = ["Settings", "Terms & privacy policy", "Send Feedback", "Help", "Switch Account", "Cancel"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroudView.alpha = 0
        tableViewBottomConstraint.constant = -tableView.bounds.height
        layoutIfNeeded()
    }
    
    

    @IBAction func hideSettingsView(_ sender: Any) {
        tableViewBottomConstraint.constant = -tableView.bounds.height
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroudView.alpha = 0
            self.layoutIfNeeded()
        }) { _ in
            self.isHidden = true
        }
    }
}

extension YTBSettingView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = self.items[indexPath.row]
        cell.imageView?.image = UIImage(named: self.items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hideSettingsView(self)
    }
    
}

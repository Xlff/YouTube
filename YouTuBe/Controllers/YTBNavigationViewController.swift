//
//  YTBNavigationViewController.swift
//  YouTuBe
//
//  Created by Max xie on 2019/9/23.
//

import UIKit

class YTBNavigationViewController: UINavigationController {

    @IBOutlet var searchView: YTBSearhView!
    @IBOutlet var settingView: YTBSettingView!
    @IBOutlet var playerView: YTBPlayerView!
    private let names = ["Home", "Trending", "Subscriptions", "Account"]
    
    private var isHidden = true {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    
   private let hiddenOrigin: CGPoint = {
        let y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32 ) - 10
        let x = -UIScreen.main.bounds.width
        return CGPoint(x: x, y: y)
    }()
   private let minimizedOrigin: CGPoint = {
        let mainBounds = UIScreen.main.bounds
        return CGPoint(x: mainBounds.width / 2 - 10, y: mainBounds.height - (mainBounds.width * 9 / 32) - 10)
    }()
   private let fullScreenOrigin = CGPoint(x: 0, y: 0)
    
    private lazy var settingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = .white
        button.setImage(UIImage(named: "navSetting"), for: .normal)
        button.addTarget(self,
                         action: #selector(showSettings),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = .white
        button.setImage(UIImage(named: "navSearch"), for: .normal)
        button.addTarget(self,
                         action: #selector(showSearchView),
                         for: .touchUpInside)
        return button
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        label.text = names.first
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customization()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeTitle(notification:)),
                                               name: YTBConstant.scrollMenuNotificationName,
                                               object: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return isHidden
    }
    
    private func customization() {
        navigationBar.addSubview(settingButton)
        settingButton.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(settingButton.snp.height)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(10)
        }
        
        navigationBar.addSubview(searchButton)
        searchButton.snp.makeConstraints { make in
            make.height.width.centerY.equalTo(settingButton)
            make.right.equalTo(settingButton.snp.left).offset(-10)
        }
        
        navigationBar.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        }
        
        navigationBar.barTintColor = UIColor.init(r: 228, g: 34, b: 24)
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationItem.hidesBackButton = true
        
        self.view.addSubview(searchView)
        guard let _ = self.view else {
            return
        }
        searchView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(settingView)
        settingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        playerView.frame = CGRect(origin: hiddenOrigin, size: UIScreen.main.bounds.size)
        playerView.delegate = self
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let widonw = UIApplication.shared.keyWindow {
            widonw.addSubview(playerView)
        }
    }
    
    @objc private func showSettings() {
        settingView.isHidden = false
        settingView.tableViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.settingView.backgroudView.alpha = 0.5
            self.settingView.layoutIfNeeded()
        }
    }
    @objc private func showSearchView() {
        searchView.alpha = 0
        searchView.isHidden = false
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.searchView.alpha = 1
        }) { _ in
            self.searchView.inputTextField.becomeFirstResponder()
        }
    }
    
    @objc private func changeTitle(notification: Notification) {
        if let info = notification.userInfo as? [String: CGFloat] {
            self.titleLabel.text = names[Int(round(info[YTBConstant.NotificationInfolength]!))]
        }
    }
}


extension YTBNavigationViewController: PlayerVCDelegate {
    func didMinimize() {
        animatePlayView(toState: .minimized)
    }
    
    func didmaximize() {
        animatePlayView(toState: .fullScreen)
    }
    
    func swipeToMinimize(translation: CGFloat, toState: StateOfVC) {
        switch toState {
        case .hidden:
            playerView.frame.origin.x = UIScreen.main.bounds.width / 2 - abs(translation) - 10
        default:
            playerView.frame.origin = positionDuringSwipe(scaleFactor: translation)
        }
    }
    
    func didEndedSwipe(toState: StateOfVC) {
        animatePlayView(toState: toState)
    }
    
    func setPreferStatusBarHidden(_ preferHidden: Bool) {
        isHidden = preferHidden
    }
    
    private func animatePlayView(toState: StateOfVC) {
        switch toState {
        case .fullScreen:
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 5,
                           options: [.beginFromCurrentState],
                           animations: {
                            self.playerView.frame.origin = self.fullScreenOrigin
            })
        case .minimized:
            UIView.animate(withDuration: 0.3) {
                self.playerView.frame.origin = self.minimizedOrigin
            }
        case .hidden:
            UIView.animate(withDuration: 0.3) {
                self.playerView.frame.origin = self.hiddenOrigin
            }
        }
    }
    private func positionDuringSwipe(scaleFactor: CGFloat) -> CGPoint {
        let width = UIScreen.main.bounds.width * 0.5 * scaleFactor
        let height = width * 9 / 16
        let x = (UIScreen.main.bounds.width - 10) * scaleFactor - width
        let y = (UIScreen.main.bounds.height - 10) * scaleFactor - height
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }
}

//
//  MainView.swift
//  IVPNClient
//
//  Created by Juraj Hilje on 01/04/2020.
//  Copyright © 2020 IVPN. All rights reserved.
//

import UIKit
import NetworkExtension

class MainView: UIView {
    
    // MARK: - @IBOutlets -
    
    @IBOutlet weak var infoAlertView: InfoAlertView!
    @IBOutlet weak var mapScrollView: MapScrollView!
    
    // MARK: - Properties -
    
    let markerView = MapMarkerView()
    private var infoAlertViewModel = InfoAlertViewModel()
    private let markerContainerView = MapMarkerContainerView()
    
    // MARK: - View lifecycle -
    
    override func awakeFromNib() {
        initMarker()
        initSettingsAction()
        initInfoAlert()
        updateInfoAlert()
    }
    
    // MARK: - Methods -
    
    func setupView() {
        setupConstraints()
        updateInfoAlert()
        updateMarker()
    }
    
    func updateStatus(vpnStatus: NEVPNStatus) {
        markerView.status = vpnStatus
    }
    
    // MARK: - Private methods -
    
    private func initMarker() {
        markerContainerView.addSubview(markerView)
        addSubview(markerContainerView)
    }
    
    private func initSettingsAction() {
        let settingsButton = UIButton()
        addSubview(settingsButton)
        settingsButton.bb.size(width: 42, height: 42).top(55).right(-30)
        settingsButton.setupIcon(imageName: "icon-settings")
        settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        
        let accountButton = UIButton()
        addSubview(accountButton)
        if UIDevice.current.userInterfaceIdiom == .pad {
            accountButton.bb.size(width: 42, height: 42).top(55).right(-100)
        } else {
            accountButton.bb.size(width: 42, height: 42).top(55).left(30)
        }
        accountButton.setupIcon(imageName: "icon-user")
        accountButton.addTarget(self, action: #selector(openAccountInfo), for: .touchUpInside)
    }
    
    private func initInfoAlert() {
        infoAlertView.delegate = infoAlertViewModel
        bringSubviewToFront(infoAlertView)
    }
    
    private func setupConstraints() {
        mapScrollView.setupConstraints()
        markerContainerView.setupConstraints()
    }
    
    private func updateInfoAlert() {
        if infoAlertViewModel.shouldDisplay {
            infoAlertViewModel.update()
            infoAlertView.show(type: infoAlertViewModel.type, text: infoAlertViewModel.text, actionText: infoAlertViewModel.actionText)
        } else {
            infoAlertView.hide()
        }
    }
    
    private func updateMarker() {
        markerView.connectionInfoPopup.updateView()
    }
    
    @objc private func openSettings(_ sender: UIButton) {
        if let topViewController = UIApplication.topViewController() as? MainViewControllerV2 {
            topViewController.openSettings(sender)
        }
    }
    
    @objc private func openAccountInfo(_ sender: UIButton) {
        if let topViewController = UIApplication.topViewController() as? MainViewControllerV2 {
            topViewController.openAccountInfo(sender)
        }
    }
    
}

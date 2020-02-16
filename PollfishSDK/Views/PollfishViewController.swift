//
//  PollfishViewController].swift
//  Pollfish SDK
//
//  Created by Tacenda on 1/24/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//
import UIKit
import WebKit

internal class PollfishViewController: UIViewController, PollfishViewDelegate {
    internal weak var viewModel: PollfishViewModel?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if let request = viewModel?.urlRequest() {
            viewModel?.webView?.load(request)
        }
        
        constraints()
    }
    
    public override func loadView() {
        super.loadView()
        
        viewModel?.updateView(frame: view.frame)
        viewModel?.initWebView()
        view = viewModel?.webView
        view.layer.zPosition = 9999
    }
    
    internal func showPoll() {
        viewModel?.showPoll()
    }
    
    private func hidePoll() {
        viewModel?.hidePoll()
    }
    
    private func constraints() {
        guard let viewModel = viewModel else { return }
        if let webView = viewModel.webView {
            let closeButton = viewModel.closeButton
            let adIDLabel = viewModel.adIDLabel
            let param1 = viewModel.param1
            let param2 = viewModel.param2
            
            webView.addSubview(closeButton)
            webView.addSubview(adIDLabel)
            webView.addSubview(param1)
            webView.addSubview(param2)
            NSLayoutConstraint.activate([
                closeButton.topAnchor.constraint(equalTo: webView.safeTopAnchor),
                closeButton.heightAnchor.constraint(equalToConstant: 40),
                closeButton.widthAnchor.constraint(equalToConstant: 40),
                closeButton.leftAnchor.constraint(equalTo: webView.safeLeftAnchor, constant: 15),
                
                adIDLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                adIDLabel.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
                
                param1.topAnchor.constraint(equalTo: webView.safeTopAnchor),
                param1.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
                param2.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
                param2.bottomAnchor.constraint(equalTo: webView.safeBottomAnchor),
            ])
        }
    }
    
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let newFrame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        viewModel?.updateView(frame: newFrame)
    }
}

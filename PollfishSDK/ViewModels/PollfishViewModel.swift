//
//  PollfishViewModel.swift
//  Pollfish SDK
//
//  Created by Tacenda on 1/24/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//
import UIKit
import WebKit

internal class PollfishViewModel: NSObject {
    internal weak var delegate: PollfishViewDelegate?
    
    internal var currentState: LoadState {
        return loadingState.currentState
    }
    
    internal var webView: WKWebView?
    internal var offScreenFrame: CGRect!
    internal var onScreenFrame: CGRect!
    
    private var openCallback: (() -> Void)?
    private var closeCallback: (([String]) -> Void)?
    private var internalShowingValue = false
    private var semaphore = DispatchSemaphore(value: 1)
    private var remaingParamsToSendOnClose: [String]
    
    internal lazy var closeButton: UIButton = {
        let returnView = UIButton()
        returnView.isUserInteractionEnabled = true
        returnView.translatesAutoresizingMaskIntoConstraints = false
        returnView.setTitle("X", for: .normal)
        returnView.setTitleColor(.black, for: .normal)
        returnView.titleLabel?.font = UIFont.boldSystemFont(ofSize: 42)
        returnView.accessibilityIdentifier = "PollfishWebView_Close"
        return returnView
    }()
    
    internal lazy var adIDLabel: UILabel = {
        let returnView = UILabel()
        returnView.translatesAutoresizingMaskIntoConstraints = false
        returnView.textColor = .red
        returnView.text = "#_AD_ID_"
        returnView.accessibilityIdentifier = "AD_ID"
        return returnView
    }()
    
    internal lazy var param1: UILabel = {
        let returnView = UILabel()
        returnView.translatesAutoresizingMaskIntoConstraints = false
        returnView.textColor = .red
        returnView.text = "#param1"
        return returnView
    }()
    
    internal lazy var param2: UILabel = {
        let returnView = UILabel()
        returnView.translatesAutoresizingMaskIntoConstraints = false
        returnView.textColor = .red
        returnView.text = "#param2"
        return returnView
    }()
    
    private var loadingState = LoadStateViewModel()
    
    internal init(apiKey: String, params: PollfishParams,
         openCallback: (() -> Void)?,
         closeCallback: (([String]) -> Void)?) {
        
        //
        //  TODO: We could get rid of these callbacks and just use the notifications...
        //
        self.openCallback = openCallback
        self.closeCallback = closeCallback
        self.remaingParamsToSendOnClose = []
        
        super.init()
        
        guard params.testStrings.count >= 2 else { return }
        param1.text = params.testStrings[0]
        param2.text = params.testStrings[1]
        
        remaingParamsToSendOnClose = Array(params.testStrings[2...])
    }
    
    internal func initWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: offScreenFrame, configuration: webConfiguration)
        webView?.navigationDelegate = self
        webView?.uiDelegate = self
        webView?.accessibilityIdentifier = "PollfishWebView"
        closeButton.addTarget(self, action: #selector(closeClicked), for: .touchUpInside)
    }
    
    @objc private func closeClicked() {
        hidePoll()
    }
    
    internal func urlRequest() -> URLRequest {
        let myURL = URL(string:"https://www.pollfish.com")
        return URLRequest(url: myURL!)
    }
    
    internal func fetchAdID(_ adProtocol: AdSupportProtocol? = nil) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let strongSelf = self else { return }
            guard let adID = AdService.advertisingID(adProtocol) else {
                strongSelf.errorState()
                return
            }
            
            strongSelf.incrementSuccess()
            
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                strongSelf.adIDLabel.text = adID.uuidString
                strongSelf.adIDLabel.sizeToFit()
            }
        }
    }
    
    internal func incrementSuccess() {
        loadingState.incrementSuccess()
        
        if currentState == .success {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.showPoll()
            }
        }
    }
    
    internal func errorState() {
        loadingState.errorState()
    }
    
    internal func updateView(frame newFrame: CGRect) {
        offScreenFrame = CGRect(x: newFrame.width, y: 0, width: newFrame.width, height: newFrame.height)
        onScreenFrame = CGRect(x: 0, y: 0, width: newFrame.width, height: newFrame.height)
        
        if isShowing() {
            webView?.frame = onScreenFrame
        } else {
            webView?.frame = offScreenFrame
        }
    }
    
    internal func showPoll() {
        guard isShowing() == false else { return }
        setShowing(value: true)
        webView?.alpha = 1
        openCallback?()
        NotificationCenter.default.post(name: .pollfishOpened, object: nil)
        UIView.animate(withDuration: 0.42,
                   delay: 0,
                   usingSpringWithDamping: 1,
                   initialSpringVelocity: 1,
                   options: .curveEaseInOut,
                   animations: { [weak self] in
                    
            guard let strongSelf = self else { return }
            strongSelf.webView?.frame = strongSelf.onScreenFrame
        }, completion: nil)
    }
    
    internal func hidePoll() {
        guard isShowing() else { return }
        setShowing(value: false)
        UIView.animate(withDuration: 0.42,
                   delay: 0,
                   usingSpringWithDamping: 1,
                   initialSpringVelocity: 1,
                   options: .curveEaseOut,
                   animations: { [weak self] in
                    
            guard let strongSelf = self else { return }
            strongSelf.webView?.frame = strongSelf.offScreenFrame
        }, completion: { [weak self] _ in
            self?.closeCallback?(self?.remaingParamsToSendOnClose ?? [])
            NotificationCenter.default.post(name: .pollfishClosed, object: nil, userInfo: ["data": self?.remaingParamsToSendOnClose ?? []])
            self?.webView?.alpha = 0
        })
    }
    
    private func setShowing(value: Bool) {
        semaphore.wait()
        internalShowingValue = value
        semaphore.signal()
    }
    
    private func isShowing() -> Bool {
        var returnVal = false
        semaphore.wait()
        returnVal = internalShowingValue
        semaphore.signal()
        return returnVal
    }
}

extension PollfishViewModel: WKNavigationDelegate, WKUIDelegate {
    // 1. Decides whether to allow or cancel a navigation.
    internal func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        decisionHandler(.allow)
        
    }
    
    // 2. Start loading web address
    internal func webView(_ webView: WKWebView,
                 didStartProvisionalNavigation navigation: WKNavigation!) {
    }
    
    // 3. Fail while loading with an error
    internal func webView(_ webView: WKWebView,
                 didFail navigation: WKNavigation!,
                 withError error: Error) {
        errorState()
    }
    
    // 4. WKWebView finish loading
    internal func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        incrementSuccess()
    }
}

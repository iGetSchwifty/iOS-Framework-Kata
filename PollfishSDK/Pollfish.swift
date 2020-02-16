//
//  Pollfish.swift
//  Pollfish SDK
//
//  Created by Tacenda on 1/24/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//
import UIKit

public class Pollfish {
    private static var viewModel: PollfishViewModel?
    private static var viewController: PollfishViewController?
    
    public static func initWith(apiKey: String, params: PollfishParams,
                                openCallback: (() -> Void)?,
                                closeCallback: (([String]) -> Void)?) {
        
        viewModel = PollfishViewModel(apiKey: apiKey, params: params,
                                      openCallback: openCallback,
                                      closeCallback: closeCallback)
        viewModel?.fetchAdID()
        showOnRoot()
    }
    
    public static func show(onView instance: UIViewController) {
        viewController?.view.removeFromSuperview()
        viewController?.removeFromParent()
        viewController = PollfishViewController()
        viewModel?.delegate = viewController
        viewController?.viewModel = viewModel
        instance.addChild(viewController!)
        instance.view.addSubview(viewController!.view)
    }
    
    private static func showOnRoot() {
        if #available(iOS 13, *) {
            if let rvc = UIApplication.shared.windows.first?.rootViewController {
                Pollfish.show(onView: rvc)
            }
        } else {
            if let rvc = UIApplication.shared.keyWindow?.rootViewController {
                Pollfish.show(onView: rvc)
            }
        }
    }
}

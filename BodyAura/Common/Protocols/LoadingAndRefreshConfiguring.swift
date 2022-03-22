//
//  LoadingAndRefreshConfiguring.swift
//  BodyAura
//
//  Created by Abel Osorio on 5/23/19.
//  Copyright © 2019 STRV. All rights reserved.
//

import UIKit

@objc protocol LoadingAndRefreshConfiguring {
    var activityIndicatorShownAt: Date? { get set }
    var refreshButton: UIBarButtonItem? { get set }
}

extension LoadingAndRefreshConfiguring where Self: UIViewController {
    func setupBarButtonItems() {
        refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: nil)
        refreshButton?.tintColor = .blue
        navigationItem.rightBarButtonItem = refreshButton
    }

    func showActivityIndicator() {
        let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityIndicatorView.startAnimating()

        DispatchQueue.main.async { [weak self] in
            self?.navigationItem.rightBarButtonItem?.customView = activityIndicatorView
        }

        activityIndicatorShownAt = Date()
    }

    func showRefreshButton() {
        // This tends to be rather quick. Let's wait additional 1 second
        // to let the spinner animation be shown to the user
        // so that they do not think the button is not working

        var deadline: TimeInterval = 0

        if let activityIndicatorShownAt = activityIndicatorShownAt, activityIndicatorShownAt.timeIntervalSinceNow < 1 {
            deadline = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + deadline) { [weak self] in
            self?.navigationItem.rightBarButtonItem?.customView = nil
        }
    }
}

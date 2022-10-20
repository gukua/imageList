//
//  AlertPresenter.swift
//  Betsson
//
//  Created by Adrian Krzyżowski on 20/10/2022.
//

import UIKit

protocol AlertPresenter {
    func showRetry(message: String, action: (() -> Void)?)
}

class AlertPresenterImplementation: AlertPresenter {
    unowned let viewController: UIViewController

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func showRetry(message: String, action: (() -> Void)?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
                action?()
            }))
            self.viewController.present(alert, animated: true, completion: nil)
        }
    }
}


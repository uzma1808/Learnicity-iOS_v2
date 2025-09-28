//
//  UINavigationController.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 01/08/2025.
//

import Foundation
import UIKit

extension UINavigationController {
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.last(where: {
            debugPrint($0)
            return $0.isKind(of: ofClass) }) {
              popToViewController(vc, animated: animated)
            }

        }

        func popViewControllers(viewsToPop: Int, animated: Bool = true) {
            if viewControllers.count > viewsToPop {
                let vc = viewControllers[viewControllers.count - viewsToPop - 1]
                popToViewController(vc, animated: animated)
            }
        }

        func popBack<T: UIViewController>(toControllerType: T.Type) {
            if var viewControllers: [UIViewController] = self.navigationController?.viewControllers {
                viewControllers = viewControllers.reversed()
                for currentViewController in viewControllers where currentViewController.isKind(of: toControllerType) {
                 //   if currentViewController.isKind(of: toControllerType) {
                        self.navigationController?.popToViewController(currentViewController, animated: true)
                        break
                   // }
                }
            }
        }

}

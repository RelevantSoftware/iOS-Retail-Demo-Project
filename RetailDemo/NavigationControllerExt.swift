//
//  NavigationControllerExt.swift
//  RetailDemo
//
//  Created by Alexey Romanko on 01.03.17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import Foundation
import UIKit

// Swift 3 version, no co-animation (alongsideTransition parameter is nil)
extension UINavigationController {
    public func pushViewController(
        _ viewController: UIViewController,
        animated: Bool,
        completion: @escaping (Void) -> Void)
    {
        pushViewController(viewController, animated: animated)

        guard animated, let coordinator = transitionCoordinator else {
            completion()
            return
        }

        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
}

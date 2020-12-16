//
//  Coordinator.swift
//  Organizer
//
//  Created by Olivier Miserez on 16/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    var presenter: UIViewController? { get set }
    func start()
}

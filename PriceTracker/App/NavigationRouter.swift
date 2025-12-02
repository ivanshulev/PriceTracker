//
//  NavigationRouter.swift
//  PriceTracker
//
//  Created by Ivan Shulev on 2.12.25.
//

import SwiftUI
import Combine

class NavigationRouter: ObservableObject {
    @Published var path = NavigationPath()
}

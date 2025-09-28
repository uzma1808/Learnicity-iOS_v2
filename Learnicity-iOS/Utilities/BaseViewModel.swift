//
//  BaseViewModel.swift
//  RideSharing-Rider-iOS
//
//  Created by UzmaAmjad on 03/04/2024.
//

import Foundation

class BaseViewModel: Hashable, ObservableObject {
    let id = UUID().uuidString
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    static func == (lhs: BaseViewModel, rhs: BaseViewModel) -> Bool {
        lhs.id == rhs.id
    }
}

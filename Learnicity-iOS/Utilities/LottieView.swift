//
//  LottieView.swift
//  Learnicity-iOS
//
//  Created by UzmaKhan on 14/10/2025.
//


import SwiftUI
import Lottie


struct LottieView: UIViewRepresentable {
    var name: String
    var loopMode: LottieLoopMode = .playOnce
    var onCompleted: (() -> Void)? = nil

    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        let animationView = LottieAnimationView(name: name)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.backgroundBehavior = .pauseAndRestore

        containerView.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            animationView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

        animationView.play { finished in
            if finished {
                onCompleted?()
            }
        }

        return containerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Optional updates if needed
    }
}


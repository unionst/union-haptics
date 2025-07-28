//
//  Haptics.swift
//  union-haptics
//
//  Created by Ben Sage on 7/27/25.
//

import Foundation
import SwiftUI

extension Haptics {
    @available(iOS 17.0, *)
    public static func play(_ haptic: SensoryFeedback) {
        switch haptic {
        case .success:
            success()
        case .warning:
            warning()
        case .error:
            error()
        case .selection:
            selection()
        default:
            playImpact(haptic)
        }
    }

    @available(iOS 17.0, *)
    private static func playImpact(_ haptic: SensoryFeedback) {
        if haptic == .impact(weight: .light) {
            light()
        } else if haptic == .impact(weight: .medium) {
            medium()
        } else if haptic == .impact(weight: .heavy) {
            heavy()
        } else if haptic == .impact(flexibility: .rigid) {
            rigid()
        } else if haptic == .impact(flexibility: .solid) {
            print("Solid haptic has not yet been implemented")
        } else if haptic == .impact(flexibility: .soft) {
            soft()
        }
    }
}

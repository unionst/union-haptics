//
//  Haptics.swift
//  union-haptics
//
//  Created by Ben Sage on 6/4/25.
//

import UIKit
import CoreHaptics

@MainActor
public class Haptics {
    private static  var hapticTask: Task<Void, Never>?
    private static var engine: CHHapticEngine?
    private static var player: CHHapticPatternPlayer?

    public static func light(count: UInt = 1) {
        `repeat`(count) {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }

    public static func medium(count: UInt = 1) {
        `repeat`(count) {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }

    public static func heavy(count: UInt = 1) {
        `repeat`(count) {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
    }

    public static func rigid(count: UInt = 1) {
        `repeat`(count) {
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        }
    }

    public static func soft() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }

    public static func success(count: UInt = 1) {
        `repeat`(count) {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }

    public static func selection() {
        UISelectionFeedbackGenerator().selectionChanged()
    }

    public static func error() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }

    public static func warning() {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }

    public static func startLoadingHaptic() {
        hapticTask = Task {
            while !Task.isCancelled {
                DispatchQueue.main.async {
                    Self.selection()
                }
                try? await Task.sleep(for: .seconds(0.02))
            }
        }
    }

    public static func stopLoadingHaptic() {
        hapticTask?.cancel()
    }

    private static func `repeat`(_ count: UInt, action: @escaping () async -> Void) {
        guard count > 0 else { return }
        Task {
            for _ in 1...count {
                await action()
                try? await Task.sleep(for: .seconds(0.13))
            }
        }
    }

    public static func playFile(_ filename: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "ahap") else {
            print("Haptic file not found")
            return
        }

        do {
            if engine == nil {
                engine = try CHHapticEngine()
            }
            try engine?.start()
            let pattern = try CHHapticPattern(contentsOf: url)
            player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: CHHapticTimeImmediate)
        } catch {
            let error = error as? CHHapticError
            print("Error playing haptic file: \(String(describing: error?.code))")
        }
    }

    public static func stopFile() {
        do {
            try player?.cancel()
        } catch {
            print("Error stopping haptic player: \(error)")
        }
    }
}

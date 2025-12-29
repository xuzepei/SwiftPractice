//
//  View+Extension.swift
//  PandaUnion
//
//  Created by xuzepei on 2025/6/6.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, apply: (Self) -> Content) -> some View {
        if condition {
            apply(self)
        } else {
            self
        }
    }
}

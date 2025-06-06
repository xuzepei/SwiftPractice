//
//  NoFoundView.swift
//  PandaUnion
//
//  Created by xuzepei on 2025/6/6.
//

import SwiftUI

struct NoFoundView: View {
    
    var text: String
    var body: some View {
        VStack {
            Image("no_item").padding(.vertical, 2)
            Text(text).font(.title2)
        }.scaleEffect(0.8)
    }
}

#Preview {
    NoFoundView(text: LS("No Device Found"))
}

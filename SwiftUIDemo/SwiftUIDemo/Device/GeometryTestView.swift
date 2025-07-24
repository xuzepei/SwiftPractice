//
//  GeometryTestView.swift
//  SwiftUIDemo
//
//  Created by xuzepei on 2025/6/20.
//

import SwiftUI

struct SearchBarFramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

struct GeometryTestView: View {
    @State private var frame: CGRect = .zero
    @State private var showPopView = false
    
    @State private var searchText = ""

    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack {
                    Button {
                        showPopView = !showPopView
                    } label: {
                        Text("Hello world")
                            .padding()
                            .background(Color.yellow)
                        
                    }
                    .overlay(
                        GeometryReader { geo in
                            Color.clear
                                .preference(key: SearchBarFramePreferenceKey.self, value: geo.frame(in: .named("container")))
                        }
                    )
                }
            }
            
            if showPopView {
                NoFoundView(text: "Pop View")
                    .frame(width: frame.width, height: 4 * 90)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(radius: 8)
                    .position(x: frame.midX,
                              y: frame.maxY + (4 * 90) / 2)
            }
        }
        .coordinateSpace(name: "container")
        .onPreferenceChange(SearchBarFramePreferenceKey.self) { value in
            print("frame: \(value)")
            //注意value可能为.zero的情况
            if value != .zero {
                frame = value
            }
        }
    }
    
}

#Preview {
    GeometryTestView()
}

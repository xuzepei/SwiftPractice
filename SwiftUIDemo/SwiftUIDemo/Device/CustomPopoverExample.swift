//
//  Untitled.swift
//  SwiftUIDemo
//
//  Created by xuzepei on 2025/6/8.
//

import SwiftUI

struct CustomPopoverExample: View {
    @State private var showPopover = false
    @State private var popoverPosition: CGRect = .zero

    var body: some View {
        ZStack {
            VStack {
                Button("Show Popover") {
                    showPopover.toggle()
                }
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                popoverPosition = geo.frame(in: .global)
                            }
                    }
                )
                Spacer()
            }

            if showPopover {
                Color.black.opacity(0.3) // 半透明背景
                    .ignoresSafeArea()
                    .onTapGesture {
                        showPopover = false
                    }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Option 1")
                    Text("Option 2")
                    Text("Option 3")
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 5)
                .frame(width: 200)
                .position(x: popoverPosition.midX, y: popoverPosition.maxY + 60)
            }
        }
    }
}

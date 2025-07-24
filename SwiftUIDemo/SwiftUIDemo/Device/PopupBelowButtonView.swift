//
//  PopupBelowButtonView.swift
//  SwiftUIDemo
//
//  Created by xuzepei on 2025/6/12.
//

import SwiftUI

struct PopupBelowButtonView: View {
    @State private var showPopup = false
    @State private var buttonFrame: CGRect = .zero

    var body: some View {
        ZStack() {
            VStack {
                Spacer().frame(height: 200)

                Button(action: {
                    showPopup.toggle()
                }) {
                    Text("显示弹窗")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .onAppear {
                                buttonFrame = proxy.frame(in: .global)
                            }
                            .onChange(of: showPopup) { _ in
                                buttonFrame = proxy.frame(in: .global)
                            }
                    }
                )

                Spacer()
            }

            if showPopup {
                
                Color.red.opacity(0.3) // 透明遮罩层
                    .ignoresSafeArea()
                    .onTapGesture {
                        showPopup = false
                    }
                
                VStack(spacing: 12) {
                    Text("这是弹窗内容")
                        .font(.body)
//                    Button("关闭") {
//                        showPopup = false
//                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(width: 200)
                .position(x: buttonFrame.midX,
                          y: buttonFrame.maxY + 0) // 按钮下方偏移
            }
        }
        //.edgesIgnoringSafeArea(.all)
        .background(.white)
//        .onTapGesture {
//            showPopup = false
//        }
        //.animation(.easeInOut, value: showPopup)
    }
}

#Preview {
    PopupBelowButtonView()
}

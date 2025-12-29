import SwiftUI

struct FaceScanView: View {
    @State private var scanOffset: CGFloat = -200
    @State private var moveDown = true
    @State private var isScanning = true
    @State private var showComplete = false
    
    var body: some View {
        ZStack {
            // 背景人脸图像
            Image("face")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 400)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.3), lineWidth: 1))
                .shadow(radius: 5)
            
            if isScanning {
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.clear,
                                Color.white.opacity(0.6),
                                Color.clear
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 80)
                    .offset(y: scanOffset)
                    .blur(radius: 4)
                    .blendMode(.screen)
                    .onAppear {
                        startOneWayLoop()
                    }
            }
            
            if showComplete {
                Text("扫描完成")
                    .font(.title2.bold())
                    .foregroundColor(.green)
                    .shadow(radius: 2)
                    .transition(.opacity)
            }
        }
        .frame(width: 300, height: 400)
        .background(Color.black.opacity(0.8))
        .cornerRadius(16)
        .onTapGesture {
            // 点击停止扫描并显示“完成”
            stopScan()
        }
    }
    
    func startOneWayLoop() {
        let animation = Animation.linear(duration: 2)
        Task {
            while isScanning {
                scanOffset = -200
                withAnimation(animation) {
                    scanOffset = 200
                }
                try? await Task.sleep(nanoseconds: 2_000_000_000)
            }
        }
    }

    func stopScan() {
        withAnimation(.easeInOut(duration: 0.8)) {
            isScanning = false
            showComplete = true
        }
    }
}

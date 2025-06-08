//
//  Test.swift
//  SwiftUIDemo
//
//  Created by xuzepei on 2025/6/8.
//

import SwiftUI

struct TestContentView: View {

    @State private var searchText = ""
    @StateObject private var deviceModel = DeviceModel()
    @State var isPullToRefresh = false
    
    @State private var offset: CGFloat = 0
    @State private var reachedBottom = false
    
    @State private var showDialog = false

    var body: some View {
        NavigationView {
            VStack {
                    ZStack {
                        ScrollView {
                            LazyVStack {
                                ForEach(deviceModel.devices.indices, id: \.self) { index in
                                    let device = deviceModel.devices[index]

                                    NavigationLink {
                                        
                                    } label: {
                                        
                                        VStack {
                                            HStack {
                                                DeviceCell(device: device)
                                                    .onAppear {
                                                        // 检查是否滚动到最后一个
                                                        //print("index: \(index)")
                                                        print("deviceModel.lastItemIndex: \(deviceModel.lastItemIndex)")
                                                        
                                                        if device.number == deviceModel.devices[deviceModel.devices.count-1].number && !deviceModel.isLoadingMore {
                                                            deviceModel.loadMore(listType: 0, keyword: searchText) {}
                                                        }
                                                    }
                                                    .id(device.number)
                                                
                                                Spacer()
                                                Image(systemName: "chevron.right").foregroundColor(.gray)
                                            }
                                        }

                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .padding(.horizontal)
                                    .padding(.vertical, 4)
                                    
                                    Divider()
                                        .padding(.leading)
                                }
                                
                                
                                // 加载中时添加一行 spinner
                                if deviceModel.isLoadingMore {
                                    
                                    HStack {
                                        Spacer()
                                        ProgressView()
                                            .padding()
                                        Spacer()
                                    }
                                    .id("LoadingIndicator")
                                }
                            }
                        }
                        .refreshable {
                            guard !deviceModel.isLoadingMore else { return } // 防止重复触发
                            self.isPullToRefresh = true
                            await deviceModel.asyncFetch(listType: 0, keyword: searchText)
                            self.isPullToRefresh = false
                        }
                        
                        if deviceModel.isLoading && self.isPullToRefresh == false {
                            VStack {
                                Spacer()
                                ProgressView("Loading...")
                                Spacer()
                            }
                        }
                    }

                
                Spacer()
            }
            .navigationTitle("Device Management")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            deviceModel.fetch(listType: 0, keyword: searchText) {}
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func loadMore() {
        deviceModel.loadMore(listType: 0, keyword: "") {}
    }
}

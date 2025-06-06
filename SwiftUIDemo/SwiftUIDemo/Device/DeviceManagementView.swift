//
//  DeviceManagementView.swift
//  PandaUnion
//
//  Created by xuzepei on 2025/6/4.
//

import SwiftUI

struct DeviceManagementView: View {
    
    @Environment(\.dismiss) var dismiss // <- Access system pop/dismiss action
    
    @State private var searchText = ""
    @StateObject private var deviceModel = DeviceModel()
    @State var isPullToRefresh = false
    
    @State private var offset: CGFloat = 0
    @State private var reachedBottom = false
    
    @State private var showDialog = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass") // 左侧图标
                            .foregroundStyle(.gray)
                        TextField(LS("Device Name/Device S/N"), text: $searchText)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .submitLabel(.search)
                            .onSubmit {
                                deviceModel.fetch(listType: 0, keyword: searchText) {
                                }
                            }
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = "" // 清除文本
                                deviceModel.fetch(listType: 0, keyword: searchText) {
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.leading)
                    
                    Menu {
                        Button("编辑", action: {})
                        Button("删除", role: .destructive, action: {})
                        Button("分享", action: {})
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title)
                    }
                    
                    
                    Button {
                        
                        showDialog = true
                        
                    } label: {
                        Image("sorting")
                            .renderingMode(.template) // 👈 放在最前面
                            .resizable()
                            .frame(width: 38, height: 38)
                            .foregroundColor(.gray)
                    }.confirmationDialog("选择操作", isPresented: $showDialog, titleVisibility: .visible) {
                        Button("编辑", action: {})
                        Button("删除", role: .destructive, action: {})
                        Button("取消", role: .cancel) {}
                    }
                    
                    Button {
                        
                    } label: {
                        Image("filter1").renderingMode(.template)
                            .resizable()
                            .frame(width: 26, height: 26)
                            .foregroundColor(.gray)
                    }.padding(.trailing, 6)
                    Spacer()
                }
                
                if deviceModel.devices.count == 0 && deviceModel.isLoading == false {
                    Spacer()
                    NoFoundView(text:LS("No Device Found"))
                } else {
                    ZStack {
                        ScrollViewReader { proxy in
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
                                                            print("index: \(index)")
                                                            print("deviceModel.lastItemIndex: \(deviceModel.lastItemIndex)")
//                                                            if index == deviceModel.lastItemIndex && !deviceModel.isLoadingMore {
//                                                                deviceModel.loadMore(listType: 0, keyword: searchText) {}
//                                                            }
//
                                                            if index == deviceModel.devices.count - 1 {
                                                                reachedBottom = true
                                                            }
                                                        }
                                                        .id(index)
                                                    
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
                                    
                                    GeometryReader { geo in
                                        Color.clear
                                            .frame(height: 1)
                                            .onAppear {
                                                //reachedBottom = true
                                            }
                                            .onChange(of: geo.frame(in: .global).minY) { newY in
                                                // 触发 loadMore 的距离阈值
                                                let triggerDistance: CGFloat = 700
                                                
                                                print("reachedBottom: \(reachedBottom)")
                                                print("newY: \(newY)")
                                                
                                                if reachedBottom && !deviceModel.isLoadingMore && newY < triggerDistance {
                                                    
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                        withAnimation {
                                                            proxy.scrollTo("LoadingIndicator", anchor: .top)
                                                        }
                                                    }
                                                    
                                                    deviceModel.loadMore(listType: 0, keyword: searchText) {
                                                        DispatchQueue.main.async {
                                                            withAnimation {
                                                                proxy.scrollTo(deviceModel.devices.count - 1, anchor: .top)
                                                            }
                                                        }
                                                    }
                                                    reachedBottom = false
                                                }
                                            }
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
                            .if(!deviceModel.isLoadingMore) { view in
                                view.refreshable {
                                    self.isPullToRefresh = true
                                    await deviceModel.asyncFetch(listType: 0, keyword: searchText)
                                    self.isPullToRefresh = false
                                }
                            }
                        }
                        
                        
                        if deviceModel.isLoading && self.isPullToRefresh == false {
                            VStack {
                                Spacer()
                                ProgressView("Loading...")
                                Spacer()
                            }
                        }
                        
                    }
                    
                }
                
                Spacer()
                
            }
            .navigationTitle(LS("Device Management"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // 左边返回按钮
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image("back")
                    }
                }
                
                //右边更多按钮
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName:"ellipsis")
                            .foregroundStyle(.black)
                            .rotationEffect(.degrees(90))
                    }
                    
                }
            }
        }
        .onAppear {
            deviceModel.fetch(listType: 0, keyword: searchText) {}
        }
        .navigationViewStyle(StackNavigationViewStyle())
        //.searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search items")
    }
}

#Preview {
    DeviceManagementView()
}

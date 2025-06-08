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
    
    @State private var selectedOption = "Option 1"
    let options = ["Option 1", "Option 2", "Option 3"]
    
    @State private var showMultiSelect = false
    @State private var selectedOptions: Set<String> = ["Option 1"]
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass") // 左侧图标
                            .foregroundStyle(.gray)
                        TextField("Device Name/Device S/N", text: $searchText)
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
                        ForEach(options, id: \.self) { option in
                            Button(action: {
                                selectedOption = option
                            }) {
                                Label(option, systemImage: selectedOption == option ? "checkmark" : "")
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title)
                    }.padding(.leading)
                    
                    Button {
                        showMultiSelect = true
                    }
                    label: {
                        Image(systemName: "star.fill")
                    }
                    .padding(.horizontal)
                    .popover(isPresented: $showMultiSelect) {
                        VStack {
                            ForEach(options, id: \.self) { option in
                                Toggle(option, isOn: Binding(
                                    get: { selectedOptions.contains(option) },
                                    set: { isSelected in
                                        if isSelected {
                                            selectedOptions.insert(option)
                                        } else {
                                            selectedOptions.remove(option)
                                        }
                                    }
                                ))
                            }
                            Button("Done") {
                                showMultiSelect = false
                            }
                            .padding(.top)
                        }
                        .padding()
                    }
//
//                    
//                    Button {
//                        
//                        showDialog = true
//                        
//                    } label: {
//                        Image("sorting")
//                            .renderingMode(.template) // 👈 放在最前面
//                            .resizable()
//                            .frame(width: 38, height: 38)
//                            .foregroundColor(.gray)
//                    }.confirmationDialog("选择操作", isPresented: $showDialog, titleVisibility: .visible) {
//                        Button("编辑", action: {})
//                        Button("删除", role: .destructive, action: {})
//                        Button("取消", role: .cancel) {}
//                    }
                }
                
                if deviceModel.devices.count == 0 && deviceModel.isLoading == false {
                    Spacer()
                    NoFoundView(text:"No Device Found")
                } else {
                    ZStack {
                        ScrollViewReader { proxy in
                            ScrollView {
                                LazyVStack {
                                    ForEach(deviceModel.devices, id: \.number) { device in
                                        
                                        //let device = deviceModel.devices[index]
                                        
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

//                                                            if index == deviceModel.devices.count - 1 {
//                                                                reachedBottom = true
//                                                            }
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
                                    
//                                    GeometryReader { geo in
//                                        Color.clear
//                                            .frame(height: 1)
//                                            .onAppear {
//                                                //reachedBottom = true
//                                            }
//                                            .onChange(of: geo.frame(in: .global).minY) { newY in
//                                                // 触发 loadMore 的距离阈值
//                                                let triggerDistance: CGFloat = 700
//                                                
//                                                print("reachedBottom: \(reachedBottom)")
//                                                print("newY: \(newY)")
//                                                
//                                                if reachedBottom && !deviceModel.isLoadingMore && newY < triggerDistance {
//                                                    
//                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                                                        withAnimation {
//                                                            proxy.scrollTo("LoadingIndicator", anchor: .top)
//                                                        }
//                                                    }
//                                                    
//                                                    deviceModel.loadMore(listType: 0, keyword: searchText) {
//                                                        DispatchQueue.main.async {
//                                                            withAnimation {
//                                                                proxy.scrollTo(deviceModel.devices.count - 1, anchor: .top)
//                                                            }
//                                                        }
//                                                    }
//                                                    reachedBottom = false
//                                                }
//                                            }
//                                    }

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
            .navigationTitle("Device Management")
            .navigationBarTitleDisplayMode(.inline)
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

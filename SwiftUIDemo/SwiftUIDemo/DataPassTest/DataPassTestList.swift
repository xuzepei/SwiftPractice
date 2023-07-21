//
//  DataPassTestList.swift
//  SwiftUIDemo
//
//  Created by xuzepei on 2023/7/18.
//

import SwiftUI

struct DataPassTestList: View {
    
    let itemArray = ["使用 @State 和 @Binding", "使用环境对象@EnvironmentObject","使用 @ObservedObject 属性包装器","使用环境键和环境值 (没实现)"]
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(itemArray.enumerated()), id: \.offset) { index, element in
                    NavigationLink {
                        
                        if index == 0 {
                            DataPassTestState()
                        } else if index == 1 {
                            DataPassTestEnviromentObject().environmentObject(UserSettings())
                        } else if index == 2 {
                            DataPassTestObservedObject(userData: UserData())
                        } else if index == 3 {
                            DataPassTestEnvironmentKeyValue()
                        }
                            
                    } label: {
                        Text(element)
                    }
                }
            }
            .navigationTitle("SwiftUI中数值传递")
        }
    }
}

struct DataPassTestList_Previews: PreviewProvider {
    static var previews: some View {
        DataPassTestList()
    }
}

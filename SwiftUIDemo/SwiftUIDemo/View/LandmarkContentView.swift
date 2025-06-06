//
//  LandmarkContentView.swift
//  SwiftUIDemo
//
//  Created by xuzepei on 2023/7/14.
//

import SwiftUI

struct LandmarkContentView: View {
    var body: some View {
        LandmarkList()
    }
}

#Preview {
    LandmarkContentView().environmentObject(ModelData())
}

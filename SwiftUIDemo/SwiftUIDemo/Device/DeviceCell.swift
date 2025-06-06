//
//  DeviceCell.swift
//  PandaUnion
//
//  Created by xuzepei on 2025/6/5.
//

import SwiftUI

struct DeviceCell: View {
    
    var device: Device
    
    var body: some View {
        HStack() {
            Image("scanner")
                .renderingMode(.template)
                .resizable()
                .foregroundColor(.black)
                .frame(width: 36, height: 36)
                //.padding(.horizontal, 2)
            VStack(alignment: .leading) {
                HStack {
                    Text(LS("Device Name") + ": " + device.name)
                        .font(.system(size: 16)).padding(.vertical,0.2)
                    
                    if device.encryptType == 2 {
                        Image("lock3").resizable().frame(width: 20, height:20)
                    }
                    
                    if !device.isEndUser {
                        Image("non_user").resizable().frame(width: 24, height:24)
                    }
                }
                Text(LS("Device S/N") + ": " + device.number)
                    .font(.system(size: 16))
                    //.foregroundColor(.gray)
                HStack {
                    Text(LS("Expiration") + ": " + device.getExpirationDateText())
                        .font(.system(size: 16))
                    if let temp = device.getExpirationTip() {
                        Text(temp.0)
                            .font(.system(size: 16))
                            .foregroundStyle(Color(temp.1))
                    }
                }
                
            }
            Spacer()
            
            if device.isNotInCurrentRegion() {
                Group {
                    Text(device.region.uppercased()).font(.system(size: 15, weight: .bold)).foregroundStyle(.white).padding(4)
                }.background(Color(.systemRed)).cornerRadius(4).frame(width:26, height:26)
            }
        }
    }
}

#Preview {
    
    let device:Device = {
        var d = Device()
        d.name = "测试设备"
        d.number = "b2022103101"
        d.registerTime = "2025-11-28"
        d.region = "in"
        d.isEndUser = true
        d.encryptType = 2
        return d
    }()

    DeviceCell(device: device)
}

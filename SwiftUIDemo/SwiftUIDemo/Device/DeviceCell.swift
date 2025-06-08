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
            VStack(alignment: .leading) {
                HStack {
                    Text("Device Name" + ": " + device.name)
                        .font(.system(size: 16)).padding(.vertical,0.2)
                }
                Text("Device S/N" + ": " + device.number)
                    .font(.system(size: 16))
                    //.foregroundColor(.gray)
                HStack {
                    Text("Expiration" + ": " + device.getExpirationDateText())
                        .font(.system(size: 16))
                }
                
            }
            Spacer()
        }
    }
}

#Preview {
    
    let device:Device = {
        var d = Device()
        d.name = "测试设备"
        d.number = "1"
        return d
    }()

    DeviceCell(device: device)
}

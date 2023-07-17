//
//  CircleImage.swift
//  SwiftUIDemo
//
//  Created by xuzepei on 2023/7/14.
//

import SwiftUI

struct CircleImage: View {
    
    var image: Image
    
    var body: some View {
        
        if #available(iOS 15.0, *) {
            //Image("turtlerock")
            image
                .clipShape(Circle())
                .shadow(radius: 7)
                .overlay{
                    Circle().stroke(.white, lineWidth: 4)
                }
            
        } else {
            image
                .clipShape(Circle())
                .shadow(radius: 7)
        }
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(image: Image("turtlerock"))
    }
}

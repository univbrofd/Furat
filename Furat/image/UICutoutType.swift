//
//  UICutoutType.swift
//  Huu
//
//  Created by 浅香紘 on 2020/07/17.
//  Copyright © 2020 浅香紘. All rights reserved.
//

import SwiftUI

struct UICutoutType: View {
    let width = 300.0
    var body: some View {
        ZStack {
         
        HStack {
            Spacer()
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .background(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
            .opacity(0.5)
            VStack(spacing:0) {
                Spacer()
                    .frame(width: CGFloat(width))
                    .frame(maxHeight: .infinity)
                    .background(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                .opacity(0.5)
                UIDountCircle().opacity(0.5)
                    .padding(0)
                .frame(width: CGFloat(width), height: CGFloat(width))
                Spacer()
                    .frame(width: CGFloat(width))
                    .frame(maxHeight: .infinity)
                    .background(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                .opacity(0.5)
            }
            Spacer()
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .background(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
            .opacity(0.5)
        }
            
            Circle()
            .stroke(Color.white, lineWidth: 4)
            .frame(width: CGFloat(width),height: CGFloat(width))
             
        }
    }
}

struct UICutoutType_Previews: PreviewProvider {
    static var previews: some View {
        UICutoutType()
    }
}

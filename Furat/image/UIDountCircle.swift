//
//  UIDountCircle.swift
//  Huu
//
//  Created by 浅香紘 on 2020/07/17.
//  Copyright © 2020 浅香紘. All rights reserved.
//

import SwiftUI

struct UIDountCircle: View {
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Path { path in
                    let width = min(geometry.size.width, geometry.size.height)
                    path.move(to: CGPoint(x: 0, y: width/2))
                    let cPoint1 = width * 0.0455
                    let cPoint2 = width * 0.9545
                    path.addQuadCurve(
                        to: CGPoint(x: width/2, y: 0),
                        control: CGPoint(x:cPoint1, y: cPoint1))
                    path.addQuadCurve(
                        to: CGPoint(x: width, y: width/2),
                        control: CGPoint(x: cPoint2, y: cPoint1))
                    path.addLine(
                        to: CGPoint(x: width, y: 0))
                    path.addLine(
                        to: CGPoint(x: 0, y: 0))
                    
                    path.move(to: CGPoint(x: 0, y: width/2))
                    
                    path.addQuadCurve(
                        to: CGPoint(x: width/2, y: width),
                        control: CGPoint(x:cPoint1, y: cPoint2))
                    path.addQuadCurve(
                        to: CGPoint(x: width, y: width/2),
                        control: CGPoint(x: cPoint2, y: cPoint2))
                    path.addLine(
                        to: CGPoint(x: width, y: width))
                    path.addLine(
                        to: CGPoint(x: 0, y: width))
                }
                .foregroundColor(/*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/)
            }
            
        }
    }
}

struct UIDountCircle_Previews: PreviewProvider {
    static var previews: some View {
        UIDountCircle()
    }
}

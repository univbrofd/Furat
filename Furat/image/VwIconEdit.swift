//
//  UIProfileEdit.swift
//  Huu
//
//  Created by 浅香紘 on 2020/07/17.
//  Copyright © 2020 浅香紘. All rights reserved.
//

import SwiftUI

struct VwIconEdit: View {
    @Environment(\.presentationMode) var presentation
    @Binding var icon: UIImage?
    @Binding var update: Bool
    @Binding var activImageEdit:Bool
    
    @Binding var rawUIImage : UIImage?
    @Binding var rawImage : Image?
    @Binding var iniSize : CGSize?
    
    @State var resizedFinish = false
    
    @State var translateX:CGFloat = 0
    @State var translateY:CGFloat = 0
    
    @State var showGetImageView = true
    @State private var isPressed = false
    @GestureState private var dragOffset = CGSize.zero
    @State private var position = CGSize.zero
    @State var imageRatio: CGFloat = 1.0
    @State var frameWidth: CGFloat = 300
    @State var scale: CGFloat = 1.0
    @State var currentPosition: CGSize = CGSize.zero
    
    var body: some View {
        ZStack {
            rawImage?.resizable()
                .aspectRatio(contentMode: .fit)
                .frame(
                    width: iniSize!.width * imageRatio,
                    height: iniSize!.height * imageRatio)
                .offset(x: position.width + dragOffset.width, y: position.height + dragOffset.height)
                // .clipShape(Circle())
                // .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .gesture(
                    DragGesture()
                        .updating($dragOffset, body: { (value, state, transaction) in
                            state = value.translation
                        })
                    .onEnded({ (value) in
                        self.translateX += value.translation.width
                        self.translateY += value.translation.height
                        self.position.height += value.translation.height
                        self.position.width += value.translation.width
                    })
            )
            
            UICutoutType()
            Slider(value: $imageRatio,in: 1...10)
                .frame(width: 300.0)
                .offset(x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/250.0/*@END_MENU_TOKEN@*/)
    
            VStack{
                Spacer()
                Button(action: {
                    prepareImage()
                    activImageEdit = false
                    self.presentation.wrappedValue.dismiss()
                }, label: {
                    Text("次へ")
                        .padding(10)
                        .padding([.leading,.trailing],30)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: .black, radius: 1, x: 0, y: 0)
                        .padding([.bottom],30)
                })
            }
        }
    }
    
    func prepareImage(){
        let rawSize = rawUIImage?.size
        var scale : CGFloat = iniSize!.width * imageRatio / rawSize!.width
        if rawSize!.height * scale < iniSize!.height {
            scale = iniSize!.height * imageRatio / rawSize!.height
        }
        
        let croppedImsize = CGSize(width: 300/scale, height: 300/scale )
        let offsetX = rawSize!.width/2 - (150+translateX)/scale
        let offsetY = rawSize!.height/2 - (150+translateY)/scale
        let croppedImrect: CGRect = CGRect(x: offsetX, y: offsetY, width: croppedImsize.width, height: croppedImsize.height)

        let r = UIGraphicsImageRenderer(size:croppedImsize)
        let croppedIm = r.image { _ in
                    rawUIImage!.draw(at: CGPoint(x:-croppedImrect.origin.x, y:-croppedImrect.origin.y))
                }
        self.icon = croppedIm
        self.update = true
    }

}


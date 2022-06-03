//
//  VwImageEdit.swift
//  Furat
//
//  Created by 浅香紘 on R 4/04/26.
//

import SwiftUI

struct VwImageEdit: View {
    @State var h_t :CGFloat = 100
    @State var h_b :CGFloat = 100
    @State var w_l :CGFloat = 100
    @State var w_r :CGFloat = 100
    var body: some View {
        ZStack{
            Image("bull_bg1")
                .resizable()
                .scaledToFit()
            vwVFrame()
        }
    }
    
    func vwVFrame() -> some View{
        VStack(spacing:0){
            ZStack(alignment: .bottom){
                Color.gray
                    .frame(height: h_t)
                    .opacity(0.5)
                Rectangle()
                    .fill(Color.red)
                    .frame(width:100,height:10)
                    .gesture(
                        DragGesture().onChanged{ value in
                            print(value)
                            let h_new = h_t + (value.translation.height)
                            if h_new < 10{
                                h_t = 10
                            }else if h_new > 400{
                                h_t = 400
                            }else{
                                h_t = h_new
                            }
                        }
                    )
            }
            vwHFrame()
            ZStack(alignment:.top){
                Color.gray
                    .frame(height: h_b)
                    .opacity(0.5)
                Rectangle()
                    .fill(Color.red)
                    .frame(width:100,height:10)
                    .gesture(
                        DragGesture().onChanged{ value in
                            print(value)
                            let h_new = h_b + -(value.translation.height)
                            if h_new < 10{
                                h_b = 10
                            }else if h_new > 400{
                                h_b = 400
                            }else{
                                h_b = h_new
                            }
                        }
                    )
            }
        }
    }
    func vwHFrame() -> some View{
        HStack(spacing:0){
            ZStack(alignment:.trailing){
                Color.gray
                    .frame(width: w_l)
                    .opacity(0.5)
                Rectangle()
                    .fill(Color.red)
                    .frame(width:10,height: 100)
                    .gesture(
                        DragGesture().onChanged{ value in
                            print(value)
                            let h_new = w_l + (value.translation.width)
                            if h_new < 10{
                                w_l = 10
                            }else if h_new > 400{
                                w_l = 400
                            }else{
                                w_l = h_new
                            }
                        }
                    )
            }
            Spacer().frame(maxWidth:.infinity)
            ZStack(alignment:.leading){
                Color.gray
                    .frame(width: w_r)
                    .opacity(0.5)
                Rectangle()
                    .fill(Color.red)
                    .frame(width:10,height: 100)
                    .gesture(
                        DragGesture().onChanged{ value in
                            print(value)
                            let h_new = w_r + -(value.translation.width)
                            if h_new < 10{
                                w_r = 10
                            }else if h_new > 400{
                                w_r = 400
                            }else{
                                w_r = h_new
                            }
                        }
                    )
                
            }
        }
    }
}

struct VwImageEdit_Previews: PreviewProvider {
    static var previews: some View {
        VwImageEdit()
    }
}

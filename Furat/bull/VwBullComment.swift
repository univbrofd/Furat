//
//  VwBullComment.swift
//  Furat
//
//  Created by 浅香紘 on R 4/05/04.
//

import SwiftUI

struct VwBullComment: View {
    let bullComment :BullComment
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(bullComment.name)
                    .font(.system(size: 7, weight: .light, design: .default))
                Text(getElapsedTime(time1: bullComment.time))
                    .font(.system(size: 5, weight: .light, design: .default))
                Spacer()
            }
            Text(bullComment.text)
                .font(.system(size: 10, weight: .light, design: .default))
        }.frame(maxWidth:.infinity)
            .padding([.leading,.trailing,.bottom],1)
    }
}

/*
struct VwBullComment_Previews: PreviewProvider {
    static var previews: some View {
        VwBullComment()
    }
}
 */

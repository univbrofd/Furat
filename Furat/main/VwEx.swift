//
//  VwEx.swift
//  Furat
//
//  Created by 浅香紘 on R 4/04/01.
//

import Foundation
import SwiftUI

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct TextEditorView: View {
    
    @Binding var string: String
    @State var textEditorHeight : CGFloat = 20
    let explain:String
    let font : Font
    init(_ text:Binding<String>,font:Font){
        self._string = text
        self.font = font
        self.explain = ""
    }
    init(_ text:Binding<String>,font:Font,explain:String){
        self._string = text
        self.font = font
        self.explain = explain
    }
    var body: some View {
        
        ZStack(alignment: .leading) {
            Text(string)
                .font(font)
                .foregroundColor(.clear)
                .padding([.vertical],4)
                .background(GeometryReader {
                    Color.clear.preference(key: ViewHeightKey.self,
                                           value: $0.frame(in: .local).size.height)
                })
            
            TextEditor(text: $string)
                .font(font)
                .frame(height: max(40,textEditorHeight))
            
            if string == "" {
                Text(explain)
                    .foregroundColor(.gray)
                    .padding(10)
            }
                
        }.onPreferenceChange(ViewHeightKey.self) { textEditorHeight = $0 }
        
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}

struct SquareColorPickerView: View {
    
    @Binding var colorValue: Color
    
    var body: some View {
        
        colorValue
            .frame(width: 40, height: 40, alignment: .center)
            .cornerRadius(40.0)
            .overlay(RoundedRectangle(cornerRadius: 40.0).stroke(Color.white, style: StrokeStyle(lineWidth: 1)))
            .padding(5)
            .background(AngularGradient(gradient: Gradient(colors: [.red,.yellow,.green,.blue,.purple,.pink]), center:.center).cornerRadius(40.0))
            .overlay(ColorPicker("", selection: $colorValue,supportsOpacity: false).labelsHidden().opacity(0.015))
            .shadow(radius: 5.0)

    }
}

struct TabItem: ViewModifier {
    let isSelected: Bool
    @ViewBuilder
    func body(content:Content) -> some View {
        if isSelected {
            content
                .padding(3)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(5)
                .padding(1)
        } else {
            content
                .padding(3)
                .foregroundColor(Color(.label))
                .overlay(RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray))
                .padding(1)
        }
    }
}

extension View {
    func decorate(isSelected: Bool) -> some View {
        self.modifier(TabItem(isSelected: isSelected))
    }
}

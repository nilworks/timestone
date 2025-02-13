//
//  MarqueeText.swift
//  timestone
//
//  Created by 조성빈 on 2/13/25.
//

import SwiftUI

//MARK: - 텍스트 슬라이딩 애니메이션(Marquee)
struct MarqueeText: View {
    
    @State var text: String = "회의 싫어요! "
    @State var storedSize: CGSize = .zero
    @State var offset: CGFloat = .zero
    
    @State var changeText: Int = 0
    
    var body: some View {
        GeometryReader { scrollGeometry in
            ScrollView(.horizontal) {
                HStack {
                    Text(text)
                        .fixedSize()
                        .frame(maxWidth: .infinity)
                        .offset(x: offset)
                        .background {
                            GeometryReader { textGeo in
                                Color.clear
                                    .onAppear {
                                        if textGeo.size.width > scrollGeometry.size.width {
                                            text.append("       ")
                                            changeText += 1
                                        }
                                    }
                                    .onChange(of: changeText, perform: { newValue in
                                        storedSize = textGeo.size
                                        let newText = text
                                        text.append(newText)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                            withAnimation(.linear(duration: 5)) {
                                                offset = -storedSize.width
                                            }
                                        }
                                    })
                                    .onReceive(Timer.publish(every: 8, on: .main, in: .default).autoconnect()) { _ in
                                        offset = 0
                                        withAnimation(.linear(duration: 5)) {
                                            offset = -storedSize.width
                                        }
                                    }
                            }
                        }
                }
                .frame(width: scrollGeometry.size.width, height: scrollGeometry.size.height, alignment: .leading)
            }
            .scrollDisabled(true)
        }
    }
    
}

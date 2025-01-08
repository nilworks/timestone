//
//  showDetailEventView.swift
//  timestone
//
//  Created by 이상민 on 12/30/24.
//

import SwiftUI

struct DetailEventView: View {
    var body: some View {
        VStack{
            Text("2024년")
                .font(.caption)
                .foregroundStyle(.neutral70)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 5)
            
            HStack{
                Text("12월 16일 화요일")
                    .font(.captionLight)
                    .foregroundStyle(.neutral60)
                
                Spacer()
                
                Button {
                    // TODO: 일정 추가 UI로 이동
                } label: {
                    Image(systemName: "plus.app")
                        .foregroundStyle(.primary100)
                }
            }//: HSTACK
            .padding(.bottom, 30)
            
            // TODO: ViewBuilder로 빼면 효과적일 것 같음, 혹은 컴포넌트 뷰 생성
            VStack(){
                VStack(alignment: .leading){
                    Text("회의를 합시다")
                        .font(.subTitleBold)
                        .foregroundStyle(.white)
                        .padding(.bottom, 5)
                    
                    HStack{
                        Text("오후 1:00 ~ 오후 2:00")
                            .font(.subBodyRegular)
                            .foregroundStyle(.neutral60)
                        
                        Image(systemName: "clock")
                            .foregroundStyle(.neutral60)
                    }//: HSTACK
                    .padding(.bottom, 25)
                    
                    // TODO: 타이틀, 콘텐츠 반복 뷰 재사용 고려
                    // TODO: 속성은 동일하니 ViewBuilder로 처리해도 상관없을 것 같다
                    Text("메모")
                        .font(.subBodyRegular)
                        .foregroundStyle(.neutral60)
                        .padding(.bottom, 5)
                    
                    Text("오늘도 뚠뚠 즐거운 뚠뚠 회의를 뚠뚠 합시다 뚠뚠")
                        .font(.subBodyRegular)
                        .foregroundStyle(.white)
                        .padding(.bottom, 20)
                    
                    Text("링크")
                        .font(.subBodyRegular)
                        .foregroundStyle(.neutral60)
                        .padding(.bottom, 5)
                    
                    Link("www.naver.com", destination: URL(string: "www.naver.com")!)
                        .font(.subBodyRegular)
                        .foregroundStyle(.white)
                        .padding(.bottom, 20)
                    
                    Text("장소")
                        .font(.subBodyRegular)
                        .foregroundStyle(.neutral60)
                        .padding(.bottom, 5)
                    
                    Image(systemName: "clock")
                        .resizable()
                        .foregroundStyle(.neutral60)
                        .frame(width: 331, height: 125)
                        .padding(.bottom, 20)
                    
                    Text("사진")
                        .font(.subBodyRegular)
                        .foregroundStyle(.neutral60)
                        .padding(.bottom, 5)
                    
                    Image(systemName: "clock")
                        .resizable()
                        .foregroundStyle(.neutral60)
                        .frame(width: 331, height: 125)
                        .padding(.bottom, 20)
                }
                //: VSTACK
                .padding(.horizontal, 20)
            }//: VSTACK
            .overlay(alignment: .leading, content: {
                Rectangle()
                    .frame(width: 2)
                    .foregroundStyle(.primary100)
            })
        }//: VSTACK
        .padding(.horizontal, 20)
        .background(.black)
    }
}

#Preview {
    DetailEventView()
}

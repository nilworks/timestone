//
//  SearchLocationSheetView.swift
//  timestone
//
//  Created by 이상민 on 3/18/25.
//

import SwiftUI

struct SearchLocationSheetView: View {
    
    @StateObject private var viewModel: SearchLocationViewModel = SearchLocationViewModel()
    @State private var isSearching: Bool = false
    @State private var kakaoMapDraw: Bool = false
    
    var body: some View {
        ZStack{
            KakaoMapView(
                draw: $kakaoMapDraw,
                coordinate: $viewModel.currentCoordinate
            )
            
            VStack{
                switch viewModel.viewState {
                case .idle:
                    MapSearchBarView()
                    Spacer()
                case .search:
                    LocationSearchView()
                case .result:
                    ResultMapSearchBarView()
                    Spacer()
                }
            }
        }//: ZSTACK
        .background(.neutral90)
        .navigationTitle("위치")
        .navigationBarTitleDisplayMode(.inline)
        .animation(.linear(duration: 0.15), value: isSearching)
        .environmentObject(viewModel)
        .onAppear {
            viewModel.checkDeviceLocation()
            kakaoMapDraw = true
        }
        .alert(
            "위치 서비스 사용",
            isPresented: $viewModel.locationSettingAlert) {
                Button("취소", role: .cancel) {
                    
                }
                
                Button("설정으로 이동", role: .destructive){
                    UIApplication.shared
                        .open(URL(string: UIApplication.openSettingsURLString)!)
                }
                
            } message: {
                Text("위치 서비스를 사용할 수 없습니다.\n") +
                Text("기기의 \"설정 > timestone > 위치\"에서\n") +
                Text("위치 서비스를 켜주세요.")
            }
    }
}

#Preview {
    SearchLocationSheetView()
}

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
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack{
            KakaoMapView(
                draw: $kakaoMapDraw,
                currentCoordinate: $viewModel.currentCoordinate,
                selectedCoordinate: $viewModel.selectedCoordinate, isActualCurrentLocation: $viewModel.isActualLocation, setCoordinate: $viewModel.setCoordinate
            )
            
            VStack(alignment: .leading, spacing: 0){
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
                
                if viewModel.viewState != .search{
                    VStack(alignment: .leading){
                        Button {
                            viewModel.checkDeviceLocation()
                        } label: {
                            Image(systemName: "dot.scope")
                                .padding(10)
                        }
                        .background(.white)
                        .clipShape(Circle())
                        .padding(.horizontal, 15)
                        .padding(.bottom, viewModel.viewState == .idle ? 15 : 0)
                    }
                }
                
                if viewModel.viewState == .result{
                    VStack(spacing: 0){
                        Text(viewModel.setCoordinate?.address ?? "-")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .modifier(SearchBarStyle())
                        
                        Button("설정"){
                            print("위치 저장")
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .modifier(SearchBarStyle())
                    }//: VSTACK
                    .padding(.bottom, 15)
                }
            }//: VSTACK
        }//: ZSTACK
        .background(.neutral90)
        .navigationTitle("위치")
        .navigationBarTitleDisplayMode(.inline)
        .animation(.linear(duration: 0.15), value: isSearching)
        .environmentObject(viewModel)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
                .foregroundStyle(.white)
                .font(.subBodyRegular)
            }
        })//: TOOLBAR
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                viewModel.checkDeviceLocation()
            }
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

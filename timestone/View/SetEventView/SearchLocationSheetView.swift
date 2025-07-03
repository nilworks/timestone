//
//  SearchLocationSheetView.swift
//  timestone
//
//  Created by 이상민 on 3/18/25.
//

import SwiftUI

struct SearchLocationSheetView: View {
    
    @EnvironmentObject private var viewModel: SearchLocationViewModel
    @State private var isSearching: Bool = false
    @State private var kakaoMapDraw: Bool = false
    @State private var showToast: Bool = false
    @Environment(\.dismiss) private var dismiss
    @State private var setBtnState: Bool = false //위치 설정 버튼 동작이 완료될 때까지 비활성화 시키기 위한 위치 설정 버튼 상태 변수
    
    var body: some View {
        ZStack{
            KakaoMapView(
                draw: $kakaoMapDraw,
                currentCoordinate: $viewModel.currentCoordinate,
                selectedCoordinate: $viewModel.selectedCoordinate,
                isActualCurrentLocation: $viewModel.isActualLocation,
                setCoordinate: $viewModel.setCoordinate,
                snapshot: $viewModel.kakaomapSnapshot,
                showSnapshot: $viewModel.showKakaomapSnapshot
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
                            viewModel.isSelectedCurrentLocationBtn = true
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
                        Text(viewModel.setCoordinate?.address ?? "위치 정보를 가져올 수 없습니다.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .modifier(SearchBarStyle())
                        
                        Button("설정"){
                            viewModel.showKakaomapSnapshot = true
                            viewModel.pickCoordinate = viewModel.setCoordinate
                            setBtnState = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                dismiss()
                                setBtnState = false
                            }
                            print("위치 저장")
                        }
                        .disabled(setBtnState)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .modifier(SearchBarStyle())
                    }//: VSTACK
                    .padding(.bottom, 15)
                }
            }//: VSTACK
            .overlay(alignment: .bottom) {
                if showToast{
                    Text("위치 사용 설정을 켜주세요")
                        .font(.subTitleMedium)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.neutral80)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.bottom, 10)
                }
            }
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
            viewModel.startMonitoring()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                viewModel.startLocationFlow()  
            }
            kakaoMapDraw = true
        }
        .onDisappear(perform: {
            viewModel.stopMonitoring()
        })
        .alert(isPresented: $viewModel.showErrorAlert, error: viewModel.showErrorType, actions: {_ in 
            Button("확인"){}
        }, message: { error in
            Text(viewModel.showError?.localizedDescription ?? "")
            Text(error.localizedDescription)
                .foregroundStyle(.red)
        })
        .alert(
            "위치 서비스 사용",
            isPresented: $viewModel.locationSettingAlert) {
                Button("취소", role: .cancel) {
                    withAnimation(.easeIn(duration: 0.1)) {
                        showToast = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.8){
                        withAnimation(.easeIn(duration: 0.2)) {
                            showToast = false
                        }
                    }
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

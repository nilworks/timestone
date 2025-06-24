//
//  ImagePickerView.swift
//  timestone
//
//  Created by 이상민 on 6/22/25.
//

import SwiftUI

struct ImagePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var photoLibraryObserver = PhotoLibraryObserver()
    @EnvironmentObject private var imagePickerViewModel: ImagePickerViewModel
    
    private let gridItems = [GridItem(.flexible(), spacing: 2),
                             GridItem(.flexible(), spacing: 2),
                             GridItem(.flexible(), spacing: 2)]
    
    private let dimension = UIScreen.main.bounds.width / 3 - 2
    
    var body: some View {
        NavigationView{
            NavigationStack{
                ScrollView(.vertical, showsIndicators: false){
                    VStack(spacing: 0) {
                        //더 많은 사진 선택으로 이동
                        Button {
                            imagePickerViewModel.presentLimitedImagePicker()
                        } label: {
                            HStack{
                                Image(systemName: "camera")
                                Text("더 많은 이미지/영상 선택")
                            }//: HSTACK
                            .font(.captionLight)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .overlay(alignment: .bottom) {
                                Divider()
                                    .frame(maxWidth: .infinity, maxHeight: 1)
                                    .background(.gray)
                                    .opacity(0.3)
                                    .padding(.horizontal)
                            }
                            .foregroundStyle(.white)
                        }
                        
                        //권한 설정으로 이동 버튼
                        // TODO: 만약에 이미 접근이 모든 사진 접근이라면?
                        Button {
                            if let url = URL(string: UIApplication.openSettingsURLString){
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            VStack(alignment: .leading) {
                                Text("권한 설정으로 이동")
                                Text("사진 접근 권한을 \"모든 사진 접근\"으로 변경할 수 있습니다.")
                                    .font(.caption)
                            }//: VSTACK
                            .font(.captionLight)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                        }
                        .foregroundStyle(.white)
                        
                        LazyVGrid(columns: gridItems, spacing: 2) {
                            ForEach(photoLibraryObserver.assets, id: \.localIdentifier) { asset in
                                Button {
                                    imagePickerViewModel
                                        .preselectAssetUpdate(asset: asset)
                                } label: {
                                    PhotoThumbnailView(asset: asset, dimension: dimension)
                                        .opacity(
                                            imagePickerViewModel.selectedIdentifiers
                                                .contains(
                                                    asset.localIdentifier
                                                ) ? 0.5 : 1.0
                                        )
                                        .overlay(
                                            alignment: .bottomTrailing,
                                            content: {
                                                if imagePickerViewModel.selectedIdentifiers.contains(asset.localIdentifier){
                                                    Image(systemName: "checkmark.circle")
                                                        .foregroundStyle(.white)
                                                        .background(.blue)
                                                        .clipShape(Circle())
                                                        .padding(5)
                                                }
                                            })
                                        .environmentObject(imagePickerViewModel)
                                }
                            }//: LOOP
                        }//: LazyVGrid
                    }//: VSTACK
                }//: SCROLLVIEW
                .scrollBounceBehavior(.basedOnSize, axes: [.vertical])
            }//: NAVIGATIONSTACK
            .navigationTitle("timestone")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        imagePickerViewModel.resetImagePicker()
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // TODO: 선택한 이미지 목록에 저장하기
                    } label: {
                        Text("완료")
                            .foregroundStyle(.white)
                    }
                }
            }//: TOOLBAR
        }//: NAVIGATIONVIEW
    }
}

#Preview {
    ImagePickerView()
}

//
//  AddScheduleView.swift
//  timestone
//
//  Created by 김혜림 on 12/22/24.
//

import SwiftUI
import Photos

struct TestView: View {
    @State private var isShow = true
    
    var body: some View {
        VStack {
            Button("show") {
                isShow.toggle()
            }
        }
        .sheet(isPresented: $isShow) {
            SetEventView()
        }
    }
}

struct SetEventView: View {
    // MARK: -Properties
    @StateObject private var viewModel = AddScheduleViewModel()
    @StateObject private var imagePickerViewModel = ImagePickerViewModel()
    @StateObject private var datePickerViewModel = CustomDatePickerViewModel()
    
    @State private var scheduleTitle: String = ""
    
    @State private var clockIsOn: Bool = false
    @State private var eventTimeIndex: Int = 0
    let eventTimes: [String] = ["정각", "5분 전", "1시간 전", "2시간 전", "1일 전(오전 9:00)", "2일 전(오전 9:00)"]
    @State private var selectDay = Date() // TODO: 캘린더에서 선택된 날짜 가져오도록 하기
    
    @State private var memoText: String = ""
    
    @State var inputLink: String = ""
    
    @State var addLocation: String = ""
    
    @State private var selectedImages: [UIImage] = []
    @State private var selectedAssetIDs: [String] = []
    @State private var showImagePicker = false
    
    @State private var selectedButtonPosition: CGPoint = .zero
    @State private var showSearchLocation: Bool = false
    
    // 텍스트 뷰 여백 조절
    init() {
        UITextView.appearance().textContainerInset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        
    }
    
    
    var body: some View {
        ZStack(alignment: .top) {
            // MARK: - 컨트롤러
            HStack {
                // TODO: X버튼 기능 추가 필요
                // X 아이콘 버튼
                Button(action: {
                    
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // Save 버튼
                // TODO: Save버튼 기능 추가 필요
                Button(action: {
                    
                }) {
                    Text("Save")
                        .font(.bodyRegular)
                        .foregroundColor(.neutral60)
                }
            }
            .padding([.leading, .trailing], 20)
            .padding(.top, 20)
            .padding(.bottom, 20)
            .background(Color.neutral90)
            .zIndex(1)
            
            ScrollView {
                VStack {
                    
                    // MARK: - 일정 제목 입력
                    if #available(iOS 17.0, *) {
                        TextField("일정", text: $scheduleTitle, prompt: Text("일정").foregroundStyle(.neutral70))
                            .font(.titleBold)
                            .padding([.leading, .trailing], 20)
                            .padding(.top, 70)
                            .foregroundColor(Color.white)
                    } else {
                        TextField("일정", text: $scheduleTitle)
                            .font(.titleBold)
                            .padding([.leading, .trailing], 20)
                            .padding(.top, 70)
                            .foregroundColor(Color.white)
                    }
                    
                    Divider()
                        .frame(height: 0.4) // 높이 값을 사용해서 Divider 두께 조절
                        .background(Color.neutral80)
                        .padding(.top, 5)
                    
                    // MARK: - 알림
                    VStack {
                        HStack {
                            // 알림 타이틀
                            HStack(spacing: 10) {
                                HStack {
                                    Image(systemName: "clock")
                                        .font(.system(size: 18))
                                        .foregroundColor(.primary100)
                                    
                                    Text("알림")
                                        .font(.subTitleMedium)
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                                
                                Toggle("", isOn: $clockIsOn)
                                    .toggleStyle(ToggleSt())
                            }
                        }
                        
                        VStack {
                            Picker("", selection: $eventTimeIndex) {
                                ForEach(0..<eventTimes.count, id: \.self) { index in
                                    Text(eventTimes[index]).tag(index)
                                }
                            }
                            .pickerStyle(.inline)
                        }
                        .frame(height: clockIsOn ? 80 : 0)
                        .background(.neutral80)
                        .cornerRadius(6)
                        .padding(.bottom, 10)
                        
                        // 시작, 종료
                        VStack(spacing: 15) {
                            
                            // 시작
                            HStack {
                                Text("시작")
                                    .font(.bodyRegular)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                CustomDatePickerButton(viewModel: datePickerViewModel, selectedButtonPosition: $selectedButtonPosition)
                            }
                            
                            // 종료
                            HStack {
                                Text("종료")
                                    .font(.bodyRegular)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                CustomDatePickerButton(viewModel: datePickerViewModel, selectedButtonPosition: $selectedButtonPosition)
                            }
                        }
                    } // 알림
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 15)
                    
                    Divider()
                        .frame(height: 0.4) // 높이 값을 사용해서 Divider 두께 조절
                        .background(Color.neutral80)
                        .padding(.top, 15)
                    
                    // MARK: - 메모
                    VStack {
                        HStack {
                            // 메모 타이틀
                            HStack(spacing: 10) {
                                HStack {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 18))
                                        .foregroundColor(.primary100)
                                    
                                    Text("메모")
                                        .font(.subTitleMedium)
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                            }
                        }
                        
                        // 메모 콘텐츠
                        HStack {
                            // TODO: 빈 화면 탭했을 때 키보드 없어지기
                            // TODO: 키보드에 키보드 없어지는 버튼 추가하기
                            TextEditor(text: $memoText)
                                .font(.subBodyRegular)
                                .frame(height: 96)
                                .scrollContentBackground(.hidden)
                                .background(Color.neutral80)
                                .cornerRadius(4)
                            // placeholder 만들기
                                .overlay(alignment: .topLeading) {
                                    Text("메모를 입력해주세요.")
                                        .foregroundStyle(memoText.isEmpty ? .neutral50 : .clear)
                                        .font(.subBodyRegular)
                                        .padding([.leading, .top], 4)
                                }
                        }
                    } // 메모
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 15)
                    
                    Divider()
                        .frame(height: 0.4) // 높이 값을 사용해서 Divider 두께 조절
                        .background(Color.neutral80)
                        .padding(.top, 25)
                    
                    
                    // MARK: - 링크
                    VStack {
                        HStack {
                            // 링크 타이틀
                            HStack(spacing: 10) {
                                HStack {
                                    Image(systemName: "link")
                                        .font(.system(size: 18))
                                        .foregroundColor(.primary100)
                                    
                                    Text("링크")
                                        .font(.subTitleMedium)
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                            }
                        }
                        
                        // 링크 콘텐츠
                        HStack(spacing: 30) {
                            
                            // TODO: 빈 화면 탭했을 때 키보드 없어지기
                            // TODO: 키보드에 키보드 없어지는 버튼 추가하기
                            TextField("링크를 입력해 주세요.",text: $inputLink, prompt: Text("링크를 입력해 주세요."))
                                .padding(4)
                                .font(.subBodyRegular)
                                .scrollContentBackground(.hidden)
                                .background(.neutral80)
                                .cornerRadius(4)
                        }
                    }
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 15)
                    
                    Divider()
                        .frame(height: 0.4) // 높이 값을 사용해서 Divider 두께 조절
                        .background(Color.neutral80)
                        .padding(.top, 15)
                    
                    
                    // MARK: - 장소
                    VStack {
                        HStack {
                            // 장소 타이틀
                            HStack(spacing: 10) {
                                HStack {
                                    Image(systemName: "map")
                                        .font(.system(size: 18))
                                        .foregroundColor(.primary100)
                                    
                                    Text("장소")
                                        .font(.subTitleMedium)
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                            }
                        }
                        
                        // 지도 콘텐츠

                            Button(action: {
                                self.showSearchLocation.toggle()
                            }) {
                                HStack {
                                    Text("위치 추가")
                                        .font(.subBodyRegular)
                                        .foregroundStyle(.neutral60)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.white)
                                }
                                .padding([.leading, .trailing], 10)
                            }
                            .frame(height: 40)
                            .background(.neutral80)
                            .cornerRadius(4)

                    }
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 15)
                    
                    Divider()
                        .frame(height: 0.4) // 높이 값을 사용해서 Divider 두께 조절
                        .background(Color.neutral80)
                        .padding(.top, 20)
                    
                    // MARK: - 사진
                    VStack {
                        HStack {
                            // 사진 타이틀
                            HStack(spacing: 10) {
                                HStack {
                                    Image(systemName: "photo")
                                        .font(.system(size: 18))
                                        .foregroundColor(.primary100)
                                    
                                    Text("사진")
                                        .font(.subTitleMedium)
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                            }
                        }
                        
                        // 사진 추가 콘텐츠
                        HStack(spacing: 30) {
                            
                            if #available(iOS 17.0, *) {
                                ScrollView(.horizontal) {
                                    HStack {
                                        HStack {
                                            VStack {
                                                Image(systemName: "plus")
                                                    .foregroundStyle(.white)
                                                    .padding(.bottom, 2)
                                                Text("\(imagePickerViewModel.selectedImages.count)/10")
                                                    .foregroundStyle(.white)
                                                    .font(.subCaptionLight)
                                            }
                                            .frame(width: 100, height: 100)
                                            .background(.neutral80)
                                            .cornerRadius(4)
                                            .onTapGesture {
                                                showImagePicker = true
                                                print("현재 저장된 이미지: \(imagePickerViewModel.selectedAssetIDs)")
                                                checkPhotoLibraryPermission()
                                            }
                                            .sheet(isPresented: $showImagePicker) {
                                                MultiImagePicker(selectedImages: $imagePickerViewModel.selectedImages,
                                                                 selectedAssetIDs: $imagePickerViewModel.selectedAssetIDs)
                                            }
                                        }
                                        
                                        // 추가된 이미지
                                        HStack {
                                            LazyVGrid(columns: dynamicColumns(), spacing: 10) {
                                                ForEach(imagePickerViewModel.selectedImages, id: \.self) { image in
                                                    Image(uiImage: image)
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 100, height: 100)
                                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                                }
                                            }
                                        }
                                    }
                                    
                                } // ScrollView
                                .scrollTargetBehavior (.paging)
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                        
                    } // 사진
                    .padding([.leading, .trailing], 20)
                    .padding(.top, 15)
                    
                } // VStack
                .padding(.bottom, 130)
            } // ScrollView
            .ignoresSafeArea(edges: .bottom)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.neutral90))
            .onTapGesture {
                datePickerViewModel.showDatePicker = false
                datePickerViewModel.showTimePicker = false
            }
            
            if datePickerViewModel.showDatePicker {
                CustomDatePickerPopUp(viewModel: datePickerViewModel, selectedButtonPosition: $selectedButtonPosition)
            }
            
            if datePickerViewModel.showTimePicker {
                CustomTimePickerPopUp(viewModel: datePickerViewModel, selectedButtonPosition: $selectedButtonPosition)
            }
        }
        .sheet(isPresented: $showSearchLocation) {
            SearchLocationSheetView()
        }
    }
    
    // 사진 정렬
    private func dynamicColumns() -> [GridItem] {
        let count = imagePickerViewModel.selectedImages.count
        return Array(repeating: GridItem(.flexible(), spacing: 10), count: max(count, 1))
    }
    
    // 사진 접근 권한 허용 팝업
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .notDetermined:
            // 권한 요청
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        print("사진 접근 권한 허용됨")
                        self.showImagePicker = true // 권한 허용 시 시트를 표시
                    } else {
                        print("사진 접근 권한 거부됨")
                    }
                }
            }
        case .authorized, .limited:
            // 이미 권한 허용됨
            print("사진 접근 권한이 이미 허용됨")
            self.showImagePicker = true // 권한이 이미 허용된 경우 시트를 표시
        case .denied, .restricted:
            // 권한 거부 또는 제한
            print("사진 접근 권한이 거부됨 - 설정에서 변경 필요")
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        @unknown default:
            print("알 수 없는 권한 상태")
        }
    }
}


#Preview {
    TestView()
}

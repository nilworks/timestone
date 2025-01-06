//
//  ImagePicker.swift
//  timestone
//
//  Created by 김혜림 on 12/27/24.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable { // UIViewControllerRepresentable: 사진첩 등 iOS 화면을 SwiftUI에서 쓸 수 있게 연결해주는 역할
    @Environment(\.presentationMode) private var presentaionMode // 화면을 닫거나 뒤로가기 위해 사용하는 환경변수(사진첩 화면 닫을 때 사용)
    var sourceType: UIImagePickerController.SourceType = .photoLibrary // 사진첩, 카메라, 저장된 앨범 중 어떤 화면을 열것인지 지정하기 위한 변수
    @Binding var selectedImage: UIImage // 부모 뷰에서 선택된 이미지를 전달받고 업데이트하기 위한 변수
    
    // 사진첩 화면을 만드는 함수
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController() // UIImagePickerController: 사진첩을 보여주는 역할
        imagePicker.allowsEditing = false // 사용자가 이미지를 선택한 후 편집할 수 있게 할것인지 설정, false는 편집 비활성화
        imagePicker.sourceType = sourceType // 사진첩, 카메라, 저장된 앨범 중 무엇을 열것인지 결정, 변수 sourceType에 담겨있는 .photoLibrary는 사진첩을 열겠다는 의미(.camera 는 카메라, .savedPhotosAlbum 은 저장된 앨범), 기본값은 .photoLibrary
        imagePicker.delegate = context.coordinator // 사진을 선택했을 때 어떻게 할지 context.coordinator에게 위임
        
        return imagePicker
    }
    
    // 이미지 업데이트 함수
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    // 코디네이터 생성, 부모인 ImagePicker와 연결되어 이미지 선택을 처리
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // 사진을 선택했을 때 어떻게 처리할지 정의
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker // 부모뷰 변수에 저장
        
        // 초기화 시 부모뷰(ImagePicker)와 연결
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage { // 사용자가 선택한 원본 이미지 가져오기, 선택한 이미지는 info라는 딕셔너리에 originalImage 키로 접근 가능
                parent.selectedImage = image // 선택된 사진 selectedImage에 저장
            }
            
            parent.presentaionMode.wrappedValue.dismiss() // 사진첩 화면 닫기
        }
    }
}

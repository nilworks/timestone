//
//  SearchLocationViewModel.swift
//  timestone
//
//  Created by 이상민 on 3/24/25.
//

import Foundation

@MainActor
class SearchLocationViewModel: ObservableObject{
    enum ViewState {
        case idle
        case search
    }
    
    @Published var searchLocationText: String = ""
    @Published var searchResultLocation: [Document] = []
    @Published var viewState: ViewState = .idle
    
    func fetchSearchLocation(){
        Task{
            do{
                let response: Place = try await NetworkManager.shared
                    .CallbackRequest(
                        request: KakaoRequest
                            .placeSearch(query: self.searchLocationText)
                    )
                searchResultLocation = response.documents
            }catch{
                print(error.localizedDescription)
            }
        }
    }
}

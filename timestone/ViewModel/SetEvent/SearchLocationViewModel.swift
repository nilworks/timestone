//
//  SearchLocationViewModel.swift
//  timestone
//
//  Created by 이상민 on 3/24/25.
//

import Foundation

@MainActor
class SearchLocationViewModel: ObservableObject{
    @Published var searchLocationText: String = ""
    @Published var searchResultLocation: [Document] = []
    
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

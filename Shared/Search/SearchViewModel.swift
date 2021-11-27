//
//  SearchViewModel.swift
//  Crap Tracker (iOS)
//
//  Created by Trevor Schmidt on 10/18/21.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var model = SearchModel()
    
    func onAppear() {
        FirebaseDatabaseService.shared.pullSearchInfo { [weak self] result in
            switch result {
            case .success(let searchModel):
                
                self?.model = searchModel
                self?.model.users.sort(by: { u1, u2 in
                    u1.username < u2.username
                })
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

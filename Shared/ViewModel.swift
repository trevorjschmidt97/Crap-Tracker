//
//  ViewModel.swift
//  Crap Tracker
//
//  Created by Trevor Schmidt on 9/28/21.
//

import Foundation
class ViewModel: ObservableObject {
    @Published var model = Model()
    
    func buttonPressed() {
        model.count += 1
        print(model.count)
    }
}

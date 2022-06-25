//
//  MVVM_CalcApp.swift
//  MVVM_Calc
//
//  Created by Moorthy, Prashanth on 21/06/22.
//

import SwiftUI

@main
struct MVVM_CalcApp: App {
    var body: some Scene {
        WindowGroup {
            PriceCard(cardViewModel: PriceCardViewModel())
        }
    }
}

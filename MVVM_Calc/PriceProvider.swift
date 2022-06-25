//
//  PriceProvider.swift
//  MVVM_Calc
//

import Foundation
import Combine

class PriceProvider: ObservableObject {

    let currencyName = "Dodgy Coin"
    @Published var price: Double = 394.05

    init() {
        startPublishingLatestPrice()
    }

    private let priceFetchTimer = Timer.publish(every: 2.0,
                                                on: .main,
                                                in: .common).autoconnect()
    private var store = Set<AnyCancellable>()
}

extension PriceProvider {

    // Publishes the price of Dodgy Coin every 3 seconds
    private func startPublishingLatestPrice() {
        priceFetchTimer
            .sink { _ in self.fetchCurrentPrice()}
            .store(in: &store)
    }

    // Fetches the price on demand.
    func fetchCurrentPrice() {
        let randomMultiplier = [-0.01, 0.01, -0.023, 0.025, -0.05, 0.045, 0.0].randomElement()!
        price *= (1 + randomMultiplier)
    }
}

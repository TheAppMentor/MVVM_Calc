//
//  ContentView.swift
//  Counter
//

import SwiftUI
import Combine

class PriceCardViewModel: ObservableObject {

    private let priceModel = PriceProvider()
    private var currentPrice: Double = 0.0
    private var store = Set<AnyCancellable>()

    var cardTitle: String

    @Published var currentPriceString : String = "Start Value"
    @Published var priceDifferenceString : String = ""
    @Published var priceDirection: PriceDirection = .unchanged

    func refeshCard() {
        priceModel.fetchCurrentPrice()
    }

    init() {
        cardTitle = priceModel.currencyName

        priceModel.$price.sink { latestPrice in
            let priceDifference = latestPrice - self.currentPrice

            if priceDifference == 0 {
                self.priceDirection = .unchanged
                return
            }

            self.priceDirection = priceDifference > 0 ? .positive : .negative
            self.currentPrice = latestPrice
            self.priceDifferenceString = self.calcPercentageDiff(priceDifference: priceDifference)
            self.currentPriceString = String(format: "$%.2f", self.currentPrice)

        }.store(in: &store)
    }
}


extension PriceCardViewModel {
    func calcPercentageDiff(priceDifference: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2

        return formatter.string(for: priceDifference) ?? ""
    }
}

struct PriceCard: View {
    @ObservedObject var cardViewModel: PriceCardViewModel

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Color.init(white: 0.95))
                .frame(width: 300, height: 150, alignment: .center)
                .shadow(radius: 5.0)

            HStack(alignment: .firstTextBaseline) {

                VStack(alignment: .center) {
                    Text(cardViewModel.cardTitle)
                        .font(.system(size: 22, weight: .regular, design: .rounded))
                        .foregroundColor(.init(white: 0.3))
                        .bold()
                    Spacer()
                    Button {
                        print("Refresh Pressed")
                    } label: {
                        Text("Refresh")
                            .padding()
                    }

                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(cardViewModel.currentPriceString)
                        .font(.system(size: 24, weight: .heavy, design: .monospaced))
                    ZStack {
                        RoundedRectangle(cornerRadius: 10.0)
                            .fill(cardViewModel.priceDirection == PriceDirection.negative ? .red : .green)
                            .frame(width: 100, height: 45, alignment: .center)
                        Text(cardViewModel.priceDifferenceString)
                            .font(.system(size: 18, weight: .heavy, design: .monospaced))
                    }
                }
            }
            .padding()
            .frame(width: 300, height: 120, alignment: .top)
        }
    }
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        //CounterView(viewModel: CounterViewModel())
        PriceCard(cardViewModel: PriceCardViewModel())
    }
}



































class CounterModel {

    func incrementCounter(currValue: Int) -> Int {
        return currValue + 1
    }

    func reduceCounter(currValue: Int) -> Int {
        return currValue - 1
    }
}

class CounterViewModel: ObservableObject {

    var counterModel: CounterModel = CounterModel()

    @Published var isMinusDisabled: Bool = true
    @Published var counterValue: Int = 0

    func addButtonPressed() {
        counterValue = counterModel.incrementCounter(currValue: counterValue)

        if counterValue > 0 {
            isMinusDisabled = false
        }
    }

    func minusButtonPressed() {
        counterValue = counterModel.reduceCounter(currValue: counterValue)

        if counterValue <= 0 {
            isMinusDisabled = true
        }
    }
}

struct CounterView: View {

    @ObservedObject var viewModel: CounterViewModel

    var body: some View {
        HStack {

            Button() {
                viewModel.minusButtonPressed()
            } label: {
                Image(systemName: "minus.circle.fill")
                    .resizable()
                    .frame(width: 44, height: 44, alignment: .center)
                    .foregroundColor(viewModel.isMinusDisabled ? .gray : .red)
                    .padding()
            }.disabled(viewModel.isMinusDisabled)

            Text("\(viewModel.counterValue)")
                .font(.largeTitle)
                .padding()
                .frame(width: 100, alignment: .center)

            Button {
                viewModel.addButtonPressed()
            } label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 44, height: 44, alignment: .center)
                    .foregroundColor(.green)
                    .padding()
            }

        }.overlay(
            Capsule(style: .continuous)
                .stroke(Color.gray, lineWidth: 2)
                .frame(width: 300, height: 100, alignment: .center)
        )
    }
}

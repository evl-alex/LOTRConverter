//
//  ContentView.swift
//  LOTRConverter
//
//  Created by Олександр Бібік on 16.04.2026.
//

import SwiftUI
import TipKit

struct ContentView: View {
    @State var showExchangeInfo = false
    @State var isShowingSelectCurrency = false
    
    @State var leftAmount = ""
    @State var rightAmount = ""
    
    @FocusState var leftTyping
    @FocusState var rightTyping
    
    @State var leftCurrency: Currency = .silverPiece
    @State var rightCurrency: Currency = .goldPiece
    
    let currencyTip = CurrencyTip()
    
    var body: some View {
        ZStack {
            // BG Image
            Image(.background)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                // Pony logo
                Image(.prancingpony)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                
                // Currency exchange stack
                Text("Currency Exchange")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    
                
                // Conversion section
                HStack{
                    // Left conversion section
                    CurrencyInput(
                        currency: leftCurrency,
                        amount: $leftAmount,
                        isShowingSelectCurrency: $isShowingSelectCurrency,
                        isTyping: $leftTyping,
                        tip: currencyTip
                    )
                    
                    // Equeal sign
                    Image(systemName: "equal")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .symbolEffect(.pulse)
                    
                    // Right conversion section
                    CurrencyInput(
                        currency: rightCurrency,
                        amount: $rightAmount,
                        isShowingSelectCurrency: $isShowingSelectCurrency,
                        isTyping: $rightTyping,
                        tip: currencyTip
                    )
                }
                .padding()
                .background(.black.opacity(0.5))
                .clipShape(.capsule)
                .keyboardType(.decimalPad)
                
                Spacer()
                
                // Info button
                HStack {
                    Spacer()
                    
                    Button {
                        showExchangeInfo.toggle()
                    } label: {
                        Image(systemName: "info.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                    }
                    .padding(.trailing)
                }
            }
        }
        .task {
            try? Tips.configure()
            leftCurrency = Currency(rawValue: UserDefaults.standard.double(forKey: "left-currency")) ?? Currency.silverPiece
            rightCurrency = Currency(rawValue: UserDefaults.standard.double(forKey: "right-currency")) ?? Currency.goldPiece
        }
        .onChange(of: leftAmount) {
            if leftTyping {
                rightAmount = leftCurrency.convert(leftAmount, to: rightCurrency)
            }
        }
        .onChange(of: rightAmount) {
            if rightTyping {
                leftAmount = rightCurrency.convert(rightAmount, to: leftCurrency)
            }
        }
        .onChange(of: leftCurrency) {
            leftAmount = rightCurrency.convert(rightAmount, to: leftCurrency)
            UserDefaults.standard.set(leftCurrency.rawValue, forKey: "left-currency")
        }
        .onChange(of: rightCurrency) {
            rightAmount = leftCurrency.convert(leftAmount, to: rightCurrency)
            UserDefaults.standard.set(rightCurrency.rawValue, forKey: "right-currency")
        }
        .onTapGesture {
            if leftTyping {
                leftTyping.toggle()
            }
            
            if rightTyping {
                rightTyping.toggle()
            }
        }
        .sheet(isPresented: $showExchangeInfo) {
            ExchangeInfo()
        }
        .sheet(isPresented: $isShowingSelectCurrency) {
            SelectCurrency(topCurrency: $leftCurrency, bottomCurrency: $rightCurrency)
        }
    }
}

#Preview {
    ContentView()
}

//
//  CurrencyInput.swift
//  LOTRConverter
//
//  Created by Олександр Бібік on 23.04.2026.
//

import SwiftUI
import TipKit

struct CurrencyInput: View {
    let currency: Currency
    @Binding var amount: String
    @Binding var isShowingSelectCurrency: Bool
    @FocusState.Binding var isTyping: Bool
    let tip: any Tip
    
    var body: some View {
        VStack {
            // Currency
            HStack {
                // Currency image
                Image(currency.image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 33)
                
                // Currency text
                Text(currency.name)
                    .font(.headline)
                    .foregroundStyle(.white)
            }
            .padding(.bottom, -5)
            .onTapGesture {
                isShowingSelectCurrency.toggle()
                tip.invalidate(reason: .actionPerformed)
            }
            .popoverTip(tip, arrowEdge: .bottom)
            
            // Text field
            TextField("Amount", text: $amount)
                .textFieldStyle(.roundedBorder)
                .focused($isTyping)
        }
    }
}

#Preview {
    @Previewable @State var amount = "5"
    @Previewable @State var isShowingSelectCurrency = false
    @Previewable @FocusState var isTyping: Bool
    @Previewable let tip = CurrencyTip()
    
    CurrencyInput(
        currency: .goldPenny,
        amount: $amount,
        isShowingSelectCurrency: $isShowingSelectCurrency,
        isTyping: $isTyping,
        tip: tip
    )
}

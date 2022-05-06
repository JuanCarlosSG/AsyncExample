//
//  PriceView.swift
//  AsyncExample
//
//  Created by Juan Carlos Sánchez Gutiérrez on 05/05/22.
//

import SwiftUI

struct PriceView: View {
    @State var ticket : String = ""
    @State var price: String = ""
    @EnvironmentObject var fileVM: dataViewModel
    var body: some View {
        VStack(spacing: 20) {
            CustomTextField(placeholder: "File Ticket", textValue: self.$ticket)
            
            Button {
                if Int(self.ticket) != nil {
                    fileVM.getPrintPrice(ticket: apiResp(ticket: self.ticket)) { resp in
                        self.price = resp
                    }
                }
            } label: {
                Text("Get Price")
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.black)
                    .shadow(color: .gray, radius: 5, x: 1, y: 1))
            .foregroundColor(.white)
            
            Text("$\(self.price)")
            Spacer()
        }
        .frame(maxHeight: .infinity)
    }
}

struct PriceView_Previews: PreviewProvider {
    static var previews: some View {
        PriceView()
    }
}

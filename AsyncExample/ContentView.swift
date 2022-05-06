//
//  ContentView.swift
//  AsyncExample
//
//  Created by Juan Carlos Sánchez Gutiérrez on 07/04/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainView()
            .environmentObject(dataViewModel())
    }
}

struct MainView: View {
    var body: some View {
        NavigationView {
            PrinterView()
                .padding()
                .navigationBarHidden(true)
        }
    }
}

struct PrinterView: View {
    @StateObject var queueVM: queueViewModel = queueViewModel()
    @EnvironmentObject var fileVM: dataViewModel
    @State var console : [String] = []
    @State var fileName: String = ""
    @State var fileSize: String = ""
    @State var alert : Bool = false
    @State var alertText: String = "Alert Text"
    @State var showPriceView: Bool = false
    var body: some View {
        
        VStack(spacing: 20) {
            
            NavigationLink(isActive: self.$showPriceView) {
                PriceView()
                    .padding()
                    .navigationBarTitleDisplayMode(.inline)
                
            } label: { EmptyView()}
            
            HStack (spacing: 20) {
                CustomTextField(placeholder: "File Name", textValue: self.$fileName)
                CustomTextField(placeholder: "Size", textValue: self.$fileSize)
                    .keyboardType(.numberPad)
            }
            
            Button {
                
                if self.fileName != "" && self.fileSize != "" {
                    
                    if Int(self.fileSize) != nil {
                        
                        queueVM.processFile(fileName: self.fileName, size: Int(self.fileSize)!) { value in
                            console.append(value)
                        }
                        
                        fileVM.uploadPrint(file: dataPrint(name: self.fileName, size: Int(self.fileSize)!)) { ticket in
                            console.append("Ticket \(ticket)")
                        }
                        
                        self.fileName = ""
                        self.fileSize = ""
                        
                    } else {
                        
                        self.alertText = "File Size is not a number"
                        
                        self.alert.toggle()
                        
                    }
                    
                } else {
                    
                    self.alertText = "Both fields have to be set."
                    
                    self.alert.toggle()
                    
                }
                
            } label: {
                Text("Print")
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.black)
                    .shadow(color: .gray, radius: 5, x: 1, y: 1))
            .foregroundColor(.white)
            
            if (!console.isEmpty) {
                Button {
                    
                    console = []
                    self.fileName = ""
                    self.fileSize = ""
                    
                } label: {
                    Text("Clear")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.black)
                        .shadow(color: .gray, radius: 5, x: 1, y: 1))
                .foregroundColor(.white)
                
            }
            
            Button {
                self.showPriceView.toggle()
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

            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack (spacing: 10) {
                    ForEach(console, id: \.self) { line in
                        Text(line)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .transition(.opacity)
                    }
                }
            }
            .padding(35)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white)
                    .shadow(color: .gray, radius: 5, x: 1, y: 1)
            )
            
        }
        .alert(isPresented: self.$alert) {
            
            Alert(title: Text("Error"), message: Text("\(self.alertText)"), dismissButton: .default(Text("Ok")))
        }
        
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

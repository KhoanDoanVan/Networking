//
//  ContentView.swift
//  IOS-Networking
//
//  Created by Đoàn Văn Khoan on 02/03/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = CoinsViewModel()
    
    var body: some View {
        List{
            ForEach(viewModel.coins){ coin in
                HStack(spacing : 20){
                    Text("\(coin.marketCapRank)")
                    
                    VStack(alignment :.leading){
                        Text(coin.name)
                            .fontWeight(.semibold)
                        
                        Text(coin.symbol.uppercased())
                    }
                }
                .font(.footnote)
            }
        }
        .overlay {
            if let error = viewModel.errorMessage {
                Text(error)
            }
        }
    }
}

#Preview {
    ContentView()
}

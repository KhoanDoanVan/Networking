//
//  CoinsViewModel.swift
//  IOS-Networking
//
//  Created by Đoàn Văn Khoan on 02/03/2024.
//

import Foundation


class CoinsViewModel: ObservableObject{
    @Published var coins = [Coin]()
    @Published var errorMessage : String?
    
    private var service = CoinDataService()
    
    init() {
        Task{
            try await fetchCoinsAsync()
        }
    }
    
    @MainActor
    func fetchCoinsAsync() async throws {
        self.coins = try await service.fetchCoins()
    }
       
    func fetchCoins(){
        // with first way handling error
//        service.fetchCoins{ coin, error in
//            DispatchQueue.main.async{
//                if let errorMessage = error {
//                    self.errorMessage = errorMessage.localizedDescription
//                }
//                self.coins = coin ?? []
//            }
//        }
        
        service.fetchCoinsWithResult{ [weak self] resuit in
            DispatchQueue.main.async{
                switch resuit {
                case .success(let coins):
                    self?.coins = coins
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
        
    }
}

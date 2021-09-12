//
//  CoinListCell.swift
//  CoinListCell
//
//  Created by Eliasz Sawicki on 11/09/2021.
//

import Foundation
import SwiftUI

struct CoinListCell: View {
    
    let viewModel: CoinCellViewModel
    
    func percentageChange(for period: String, value: String, isRising: Bool) -> some View {
        VStack {
            Text(period)
                .font(.system(size: 13))
                .fontWeight(.light)
            Text(value)
                .font(.system(size: 15))
                .foregroundColor(isRising ? .green : .red)
        }.frame(width: 60)
    }
    
    func coinHeader(name: String, priceUSD: String, growthTrend: GrowthTrend) -> some View {
        HStack {
            Text(name)
                .font(.system(size: 20))
                .fontWeight(.medium)
            Spacer()
            HStack {
                imageForTrend(growthTrend)
                Text(priceUSD)
                    .font(.system(size: 20))
                    .fontWeight(.medium)
            }
        }
    }
    
    private func imageForTrend(_ growthTrend: GrowthTrend) -> some View {
        switch growthTrend {
        case .rise:
            return Image(systemName: "arrow.up").foregroundColor(.green)
        case .fall:
            return Image(systemName: "arrow.down").foregroundColor(.red)
        case .noChange:
            return Image(systemName: "minus").foregroundColor(.black)
        }
    }
    
    func coinDetails(symbol: String, volume: String) -> some View {
        HStack {
            Text(symbol).font(.system(size: 14))
            Spacer()
            Text(volume)
                .font(.system(size: 14))
        }
    }
    
    func coinChanges(change1h: String, change24h: String) -> some View {
        HStack {
            Spacer()
            percentageChange(for: "1h", value: change1h, isRising: viewModel.isRisingTrend1h)
            Spacer()
            percentageChange(for: "24h", value: change24h, isRising: viewModel.isRisingTrend24h)
            Spacer()
        }
    }
    
    var body: some View {
        VStack {
            coinHeader(name: viewModel.name, priceUSD: viewModel.priceUSD,
                       growthTrend: viewModel.growthTrend)
            coinDetails(symbol: viewModel.symbol, volume: viewModel.volume24)
            Spacer()
            coinChanges(change1h: viewModel.percentChange1h,
                        change24h: viewModel.percentChange24h)
        }
    }
    
}


struct CoinListCell_Previews: PreviewProvider {
    static var previews: some View {
        let coin = CoinBuilder().build()
        CoinListCell(viewModel: CoinCellViewModel(coin: coin, growthTrend: .noChange))
            .previewLayout(.fixed(width: 400, height: 140))
    }
}

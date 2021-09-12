//
//  ApiClient.swift
//  CoinLoreSimpleClient
//
//  Created by Eliasz Sawicki on 12/09/2021.
//

import Foundation
import Combine

protocol ApiClient {
    func performRequest(url: URL) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLError>
}

extension URLSession: ApiClient {
    func performRequest(url: URL) -> AnyPublisher<DataTaskPublisher.Output, URLError> {
        dataTaskPublisher(for: url).eraseToAnyPublisher()
    }
}

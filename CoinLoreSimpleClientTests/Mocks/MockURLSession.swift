//
//  MockURLSession.swift
//  CoinLoreSimpleClientTests
//
//  Created by Eliasz Sawicki on 12/09/2021.
//

import Foundation
import Mimus
import Combine
@testable import CoinLoreSimpleClient

class MockApiClient: ApiClient, Mock {
    
    let idPerformRequest = "idPerformRequest"
    var storage = Storage()
    var returnedPerformRequest: AnyPublisher<URLSession.DataTaskPublisher.Output, URLError> =
        Fail(outputType: URLSession.DataTaskPublisher.Output.self, failure: URLError(.badURL)).eraseToAnyPublisher()
    
    func performRequest(url: URL) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLError> {
        recordCall(withIdentifier: idPerformRequest, arguments: [url])
        return returnedPerformRequest
    }
}

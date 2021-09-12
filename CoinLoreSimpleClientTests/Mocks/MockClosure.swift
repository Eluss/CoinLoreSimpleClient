//
//  MockClosure.swift
//  CoinLoreSimpleClientTests
//
//  Created by Eliasz Sawicki on 12/09/2021.
//

import Foundation

class MockClosure<T> {
    
    var valueInClosure: T?
    
    func closure(_ value: T) {
        valueInClosure = value
    }
    
}

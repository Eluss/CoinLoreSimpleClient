//
//  MockEquatables.swift
//  CoinLoreSimpleClientTests
//
//  Created by Eliasz Sawicki on 12/09/2021.
//

import Foundation
import Mimus
@testable import CoinLoreSimpleClient

extension Coin: MockEquatable {
    public func matches(argument: Any?) -> Bool {
        if let argument = argument as? Coin {
            return self == argument
        }
        return false
    }
}

extension SortingCriteria: MockEquatable {
    public func matches(argument: Any?) -> Bool {
        if let argument = argument as? SortingCriteria {
            return self == argument
        }
        return false
    }
}

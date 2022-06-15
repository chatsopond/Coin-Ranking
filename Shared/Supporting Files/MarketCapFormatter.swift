//
//  MarketCapFormatter.swift
//  LMWN Coin
//
//  Created by Chatsopon Deepateep on 10/6/2565 BE.
//

import Foundation

/// return the formatted string
///
/// When the value is
/// - **Trillion**: the string will display with 2 decimal with suffix trillion
/// - **Billion:** the string will display with 2 decimal with suffix billion
/// - **Million:** the string will display with 2 decimal with suffix Million
/// - otherwise: the string will display with 2 decimal without suffix
func marketCapFormatter(_ double: Double) -> (value: Double, suffix: String) {
    let trillion = Double(1_000_000_000_000)
    let billion = Double(1_000_000_000)
    let million = Double(1_000_000)
    if double > trillion {
        return (value: double/trillion, suffix: "trillion")
    } else if double > billion {
        return (value: double/billion, suffix: "billion")
    } else if double > million {
        return (value: double/million, suffix: "million")
    } else {
        return (value: double, suffix: "")
    }
}

//
//  BreedsListResponse.swift
//  Randog
//
//  Created by Fabiana Petrovick on 16/04/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import Foundation

struct BreedsListResponse: Codable {
    let status: String
    let message: [String: [String]]
}

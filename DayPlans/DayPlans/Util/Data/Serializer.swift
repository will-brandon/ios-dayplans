//
//  Serializer.swift
//  DayPlans
//
//  Created by Will Brandon on 10/4/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import Foundation

class Serializer {
    
    static let current = Serializer()
    
    private init() {}
    
    func serialize<T: Encodable>(encodable: T) -> String? {
        let encoder = JSONEncoder()
        if let serializedData = try? encoder.encode(encodable) {
            return String(data: serializedData, encoding: .utf8)
        }
        return nil
    }
    
    func deserialize<T: Decodable>(decodableType: T.Type, serializedObject: String) -> T? {
        let decoder = JSONDecoder()
        if let serializedData = serializedObject.data(using: .utf8) {
            let decodable = try? decoder.decode(decodableType, from: serializedData)
            return decodable
        }
        return nil
    }
    
}

//
//  IncJSONRepresentable.swift
//  GigSalad
//
//  Created by Leif Meyer on 2/24/17.
//  Copyright © 2017 Incipia. All rights reserved.
//

import Foundation

public protocol IncJSONRepresentable {
   var jsonRepresentation: Any? { get }
}

public protocol IncKVJSONRepresentable: IncJSONRepresentable, IncKVCompliance {
   static var jsonKeys: [Key] { get }
}

public extension IncKVJSONRepresentable {
   static var jsonKeys: [Key] { return Key.all }
   
   var jsonRepresentation: Any? {
      var json: [String : Any] = [:]
      Self.jsonKeys.forEach {
         var value = self.value(for: $0)
         if let someValue = value, let factory = $0 as? IncJSONFactory {
            value = factory.json(value: someValue)
         }
         if let representableValue = value as? IncJSONRepresentable {
            json[$0.rawValue] = representableValue.jsonRepresentation
         } else {
            json[$0.rawValue] = value
         }
      }
      return json
   }
}

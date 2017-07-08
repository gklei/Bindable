//
//  DictionaryRepresentable.swift
//  Pods
//
//  Created by Leif Meyer on 7/7/17.
//
//

import Foundation

public protocol IncDictionaryRepresentable {
   var dictionaryRepresentation: [String : Any]? { get }
}

public protocol IncKVDictionaryRepresentable: IncDictionaryRepresentable, IncKVCompliance {
   static var dictionaryKeys: [Key] { get }
}

public extension IncKVDictionaryRepresentable {
   static var dictionaryKeys: [Key] { return Key.all }

   var dictionaryRepresentation: [String : Any]? {
      var dictionary: [String : Any] = [:]
      Self.dictionaryKeys.forEach {
         dictionary[$0.rawValue] = self.value(for: $0)
      }
      return dictionary
   }

   var deepDictionaryRepresentation: [String : Any]? {
      var dictionary: [String : Any] = [:]
      Self.dictionaryKeys.forEach {
         let value = self.value(for: $0)
         if let representableValue = value as? IncDictionaryRepresentable {
            dictionary[$0.rawValue] = representableValue.dictionaryRepresentation
         } else {
            dictionary[$0.rawValue] = value
         }
      }
      return dictionary
   }
}

//
//  IncJSONInitable.swift
//  GigSalad
//
//  Created by Leif Meyer on 2/24/17.
//  Copyright © 2017 Incipia. All rights reserved.
//

import Foundation

public enum IncJSONError: Error {
   case invalidType(selfType: String, valueType: String)
   case invalidValue(selfType: String, value: String)
}

public protocol IncJSONInitable {
   init?(json: Any) throws
}

public extension IncJSONInitable {
   static func jsonTypeError(value: Any) -> IncJSONError { return .invalidType(selfType: "\(Self.self)", valueType: "\(type(of: value))") }
   static func jsonValueError(value: Any) -> IncJSONError { return .invalidValue(selfType: "\(Self.self)", value: "\(value)") }
}

public protocol IncJSONFactory {
   func value(json: Any) throws -> Any?
}

public extension IncJSONFactory {
   func value(json: Any) throws -> Any? {
      return json
   }
}

public protocol IncKVJSONInitable: IncJSONInitable, IncKVCompliance {
   static var jsonKeys: [Key] { get }
   init()
}

public extension IncKVJSONInitable {
   static var jsonKeys: [Key] { return Key.all }
   
   init?(json: Any) throws {
      guard let dictionary = json as? [String : Any] else { throw Self.jsonTypeError(value: json) }
      self.init()
      try update(with: dictionary)
   }
   
   mutating func update(with dictionary: [String : Any]) throws {
      try Self.jsonKeys.forEach {
         var value = dictionary[$0.rawValue]
         if let someValue = value, let factory = $0 as? IncJSONFactory {
            value = try factory.value(json: someValue)
         }
         try self.set(value: value, for: $0)
      }
   }
}

public protocol IncKVJSONInitableClass: class, IncKVJSONInitable, IncKVComplianceClass {}

public extension IncKVJSONInitableClass {
   func update(with dictionary: [String : Any]) throws {
      try Self.jsonKeys.forEach {
         var value = dictionary[$0.rawValue]
         if let someValue = value, let factory = $0 as? IncJSONFactory {
            value = try factory.value(json: someValue)
         }
         try self.set(value: value, for: $0)
      }
   }
}

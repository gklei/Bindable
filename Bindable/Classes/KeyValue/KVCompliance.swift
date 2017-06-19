//
//  IncKVCompliance.swift
//  GigSalad
//
//  Created by Leif Meyer on 2/24/17.
//  Copyright © 2017 Incipia. All rights reserved.
//

import Foundation

public protocol IncKVKeyType: Hashable {
   var rawValue: String { get }
   init?(rawValue: String)
   func kvTypeError(value: Any?) -> IncKVError
   static var all: [Self] { get }
}

public extension IncKVKeyType {
   static var all: [Self] {
      var all: [Self] = []
      for element in IncIterateEnum(Self.self) {
         all.append(element)
      }
      return all
   }
   
   func kvTypeError(value: Any?) -> IncKVError {
      let valueString: String = {
         guard let value = value else { return "nil" }
         return "\(type(of: value))"
      }()

      return IncKVError.valueType(key: "\(type(of: self)).\(self.rawValue)", value: valueString)
   }
}

public enum IncKVError: Error {
   case valueType(key: String, value: String)
}

public struct IncEmptyKey: IncKVKeyType {
   public var rawValue: String { return "" }
   public init?(rawValue: String) { return nil }
   public static var all: [IncEmptyKey] { return [] }
   public var hashValue: Int { return 0 }
   public static func == (lhs: IncEmptyKey, rhs: IncEmptyKey) -> Bool { return false }
}

public protocol IncKVCompliance: IncKVStringCompliance {
   associatedtype Key: IncKVKeyType
   
   func value(for key: Key) -> Any?
   mutating func set(value: Any?, for key: Key) throws
}

public extension IncKVCompliance {
   // MARK: - Subscripts
   subscript(key: Key) -> Any? {
      get { return value(for: key) }
      set { try! set(value: newValue, for: key) }
   }

   // MARK: - Type Casting
   func cast<T>(key: Key) -> T? {
      return value(for: key) as? T
   }
   
   func cast<T>(key: Key, default defaultValue: T) -> T {
      return value(for: key) as? T ?? defaultValue
   }
   
   func forceCast<T>(key: Key) -> T {
      return value(for: key) as! T
   }
}

public protocol IncKVComplianceClass: class, IncKVCompliance {
   // MARK: - Mutating
   func set(value: Any?, for key: Key) throws
}

public extension IncKVComplianceClass {
   // MARK: - Mutating
   subscript(key: Key) -> Any? {
      get { return value(for: key) }
      set { try! set(value: newValue, for: key) }
   }
}

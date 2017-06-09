//
//  IncKVStringCompliance.swift
//  GigSalad
//
//  Created by Leif Meyer on 3/3/17.
//  Copyright © 2017 Incipia. All rights reserved.
//

import Foundation

public enum IncKVStringError: Error {
   case invalidKey(key: String)
}

public protocol IncKVStringCompliance {
   func value(for key: String) -> Any?
   mutating func set(value: Any?, for key: String) throws
}

public extension IncKVStringCompliance {
   // MARK: - Subscripts
   subscript(key: String) -> Any? {
      get { return value(for: key) }
      set { try! set(value: newValue, for: key) }
   }
   
   // MARK: - Type Casting
   func cast<T>(key: String) -> T? {
      return value(for: key) as? T
   }
   
   func cast<T>(key: String, default defaultValue: T) -> T {
      return value(for: key) as? T ?? defaultValue
   }
   
   func forceCast<T>(key: String) -> T {
      return value(for: key) as! T
   }
}

public extension IncKVCompliance {
   func value(for key: String) -> Any? {
      guard let key = try? Key(keyString: key) else { return nil }
      return value(for: key)
   }
   
   mutating func set(value: Any?, for key: String) throws {
      let key = try Key(keyString: key)
      try set(value: value, for: key)
   }
}

public extension IncKVKeyType {
   init(keyString: String) throws {
      guard let key = Self.init(rawValue: keyString) else { throw IncKVStringError.invalidKey(key: "\(Self.self).\(keyString)") }
      self = key
   }
}

public protocol IncKVStringComplianceClass: class, IncKVStringCompliance {
   // MARK: - Mutating
   func set(value: Any?, for key: String) throws
}

public extension IncKVStringComplianceClass {
   // MARK: - Mutating
   subscript(key: String) -> Any? {
      get { return value(for: key) }
      set { try! set(value: newValue, for: key) }
   }
}

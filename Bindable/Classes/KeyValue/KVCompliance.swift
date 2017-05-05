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

public protocol IncKVCompliance: KVStringCompliance {
   associatedtype Key: IncKVKeyType
   
   func value(for key: Key) -> Any?
   mutating func set(value: Any?, for key: Key) throws
}

public protocol IncKVComplianceClass: class, IncKVCompliance {
   func set(value: Any?, for key: Key) throws
}

//
//  KVEvent.swift
//  GigSalad
//
//  Created by Leif Meyer on 2/27/17.
//  Copyright © 2017 Incipia. All rights reserved.
//

import Foundation
import Bindable

enum KVEventCategory: String {
   case category1, category2
}

enum KVEventType: String {
   case type1, type2, type3
}

enum KVEventKey: String, KVKeyType {
   case category, type, venueNameOrAddress, venueLegalAddress
}

class KVEvent: KVCompliance {
   var category: KVEventCategory
   var type: KVEventType?
   var venueNameOrAddress: String
   var venueLegalAddress: String?
   
   required init() {
      category = .category1
      type = .type1
      venueNameOrAddress = ""
      venueLegalAddress = ""
   }
   
   func value(for key: KVEventKey) -> Any? {
      switch key {
      case .category(_): return category
      case .type: return type
      case .venueNameOrAddress: return venueNameOrAddress
      case .venueLegalAddress: return venueLegalAddress
      }
   }
   
   func set(value: Any?, for key: KVEventKey) throws {
      switch key {
      case .category:
         guard let validValue = value as? KVEventCategory else { throw key.kvTypeError(value: value) }
         category = validValue
      case .type:
         guard value != nil else { type = nil; return }
         guard let validValue = value as? KVEventType else { throw key.kvTypeError(value: value) }
         type = validValue
      case .venueNameOrAddress:
         guard let validValue = value as? String else { throw key.kvTypeError(value: value) }
         venueNameOrAddress = validValue
      case .venueLegalAddress:
         guard let validValue = value as? String else { throw key.kvTypeError(value: value) }
         venueLegalAddress = validValue
      }
   }
}

//
//  BindableEvent.swift
//  GigSalad
//
//  Created by Leif Meyer on 2/27/17.
//  Copyright © 2017 Incipia. All rights reserved.
//

import Foundation
import Bindable

class BindableEvent: KVEvent, Bindable {
   var bindingBlocks: [KVEventKey : [((targetObject: AnyObject, rawTargetKey: String)?, Any?) throws -> Bool?]] = [:]
   var keysBeingSet: [KVEventKey] = []

   override var category: KVEventCategory {
      didSet { trySetBoundValue(category, for: .category) }
   }
   override var type: KVEventType? {
      didSet { trySetBoundValue(type, for: .type) }
   }
   override var venueNameOrAddress: String {
      didSet { trySetBoundValue(venueNameOrAddress, for: .venueNameOrAddress) }
   }
   override var venueLegalAddress: String? {
      didSet { trySetBoundValue(venueLegalAddress, for: .venueLegalAddress) }
   }
   
   override func set(value: Any?, for key: KVEventKey) throws {
      try setAsBindable(value: value, for: key)
   }
   
   func setOwn(value: Any?, for key: KVEventKey) throws {
      try super.set(value: value, for: key)
   }
}

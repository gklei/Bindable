//
//  BindingTests.swift
//  GigSalad
//
//  Created by Leif Meyer on 2/24/17.
//  Copyright © 2017 Incipia. All rights reserved.
//

import XCTest
import Bindable

class KVTests: XCTestCase {

   func testKeyedValueEqualsProperty() {
      let event = KVEvent()
      let category = event.value(for: .category) as? KVEventCategory
      XCTAssertEqual(category, event.category)
   }
   
   func testKeyedValueEqualsSetValue() {
      let event = KVEvent()

      do { try event.set(value: KVEventCategory.category2, for: .category) }
      catch { XCTFail() }
      
      let category = event.value(for: .category) as? KVEventCategory
      XCTAssertEqual(category, KVEventCategory.category2)
   }
   
   func testStringKeyedValueEqualsProperty() {
      let event = KVEvent()
      let category = event.value(for: "category") as? KVEventCategory
      XCTAssertEqual(category, event.category)
   }
   
   func testStringKeyedValueEqualsSetValue() {
      var event = KVEvent()
      
      do { try event.set(value: KVEventCategory.category2, for: "category") }
      catch { XCTFail() }
      
      let category = event.value(for: "category") as? KVEventCategory
      XCTAssertEqual(category, KVEventCategory.category2)
   }
   
}

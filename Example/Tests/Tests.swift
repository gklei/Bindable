// https://github.com/Quick/Quick

import Quick
import Nimble
import Bindable

class TableOfContentsSpec: QuickSpec {
   override func spec() {
      describe("key-value compliant objects") {
         let event = KVEvent()
         
         it("can retrieve values") {
            let category = event.value(for: .category) as? KVEventCategory
            expect(category) == event.category
         }
         
      }
   }
}

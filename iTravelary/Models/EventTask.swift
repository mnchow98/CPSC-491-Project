import Foundation
import SwiftUI
import SwiftData

@Model
class EventTask {
    var text: String
    var isCompleted: Bool
    var isNew: Bool
    
    init(text: String = "", isCompleted: Bool = false, isNew: Bool = false) {
        self.text = text
        self.isCompleted = isCompleted
        self.isNew = isNew
    }
}

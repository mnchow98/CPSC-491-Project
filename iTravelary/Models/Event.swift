import Foundation
import SwiftUI
import SwiftData

@Model
class Event {
    var name: String
    var symbolImage: String
    var symbolImageColor: String
    var date: Date
    var time: Date
    var tasks: [EventTask]
    
    init(name: String, symbolImage: String, symbolImageColor: String, date: Date, time: Date, tasks: [EventTask] = [EventTask(text: "")]) {
        self.name = name
        self.symbolImage = symbolImage
        self.symbolImageColor = symbolImageColor
        self.date = date
        self.time = time
        self.tasks = tasks
    }
}

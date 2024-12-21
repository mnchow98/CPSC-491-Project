import SwiftUI
import SwiftData

@main
struct iTravelaryApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [EventTask.self, Event.self], isUndoEnabled: true)
        }
    }
}

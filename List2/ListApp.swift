import SwiftUI

@main
struct ListApp: App {
    
    init() {
        _ = ListDatabase.shared.create()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

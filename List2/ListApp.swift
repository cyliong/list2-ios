import SwiftUI

@main
struct ListApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    init() {
        _ = ListDatabase.shared.create()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

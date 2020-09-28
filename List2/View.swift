import SwiftUI
import WidgetKit

extension View {
    func reloadTimelinesOfListWidget() {
        if #available(iOS 14, *) {
            WidgetCenter.shared.reloadTimelines(
                ofKind: "com.example.ltp.list-widget"
            )
        }
    }
}

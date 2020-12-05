import SwiftUI
import WidgetKit

extension View {
    func reloadTimelinesOfListWidget() {
        WidgetCenter.shared.reloadTimelines(
            ofKind: Constants.widgetKind
        )
    }
}

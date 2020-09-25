import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> ListEntry {
        ListEntry(date: Date(), items: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (ListEntry) -> ()) {
        let entry = ListEntry(date: Date(), items: [])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [ListEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = ListEntry(date: entryDate, items: [])
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct ListEntry: TimelineEntry {
    let date: Date
    let items: [ListItem]
}

struct ListWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}

@main
struct ListWidget: Widget {
    let kind: String = "com.example.ltp.list-widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ListWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("List")
        .description("Display list items.")
    }
}

struct ListWidget_Previews: PreviewProvider {
    static let items = [
        ListItem(id: 1, title: "Item 1"),
        ListItem(id: 2, title: "Item 2"),
    ]
    
    static var previews: some View {
        ListWidgetEntryView(entry: ListEntry(date: Date(), items: items))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

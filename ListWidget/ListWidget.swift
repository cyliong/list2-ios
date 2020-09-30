import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    private var entry: ListEntry {
        ListEntry(date: Date(), items: ListDatabase.shared.listItemDao.getAll())
    }
    
    func placeholder(in context: Context) -> ListEntry {
        let sampleItems = [
            ListItem(id: 1, title: "Item 1"),
            ListItem(id: 2, title: "Item 2"),
        ]
        return ListEntry(date: Date(), items: sampleItems)
    }

    func getSnapshot(in context: Context, completion: @escaping (ListEntry) -> ()) {
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let timeline = Timeline(entries: [entry], policy: .never)
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
        ZStack {
            VStack(alignment: .leading) {
                Text("List")
                    .font(.headline)
                    .bold()
                
                ForEach(entry.items) { item in
                    Text(item.title)
                        .font(.system(size: 15))
                    Divider()
                }
                .padding(1)
            }
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .padding()
        }
        .padding(3)
    }
}

@main
struct ListWidget: Widget {
    let kind: String = "com.example.ltp.list-widget"
    
    init() {
        _ = ListDatabase.shared.create()
    }

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ListWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("List")
        .description("Display list items.")
    }
}

struct ListWidget_Previews: PreviewProvider {
    static let items = (1...9).map { ListItem(id: $0, title: "Item \($0)") }
    
    static var previews: some View {
        Group {
            ListWidgetEntryView(entry: ListEntry(date: Date(), items: items))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            ListWidgetEntryView(entry: ListEntry(date: Date(), items: items))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            ListWidgetEntryView(entry: ListEntry(date: Date(), items: items))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}

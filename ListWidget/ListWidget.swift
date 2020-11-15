import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> ListEntry {
        let sampleItems = [
            ListItem(id: 1, title: "Item 1"),
            ListItem(id: 2, title: "Item 2"),
        ]
        return ListEntry(date: Date(), items: sampleItems)
    }

    func getSnapshot(in context: Context, completion: @escaping (ListEntry) -> ()) {
        completion(getEntry(in: context))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let timeline = Timeline(entries: [getEntry(in: context)], policy: .never)
        completion(timeline)
    }
    
    private func getEntry(in context: Context) -> ListEntry {
        let limit: Int
        switch context.family {
        case .systemLarge:
            limit = 8
        default:
            limit = 3
        }
        return ListEntry(
            date: Date(),
            items: ListDatabase.shared.listItemDao.getAll(limit: limit)
        )
    }
}

struct ListEntry: TimelineEntry {
    let date: Date
    let items: [ListItem]
}

struct ListWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family
    
    let titleTextView = Text(Constants.appTitle)
        .font(.headline)
        .bold()

    var body: some View {
        VStack(alignment: .leading) {
            if family == .systemSmall {
                titleTextView
            } else {
                HStack {
                    titleTextView
                    Spacer()
                    Link(destination: URL(string: Constants.addItemURLString)!) {
                        Image(systemName: "plus")
                    }
                }
            }
            
            if entry.items.isEmpty {
                VStack {
                    Text(Constants.noItems)
                        .foregroundColor(Color.gray)
                }
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity
                )
            } else {
                VStack(alignment: .leading) {
                    ForEach(entry.items) { item in
                        Link(
                            destination: URL(
                                string: "\(Constants.editItemURLString)\(item.id)"
                            )!
                        ) {
                            Text(item.title)
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                        }
                        .font(.system(size: 15))
                        
                        Divider()
                    }
                    .padding(.vertical, 1)
                }
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
                .padding(.top, 3)
            }
        }
        .padding()
    }
}

@main
struct ListWidget: Widget {
    init() {
        _ = ListDatabase.shared.create()
    }

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: Constants.widgetKind, provider: Provider()) {
            entry in
            ListWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(Constants.appTitle)
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

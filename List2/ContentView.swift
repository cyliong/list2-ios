import SwiftUI
import RealmSwift

struct ContentView: View {
    @State private var listItems = ListItem.findAll()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(listItems) { item in
                    if !item.isInvalidated {
                        NavigationLink(destination: ItemView(listItems: self.$listItems, item: item)) {
                            Text(item.title)
                        }
                    }
                }
                .onDelete { indexSet in
                    let realm = try! Realm()
                    try! realm.write {
                        indexSet.forEach { realm.delete(self.listItems[$0]) }
                        self.listItems = ListItem.findAll(from: realm)
                    }
                }
            }
            .navigationBarTitle("List")
            .navigationBarItems(trailing: NavigationLink(destination: ItemView(listItems: $listItems)) {
                Image(systemName: "plus")
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

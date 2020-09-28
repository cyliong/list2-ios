import SwiftUI

struct ContentView: View {
    @State private var listItems = ListDatabase.shared.listItemDao.getAll()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(listItems) { item in
                    NavigationLink(destination: ItemView(listItems: self.$listItems, item: item)) {
                        Text(item.title)
                    }
                }
                .onDelete { indexSet in
                    let dao = ListDatabase.shared.listItemDao
                    indexSet.forEach { dao.delete(id: self.listItems[$0].id) }
                    self.listItems = dao.getAll()
                    
                    reloadTimelinesOfListWidget()
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

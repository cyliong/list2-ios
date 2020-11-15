import SwiftUI

struct ContentView: View {
    @State private var listItems = ListDatabase.shared.listItemDao.getAll()
    @State private var isAddItemLinkActive = false
    @State private var selectedItemId: Int? = nil
    
    var body: some View {
        NavigationView {
            Group {
                if listItems.isEmpty {
                    Text(Constants.noItems)
                        .foregroundColor(.gray)
                        .font(.title)
                } else {
                    List {
                        ForEach(listItems) { item in
                            NavigationLink(
                                destination: ItemView(
                                    listItems: self.$listItems,
                                    item: item
                                ),
                                tag: item.id,
                                selection: $selectedItemId
                            ) {
                                Text(item.title)
                            }
                        }
                        .onDelete { indexSet in
                            let dao = ListDatabase.shared.listItemDao
                            indexSet.forEach {
                                dao.delete(id: self.listItems[$0].id)
                                
                            }
                            self.listItems = dao.getAll()

                            reloadTimelinesOfListWidget()
                        }
                    }
                }
            }
            .navigationBarTitle(Constants.appTitle)
            .navigationBarItems(
                trailing: NavigationLink(
                    destination: ItemView(listItems: $listItems),
                    isActive: $isAddItemLinkActive
                ) {
                    Image(systemName: "plus")
                }
            )
        }
        .onOpenURL { (url) in
            if url.absoluteString == Constants.addItemURLString {
                isAddItemLinkActive = true
            } else if url.absoluteString.starts(with: Constants.editItemURLString) {
                if let itemId = Int(url.lastPathComponent) {
                    selectedItemId = itemId
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

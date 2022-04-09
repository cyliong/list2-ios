import SwiftUI

struct ItemView: View {
    @Binding var listItems: [ListItem]
    var item: ListItem?
    
    @Environment(\.presentationMode) private var presentationMode
    @State private var itemTitle = ""
    @State private var showAlert = false
    
    private var isNew: Bool { item == nil }
    
    var body: some View {
        Form {
            TextField("Enter an item", text: $itemTitle)
                .onAppear {
                    if !self.isNew {
                        self.itemTitle = self.item!.title
                    }
                }
                .accessibilityIdentifier("title")
        }
        .navigationTitle(isNew ? "New Item" : "Edit Item")
        .navigationBarItems(
            trailing: Button("Save") {
                if self.itemTitle.trimmingCharacters(in: .whitespaces).isEmpty {
                    self.showAlert = true
                } else {
                    let dao = ListDatabase.shared.listItemDao
                    if self.isNew {
                        let listItem = ListItem(title: self.itemTitle)
                        dao.insert(listItem)
                    } else {
                        var item = self.item!
                        item.title = self.itemTitle
                        dao.update(item)
                    }
                    self.listItems = dao.getAll()
                    self.presentationMode.wrappedValue.dismiss()
                    
                    reloadTimelinesOfListWidget()
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Please enter an item."))
            }
        )
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ItemView(listItems: .constant([]))
        }
    }
}

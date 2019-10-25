import SwiftUI
import RealmSwift

struct ItemView: View {
    @Binding var listItems: Results<ListItem>
    var item: ListItem?
    
    @Environment(\.presentationMode) private var presentationMode
    @State private var itemTitle = ""
    @State private var showAlert = false
    
    private var isNew: Bool { item == nil }
    private var itemIndex: Int { listItems.firstIndex(where: { $0.id == self.item?.id }) ?? -1 }
    
    var body: some View {
        Form {
            TextField("Enter an item", text: $itemTitle)
                .onAppear {
                    if !self.isNew {
                        self.itemTitle = self.listItems[self.itemIndex].title
                    }
                }
        }
        .navigationBarTitle(isNew ? "New Item" : "Edit Item")
        .navigationBarItems(
            trailing: Button("Save") {
                if self.itemTitle.isEmpty {
                    self.showAlert = true
                } else {
                    let realm = try! Realm()
                    try! realm.write {
                        if self.isNew {
                            let listItem = ListItem(title: self.itemTitle)
                            realm.add(listItem)
                        } else {
                            self.listItems[self.itemIndex].title = self.itemTitle
                        }
                        self.listItems = realm.objects(ListItem.self)
                    }
                    self.presentationMode.wrappedValue.dismiss()
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
            ItemView(listItems: .constant(try! Realm().objects(ListItem.self)))
        }
    }
}

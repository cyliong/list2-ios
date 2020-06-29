import Foundation
import RealmSwift

class ListItem: Object, Identifiable {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var title = ""
    @objc dynamic var created = Date()
    
    convenience init(title: String) {
        self.init()
        self.title = title
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

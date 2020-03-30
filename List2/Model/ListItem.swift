struct ListItem: Entity, Identifiable {
    
    // MARK: - Column names
    private static let idColumn = "id"
    private static let titleColumn = "title"
    
    // MARK: - Properties
    let id: Int
    var title: String
    
    // MARK: - Initialization
    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
    
    init(title: String) {
        self.init(id: 0, title: title)
    }
    
    // MARK: - Entity
    static let tableName = "list_item"
    static var primaryKey: String? = idColumn
    
    init?(columnValues: [String: Any?]) {
        guard let id = columnValues[Self.idColumn] as? Int,
            let title = columnValues[Self.titleColumn] as? String
        else {
            return nil
        }
        self.id = id
        self.title = title
    }
    
    func columnValues() -> [String: Any?] {
        [Self.idColumn: id, Self.titleColumn: title]
    }
    
}

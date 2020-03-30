final class ListDatabase: AppDatabase {
    
    static let shared = ListDatabase(
        name: "list.db",
        createStatements: [
            "CREATE TABLE IF NOT EXISTS `list_item` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `title` TEXT NOT NULL)"
        ]
    )
    
    lazy var listItemDao = DAO<ListItem>(self)
    
}

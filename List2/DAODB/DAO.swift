class DAO<E: Entity> {
    
    let database: AppDatabase
    
    init(_ database: AppDatabase) {
        self.database = database
    }
    
    func getAll() -> [E] {
        let listOfColumnValues = database.query(table: E.tableName)
        var entities = [E]()
        for columnValues in listOfColumnValues {
            if let entity = E(columnValues: columnValues) {
                entities.append(entity)
            }
        }
        return entities
    }
    
    func get(id: Int) -> E? {
        guard let primaryKey = E.primaryKey else {
            return nil
        }
        let listOfColumnValues = database.query(
            table: E.tableName,
            selection: "\(primaryKey)=?",
            selectionArgs: [id]
        )
        guard let columnValues = listOfColumnValues.first else {
            return nil
        }
        return E(columnValues: columnValues)
    }
    
    @discardableResult
    func insert(_ entity: E) -> Int {
        var columnValues = entity.columnValues()
        if let primaryKey = E.primaryKey {
            columnValues[primaryKey] = nil
        }
        return database.insert(table: E.tableName, columnValues: columnValues)
    }
    
    @discardableResult
    func update(_ entity: E) -> Int {
        let columnValues = entity.columnValues()
        guard let primaryKey = E.primaryKey,
            let idValue = columnValues[primaryKey],
            let id = idValue
        else {
            return 0
        }
        return database.update(
            table: E.tableName,
            columnValues: columnValues,
            whereClause: "\(primaryKey)=?",
            whereArgs: [id]
        )
    }
    
    @discardableResult
    func delete(id: Int) -> Int {
        guard let primaryKey = E.primaryKey else {
            return 0
        }
        return database.delete(table: E.tableName, whereClause: "\(primaryKey)=?", whereArgs: [id])
    }
    
}

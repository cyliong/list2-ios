class AppDatabase {
    
    private let name: String
    private let createStatements: [String]
    private var database: FMDatabase?
    
    init(name: String, createStatements: [String]) {
        self.name = name
        self.createStatements = createStatements
    }
    
    func create() -> Bool {
        do {
            let databaseURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(name)
            database = FMDatabase(url: databaseURL)
            if let database = database, open() {
                for statement in createStatements {
                    try database.executeUpdate(statement, values: nil)
                }
                close()
            }
            return true
        } catch {
            return false
        }
    }
    
    func open() -> Bool {
        database?.open() ?? false
    }
    
    func close() {
        database?.close()
    }
    
    func query(
        table: String,
        columns: [String]? = nil,
        selection: String? = nil,
        selectionArgs: [Any]? = nil,
        groupBy: String? = nil,
        having: String? = nil,
        orderBy: String? = nil,
        limit: String? = nil
    ) -> [[String: Any?]] {
        
        let columnList: String
        if columns == nil {
            columnList = "*"
        } else {
            columnList = columns!.joined(separator: ", ")
        }
        
        var statement = "SELECT \(columnList) FROM \(table)"
        
        if let selection = selection {
            statement += " WHERE \(selection)"
        }
        if let groupBy = groupBy {
            statement += " GROUP BY \(groupBy)"
        }
        if let having = having {
            statement += " HAVING \(having)"
        }
        if let orderBy = orderBy {
            statement += " ORDER BY \(orderBy)"
        }
        if let limit = limit {
            statement += " LIMIT \(limit)"
        }
        
        var listOfColumnValues = [[String: Any?]]()
        if let database = database,
            open(),
            let resultSet = database.executeQuery(statement, withArgumentsIn: selectionArgs ?? [])
        {
            while resultSet.next() {
                var columnValues = [String: Any?]()
                for columnIndex in 0..<resultSet.columnCount {
                    if let columnName = resultSet.columnName(for: columnIndex) {
                        columnValues[columnName] = resultSet.object(forColumnIndex: columnIndex)
                    }
                }
                if !columnValues.isEmpty {
                    listOfColumnValues.append(columnValues)
                }
            }
            close()
        }
        return listOfColumnValues
    }
    
    func insert(table: String, columnValues: [String: Any?]) -> Int {
        var columns = "("
        var placeholders = "("
        var values = [Any]()
        
        for (column, value) in columnValues {
            columns += column + ", "
            placeholders += "?, "
            values.append(value ?? NSNull())
        }
        
        columns.removeLast(2)
        columns += ")"
        
        placeholders.removeLast(2)
        placeholders += ")"
        
        let statement = "INSERT INTO \(table) \(columns) VALUES \(placeholders)"
        
        guard let database = database, open() else {
            return -1
        }
        if database.executeUpdate(statement, withArgumentsIn: values) {
            let rowId = Int(database.lastInsertRowId)
            close()
            return rowId == 0 ? -1 : rowId
        } else {
            close()
            return -1
        }
    }
    
    func update(table: String, columnValues: [String: Any?], whereClause: String? = nil, whereArgs: [Any]? = nil) -> Int {
        var statement = "UPDATE \(table) SET "
        var values = [Any]()
        
        for (column, value) in columnValues {
            statement += "\(column)=?, "
            values.append(value ?? NSNull())
        }
        statement.removeLast(2)
        
        if let whereClause = whereClause {
            statement += " WHERE \(whereClause)"
        }
        
        if let whereArgs = whereArgs {
            for arg in whereArgs {
                values.append(arg)
            }
        }
        
        guard let database = database, open() else {
            return 0
        }
        if database.executeUpdate(statement, withArgumentsIn: values) {
            let rowsAffected = Int(database.changes)
            close()
            return rowsAffected
        } else {
            close()
            return 0
        }
    }
    
    func delete(table: String, whereClause: String? = nil, whereArgs: [Any]? = nil) -> Int {
        var statement = "DELETE FROM \(table) "
        
        if let whereClause = whereClause {
            statement += "WHERE \(whereClause)"
        }
        
        guard let database = database, open() else {
            return 0
        }
        if database.executeUpdate(statement, withArgumentsIn: whereArgs ?? []) {
            let rowsAffected = Int(database.changes)
            close()
            return rowsAffected
        } else {
            close()
            return 0
        }
    }
    
}

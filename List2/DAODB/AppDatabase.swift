import Foundation
import GRDB

class AppDatabase {
    
    private let name: String
    private let group: String?
    private let createStatements: [String]
    private var databaseQueue: DatabaseQueue?
    
    init(name: String, group: String? = nil, createStatements: [String]) {
        self.name = name
        self.group = group
        self.createStatements = createStatements
    }
    
    func create() -> Bool {
        let baseURL: URL
        do {
            if let group = group {
                guard let containerURL = FileManager.default
                        .containerURL(
                            forSecurityApplicationGroupIdentifier: group
                        )
                else {
                    return false
                }
                baseURL = containerURL
            } else {
                baseURL = try FileManager.default
                    .url(
                        for: .applicationSupportDirectory,
                        in: .userDomainMask,
                        appropriateFor: nil,
                        create: true
                    )
            }
            
            let databaseURL = baseURL.appendingPathComponent(name)
            databaseQueue = try DatabaseQueue(path: databaseURL.path)
            try databaseQueue!.write { database in
                for statement in createStatements {
                    try database.execute(sql: statement)
                }
            }
            return true
        } catch {
            return false
        }
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
        if let databaseQueue = databaseQueue,
           let arguments = StatementArguments(selectionArgs ?? []),
           let rows = try? databaseQueue.read({ database in
               try Row.fetchAll(database, sql: statement, arguments: arguments)
           })
        {
            for row in rows {
                var columnValues = [String: Any?]()
                for (column, databaseValue) in row {
                    switch databaseValue.storage {
                    case .int64:
                        columnValues[column] = Int.fromDatabaseValue(databaseValue)
                    default:
                        columnValues[column] = databaseValue.storage.value
                    }
                }
                if !columnValues.isEmpty {
                    listOfColumnValues.append(columnValues)
                }
            }
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
        
        guard let databaseQueue = databaseQueue,
              let arguments = StatementArguments(values)
        else {
            return -1
        }
        do {
            var rowId = -1
            try databaseQueue.write { database in
                try database.execute(sql: statement, arguments: arguments)
                rowId = Int(database.lastInsertedRowID)
            }
            return rowId > 0 ? rowId : -1
        } catch {
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
        
        guard let databaseQueue = databaseQueue,
              let arguments = StatementArguments(values)
        else {
            return 0
        }
        do {
            var rowsAffected = 0
            try databaseQueue.write { database in
                try database.execute(sql: statement, arguments: arguments)
                rowsAffected = database.changesCount
            }
            return rowsAffected
        } catch {
            return 0
        }
    }
    
    func delete(table: String, whereClause: String? = nil, whereArgs: [Any]? = nil) -> Int {
        var statement = "DELETE FROM \(table) "
        
        if let whereClause = whereClause {
            statement += "WHERE \(whereClause)"
        }
        
        guard let databaseQueue = databaseQueue,
              let arguments = StatementArguments(whereArgs ?? [])
        else {
            return 0
        }
        do {
            var rowsAffected = 0
            try databaseQueue.write { database in
                try database.execute(sql: statement, arguments: arguments)
                rowsAffected = database.changesCount
            }
            return rowsAffected
        } catch {
            return 0
        }
    }
    
}

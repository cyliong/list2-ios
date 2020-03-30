protocol Entity {
    
    static var tableName: String { get }
    static var primaryKey: String? { get }
    
    init?(columnValues: [String: Any?])
    
    func columnValues() -> [String: Any?]
    
}

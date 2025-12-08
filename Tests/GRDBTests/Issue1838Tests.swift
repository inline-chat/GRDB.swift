import Foundation
import GRDB
import os
import Testing

private struct Person: Codable, TableRecord, FetchableRecord, PersistableRecord {
    static let databaseTableName = "person"
    
    var id: Int
    var name: String
    
    enum Column: String, CodingKey, ColumnExpression {
        case id
        case name
    }
    typealias CodingKeys = Column
}

// MARK: -

private struct PersonText: Codable, TableRecord, FetchableRecord, PersistableRecord {
    static let databaseTableName = "person_text"
    
    let id: Int
    let content: String
    
    enum Column: String, CodingKey, ColumnExpression {
        case id
        case content
    }
    typealias CodingKeys = Column
}

// MARK: -

private final class SQLiteStore: Sendable {
    private let queue: DatabaseQueue
    
    init(queue: DatabaseQueue) {
        self.queue = queue
    }
    
    convenience init() throws {
        var configuration = Configuration()
        configuration.prepareDatabase { db in
            db.trace { print("SQL", $0) }
        }
        let queue = try DatabaseQueue(configuration: configuration)
        self.init(queue: queue)
        
        var migrator = DatabaseMigrator()
        migrator.registerMigration("Person/v1") { db in
            try db.create(table: Person.databaseTableName) { t in
                t.column(Person.Column.id.name, .integer).notNull().primaryKey()
                t.column(Person.Column.name.name, .text).notNull()
            }
            try db.create(virtualTable: PersonText.databaseTableName, using: FTS5()) { t in
                t.tokenizer = .porter(wrapping: .unicode61())
                t.column(PersonText.Column.id.name).notIndexed()
                t.column(PersonText.Column.content.name)
            }
        }
        try migrator.migrate(queue)
    }
    
    // MARK: -
    
    class Reader {
        let database: Database
        
        init(database: Database) {
            self.database = database
        }
        func fetchPersons() throws -> [Person] {
            return try Person
                .fetchAll(database)
        }
        func personExists(id: Int) throws -> Bool {
            return try Person
                .filter(Person.Column.id == id)
                .fetchCount(database) > 0
        }
    }
    
    // MARK: -
    
    final class Writer: Reader {
        func insert(_ person: Person) throws {
            try person
                .insert(database)
            try PersonText(id: person.id, content: person.name)
                .insert(database)
        }
        func ensure(_ id: Int, inserting person: @autoclosure () -> Person) throws {
            if try !personExists(id: id) {
                try insert(person())
            }
        }
    }
    
    // MARK: -
    
    func read<T>(_ body: @Sendable @escaping (Reader) throws -> T) async throws -> T where T: Sendable {
        return try await queue.read {
            try body(Reader(database: $0))
        }
    }
    
    func write<T>(_ body: @Sendable @escaping (Writer) throws -> T) async throws -> T where T: Sendable {
        return try await queue.write {
            try body(Writer(database: $0))
        }
    }
}

// MARK: -

struct Issue1838Tests {
    @Test func cancelWrite() async throws {
        let store = try SQLiteStore()
        
        let task = Task {
            do {
                try await store.write {
                    for i in 1... {
                        try $0.ensure(i, inserting: Person(id: i, name: "person \(i)"))
                        Thread.sleep(forTimeInterval: 0.1)
                        try Task.checkCancellation()
                    }
                }
            } catch {
                print("caught \(error)")
                throw error
            }
        }
        
        try await Task.sleep(for: .seconds(1))
        
        task.cancel()
        let _ = await task.result
    }
}

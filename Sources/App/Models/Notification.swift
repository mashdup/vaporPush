import Vapor
import FluentSQLite

final class Notification : Codable {
    var id : Int?
    var message : String
    var userId : Int
    
    
    init(message: String, user:Int) {
        self.message = message
        self.userId = user
    }
}

extension Notification : Migration {}
extension Notification : Content {}
extension Notification : SQLiteModel {}

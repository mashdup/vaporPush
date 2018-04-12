import Vapor
import FluentSQLite

final class Device : Codable {
    var id : Int?
    var userId: Int
    var deviceUUID : String
    
    init(userId: Int, deviceUUID : String) {
        self.userId = userId
        self.deviceUUID = deviceUUID
    }
}

extension Device : Migration {}
extension Device : Content {}
extension Device : SQLiteModel {}
extension Device : Parameter {}
extension Device : Model {}

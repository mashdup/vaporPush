import Vapor
import FluentSQLite

struct DeviceController : RouteCollection {
    let routeBase =  "devices"
    func boot(router: Router) throws {
        router.post("api",routeBase, use: createHandler)
        router.get("api",routeBase, use: getAllHandler)
        router.get("api",routeBase, Device.parameter, use: getDeviceHandler)
        router.get("api",routeBase,"user",Int.parameter, use: getDeviceByUserIdHandler)
        router.delete("api",routeBase,Device.parameter, use: deleteHandler)
    }
    
    func createHandler(_ req: Request) throws -> Future<Device> {
        return try req.content.decode(Device.self).flatMap(to: Device.self){ device in
            return device.save(on: req)
        }
    }
    
    func getAllHandler(_ req : Request) throws -> Future<[Device]> {
        return Device.query(on: req).all()
        
    }
    
    func getDeviceHandler(_ req : Request) throws -> Future<Device> {
        return try req.parameter(Device.self)
    }
    
    func getDeviceByUserIdHandler(_ req : Request) throws -> Future<Device> {
        
        let userId = try req.parameter(Int.self)
        return req.withConnection(to: .sqlite) { db -> Future<Device> in
            return try db.query(Device.self).filter(\.userId == userId).first().map(to: Device.self) { device in
                guard let device = device else {
                    throw Abort(.notFound, reason: "Could not find device")
                }
                return device
            }
        }
    }
    
    func deleteHandler(_ req : Request) throws -> Future <HTTPStatus> {

        let device = try req.parameter(Device.self)
        return device.delete(on: req).transform(to: .noContent)
        
    }
}

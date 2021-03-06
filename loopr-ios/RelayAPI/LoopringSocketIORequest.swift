//
//  LoopringWebSocketCaller.swift
//  loopr-ios
//
//  Created by kenshin on 2018/3/11.
//  Copyright © 2018年 Loopring. All rights reserved.
//

import Foundation
import SocketIO
import SwiftyJSON

public class LoopringSocketIORequest {
    
    static let url = "http://13.112.62.24"
//    static let url = "10.137.104.180:8087"
    
    static let manager = SocketManager(socketURL: URL(string: url)!, config: [.compress, .forceWebsockets(true)])
    static let socket = manager.defaultSocket
    static var handlers: [String: [(JSON) -> Void]] = [:]
    
    static func setup() {
        
        if handlers.isEmpty {
            // add more requests using socketio here
            handlers["balance_res"] = [AssetDataManager.shared.onBalanceResponse]
            handlers["marketcap_res"] = [PriceQuoteDataManager.shared.onPriceQuoteResponse]
            addHandlers(handlers)
        }
        if socket.status != .connected {
            socket.connect()
        }
    }
    
    static func tearDown() {
        socket.removeAllHandlers()
        socket.disconnect()
    }
    
    static func addHandlers(_ handlers: [String: [(JSON) -> Void]]) {
        
        for (key, methods) in handlers {
            for method in methods {
                socket.on(key, callback: { (data, _) in
                    if let string = data[0] as? String {
                        if let json = try? JSON(data: string.data(using: .utf8)!) {
                            method(json["data"])
                        }
                    }
                })
            }
        }
    }
    
    static func getBalance(owner: String) {
        var body: JSON = JSON()
        body["owner"] = JSON(owner)
        socket.on(clientEvent: .connect) {_, _ in
            self.socket.emit("balance_req", body.rawString()!)
        }
    }
    
    static func getPriceQuote(currency: String) {
        var body: JSON = JSON()
        body["currency"] = JSON(currency)
        socket.on(clientEvent: .connect) {_, _ in
            self.socket.emit("marketcap_req", body.rawString()!)
        }
    }
}

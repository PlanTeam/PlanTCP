//
//  TCPClient.swift
//  PlanTCP
//
//  Created by Robbert Brandsma on 11-02-16.
//  Copyright © 2016 PlanTeam. All rights reserved.
//

import Foundation
import Darwin

public enum TCPError : ErrorType {
    case ConnectionFailed
    case NotConnected
    case AlreadyConnected
    case SendFailure(errorCode: Int)
    case ReceiveFailure(errorCode: Int)
    case ConnectionClosedByServer
}

public class TCPClient {
    public let serverAddress: String
    public let port: UInt16
    public private(set) var connected = false
    
    private var sock: Int32 = -1
    
    /// - parameter server: Currently the server address as IPv4
    public init(server: String, port: UInt16) {
        self.serverAddress = server
        self.port = port
    }
    
    public func connect() throws {
        guard !connected else {
            throw TCPError.AlreadyConnected
        }
        
        self.sock = socket(AF_INET, SOCK_STREAM, 0)
        if sock == -1 {
            throw TCPError.ConnectionFailed
        }
        
        var server = sockaddr_in()
        server.sin_addr.s_addr = UInt32(inet_addr(serverAddress))
        server.sin_family = UInt8(AF_INET)
        server.sin_port = port.bigEndian
        
        try withUnsafePointer(&server) {
            if Foundation.connect(sock, UnsafePointer<sockaddr>($0), UInt32(sizeof(server.dynamicType))) < 0 {
                throw TCPError.ConnectionFailed
            }
        }
        
        connected = true
    }
    
    private func assertConnected() throws {
        guard connected else {
            throw TCPError.NotConnected
        }
    }
    
    public func send(buffer: [UInt8]) throws {
        try assertConnected()
        
        let code = Foundation.send(sock, buffer, buffer.count, 0)
        if code < 0 {
            throw TCPError.SendFailure(errorCode: code)
        }
    }
    
    public func receive(bufferSize: Int = 2048) throws -> [UInt8] {
        try assertConnected()
        
        // Allocate a buffer with the max size
        var buffer = [UInt8](count: bufferSize, repeatedValue: 0)
        let receivedBytes = Foundation.recv(sock, &buffer, buffer.count, 0)
        
        guard receivedBytes >= 0 else {
            throw TCPError.ReceiveFailure(errorCode: receivedBytes)
        }
        
        guard receivedBytes != 0 else {
            // The connection has been closed
            // TODO: Close it on our end
            throw TCPError.ConnectionClosedByServer
        }
        
        // Strip the zeroes
        buffer.removeRange(receivedBytes..<buffer.count)
        
        return buffer
    }
    
    public func disconnect() throws {
        try assertConnected()
        
        connected = false
        
        Foundation.close(sock)
    }
    
    public var numberOfBytesAvailable: Int { return Int(_plantcp_socket_get_bytes_available(sock)) }
    public var hasBytesAvailable: Bool { return numberOfBytesAvailable > 0 }
}
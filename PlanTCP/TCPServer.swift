//
//  TCPServer.swift
//  PlanTCP
//
//  Created by Joannis Orlandos on 19/02/16.
//  Copyright © 2016 PlanTeam. All rights reserved.
//

import Foundation
import Darwin

public class TCPServer {
    public private(set) var connected = false
    private var sock: Int32 = -1
    private var backlog: Int32 = 5
    public let port: UInt16
    
    public init(port: UInt16) {
        self.port = port
    }
    
    private func socklen_t_cast(p: UnsafePointer<Int>) -> UnsafePointer<socklen_t> {
        return UnsafePointer<socklen_t>(p)
    }
    
    public func bind() throws {
        guard !connected else {
            throw TCPError.AlreadyConnected
        }
        
        self.sock = socket(AF_INET, SOCK_STREAM, 0)
        
        if sock < 0 {
            throw TCPError.BindFailed
        }
        
        var server = sockaddr_in()
        server.sin_family = UInt8(AF_INET)
        // ANY IP address
        server.sin_addr.s_addr = UInt32(0x00000000)
        server.sin_port = port.bigEndian
        
        try withUnsafePointer(&server) {
            if Foundation.bind(sock, UnsafePointer<sockaddr>($0), socklen_t(sizeof(server.dynamicType))) < 0 {
                throw TCPError.BindFailed
            }
        }
        
        Foundation.listen(sock, backlog)
        
        connected = true
    }
    
    private func assertConnected() throws {
        guard connected else {
            throw TCPError.NotConnected
        }
    }
    
    public func send(clientSock: Int32, buffer: [UInt8]) throws {
        try assertConnected()
        
        let code = Foundation.send(clientSock, buffer, buffer.count, 0)
        if code < 0 {
            throw TCPError.SendFailure(errorCode: code)
        }
    }
    
    public func receive(clientSock: Int32, bufferSize: Int = 2048) throws -> [UInt8] {
        try assertConnected()
        
        // Allocate a buffer with the max size
        var buffer = [UInt8](count: bufferSize, repeatedValue: 0)
        let receivedBytes = Foundation.recv(clientSock, &buffer, buffer.count, 0)
        
        guard receivedBytes >= 0 else {
            throw TCPError.ReceiveFailure(errorCode: receivedBytes)
        }
        
        guard receivedBytes != 0 else {
            // The connection has been closed
            // TODO: Close it on our end
            throw TCPError.ConnectionClosed
        }
        
        // Strip the zeroes
        buffer.removeRange(receivedBytes..<buffer.count)
        
        return buffer
    }
    
    public func closeClient(clientSock: Int32) {
        shutdown(clientSock, 2)
        close(clientSock)
    }
    
    public func unbind() throws {
        close(sock)
    }
    
    public func getClient() throws -> Int32 {
        return _plantcp_socket_accept_client(sock)
    }
}
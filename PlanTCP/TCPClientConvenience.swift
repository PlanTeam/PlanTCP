//
//  TCPClientConvenience.swift
//  PlanTCP
//
//  Created by Robbert Brandsma on 11-02-16.
//  Copyright © 2016 PlanTeam. All rights reserved.
//

import Foundation

extension TCPClient {
    /// Send a string as UTF8 data
    /// 
    /// - parameter nullTerminate: If set to `true`, the string will be sent Null-terminated. If this is selected, and the string contains null characters, the existing null characters will be removed.
    public func send(text: String, nullTerminate: Bool = false) throws {
        var data: [UInt8] = Array(text.utf8)
        
        if nullTerminate {
            // remove null characters
            data = data.filter { $0 != 0 }
            
            // append 0x00
            data.append(0)
        }
        
        try send(data)
    }
}
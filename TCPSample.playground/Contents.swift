//: Playground - noun: a place where people can play

import PlanTCP

let google = TCPClient(server: "64.15.117.117", port: 80)

do {
    try google.connect()
    
    try google.send("GET / HTTP/1.1\r\nHost: www.google.nl\r\nConnection: close\r\n\r\n")
    
    while true {
    let res = try google.receive(160000)
    let stringVal = String(bytes: res, encoding: NSUTF8StringEncoding)
    }
} catch TCPError.ConnectionClosedByServer {
    
} catch {
    abort()
}
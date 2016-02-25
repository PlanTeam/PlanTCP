//
//  PlanTCP_priv.c
//  PlanTCP
//
//  Created by Robbert Brandsma on 11-02-16.
//  Copyright © 2016 PlanTeam. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include "PlanTCP_priv.h"

int _plantcp_socket_get_bytes_available(int socket) {
    int bytesAvailable;
    ioctl(socket, FIONREAD, &bytesAvailable);
    
    return bytesAvailable;
}

void _plantcp_socket_listen(int server_socket, int backlog) {
    listen(server_socket, backlog);
}

int _plantcp_socket_accept_client(int server_socket) {
    struct sockaddr_in client_addr;
    socklen_t client_length = sizeof(client_addr);
    
    return accept(server_socket, (struct sockaddr *) &client_addr, &client_length);
}
//
//  PlanTCP_priv.h
//  PlanTCP
//
//  Created by Robbert Brandsma on 11-02-16.
//  Copyright © 2016 PlanTeam. All rights reserved.
//

#ifndef PlanTCP_priv_h
#define PlanTCP_priv_h

int _plantcp_socket_get_bytes_available(int socket);
int _plantcp_socket_accept_client(int server_socket);

void _plantcp_socket_listen(int server_socket, int backlog);
    
#endif /* PlanTCP_priv_h */

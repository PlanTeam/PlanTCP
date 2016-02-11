//
//  PlanTCP_priv.c
//  PlanTCP
//
//  Created by Robbert Brandsma on 11-02-16.
//  Copyright © 2016 PlanTeam. All rights reserved.
//

#include <sys/ioctl.h>
#include "PlanTCP_priv.h"

int _plantcp_socket_get_bytes_available(int socket) {
    int bytesAvailable;
    ioctl(socket, FIONREAD, &bytesAvailable);
    
    return bytesAvailable;
}
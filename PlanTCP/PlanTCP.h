//
//  PlanTCP.h
//  PlanTCP
//
//  Created by Robbert Brandsma on 11-02-16.
//  Copyright © 2016 PlanTeam. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//! Project version number for PlanTCP.
FOUNDATION_EXPORT double PlanTCPVersionNumber;

//! Project version string for PlanTCP.
FOUNDATION_EXPORT const unsigned char PlanTCPVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <PlanTCP/PublicHeader.h>


// We need to import private headers here for briding to Swift, see: http://stackoverflow.com/a/24878877
#import <PlanTCP/PlanTCP_priv.h>
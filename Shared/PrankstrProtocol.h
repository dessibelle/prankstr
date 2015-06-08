//
//  PrankstrProtocol.h
//  prankstr
//
//  Created by Simon Fransson on 2015-06-04.
//  Copyright (c) 2015 Simon Fransson. All rights reserved.
//

#ifndef prankstr_PrankstrProtocol_h
#define prankstr_PrankstrProtocol_h

#define PRANKSTR_READ_TIMEOUT                       15.0
#define PRANKSTR_READ_TIMEOUT_EXTENSION             10.0

#define PRANKSTR_NET_SERVICE_DOMAIN                 "local."
#define PRANKSTR_NET_SERVICE_TYPE                   "_prankstr._tcp."

typedef enum _PrankstrStatus {
    PrankstrStatusOK = (long)0,
    PrankstrStatusError
} PrankstrStatus;

typedef enum _PrankstrCommand {
    PrankstrCommandNoMessage = (long)0,
    PrankstrCommandInvertColors,
    PrankstrCommandToggleCursorSize,
    PrankstrCommandSetCursorSize
} PrankstrCommand;

#endif
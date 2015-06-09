
//
//  PrankstrProtocol.c
//  prankstr
//
//  Created by Simon Fransson on 2015-06-09.
//  Copyright (c) 2015 Simon Fransson. All rights reserved.
//

#include <stdlib.h>
#include "PrankstrProtocol.h"


const char * prankstr_command_name(PrankstrCommand command)
{
    switch (command) {
        case PrankstrCommandToggleReduceTransparency:
            return "Toggle Reduce Transparency";
            break;
        case PrankstrCommandToggleIncreaseContrast:
            return "Toggle Increase Contrast";
            break;
        case PrankstrCommandToggleDifferentiateWithoutColor:
            return "Toggle Differentiate Without Color";
            break;
        case PrankstrCommandToggleInvertColor:
            return "Toggle InvertColor";
            break;
        case PrankstrCommandToggleGrayscale:
            return "Toggle Grayscale";
            break;
        case PrankstrCommandToggleContrast:
            return "Toggle Contrast";
            break;
        case PrankstrCommandSetContrast:
            return "Set Contrast";
            break;
        case PrankstrCommandToggleCursorSize:
            return "Toggle Cursor Size";
            break;
        case PrankstrCommandSetCursorSize:
            return "Set Cursor Size";
            break;
        case PrankstrCommandNoCommand:
            break;
    }
    
    return NULL;
}

int prankstr_command_argc(PrankstrCommand command)
{
    switch (command) {
        case PrankstrCommandToggleReduceTransparency:
            return 0;
            break;
        case PrankstrCommandToggleIncreaseContrast:
            return 0;
            break;
        case PrankstrCommandToggleDifferentiateWithoutColor:
            return 0;
            break;
        case PrankstrCommandToggleInvertColor:
            return 0;
            break;
        case PrankstrCommandToggleGrayscale:
            return 0;
            break;
        case PrankstrCommandToggleContrast:
            return 0;
            break;
        case PrankstrCommandSetContrast:
            return 1;
            break;
        case PrankstrCommandToggleCursorSize:
            return 0;
            break;
        case PrankstrCommandSetCursorSize:
            return 1;
            break;
        case PrankstrCommandNoCommand:
            break;
    }
    
    return 0;
}


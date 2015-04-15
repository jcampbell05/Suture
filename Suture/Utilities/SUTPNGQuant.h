//
//  SUTPNGQuan.h
//  Suture
//
//  Created by James Campbell on 15/4/15.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

@import Cocoa;
@import CoreGraphics;
#include <stdio.h>

#include "libimagequant.h"
#include "pam.h"
#include "rwpng.h"

png24_image SUTCreate24BitPNGImageFromContext(CGContextRef context);
png8_image SUTCreate8BitPNGImageFrom24BitImage(png24_image image);
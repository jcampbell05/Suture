//
//  SUTGeometry.h
//  Suture
//
//  Created by James Campbell on 26/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#ifndef Suture_SUTGeometry_h
#define Suture_SUTGeometry_h

CGRect SUTFlipCGRect(CGRect rect, CGSize size)
{
    rect.origin.y = size.height - CGRectGetMaxY(rect);
    return rect;
}

#endif

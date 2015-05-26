//
//  SUT32BitPNGExporter.m
//  Suture
//
//  Created by James Campbell on 26/05/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUT32BitPNGExporter.h"
#import "SUTSpriteLayout.h"

@implementation SUT32BitPNGExporter

- (NSString *)name
{
    return NSLocalizedString(@"png_32_image_exporter_nav",
                             nil);
}

- (NSString *)extension
{
    return @"png";
}

@end

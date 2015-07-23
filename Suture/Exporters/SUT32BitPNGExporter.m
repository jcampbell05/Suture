//
//  SUT32BitPNGExporter.m
//  Suture
//
//  Created by James Campbell on 26/05/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUT32BitPNGExporter.h"
#import "SUTSpritesheetLayout.h"

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

- (void)writeContext:(CGContextRef)context
                 url:(NSURL *)url
{
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)url,
                                                                        kUTTypePNG,
                                                                        1,
                                                                        NULL);
    if (!destination)
    {
        NSLog(@"Failed to create CGImageDestination for %@", url);
    }
    else
    {
        CGImageDestinationAddImage(destination, image, nil);
        
        if (!CGImageDestinationFinalize(destination))
        {
            NSLog(@"Failed to write image to %@", url);
        }
        
        CFRelease(destination);
    }
    
    CGImageRelease(image);
}

@end

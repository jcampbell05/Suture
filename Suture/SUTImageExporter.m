//
//  SUTImageExporter.m
//  Suture
//
//  Created by James Campbell on 17/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTImageExporter.h"
#import "SUTSpriteLayout.h"

@implementation SUTImageExporter

- (NSString *)name
{
    return @"Image Only";
}

- (void)exportDocument:(SUTDocument *)document
                   URL:(NSURL *)url
{
    CGSize contentSize = [document.layout contentSize];
    
    NSImage *image = [[NSImage alloc] initWithSize:contentSize];
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc]
                             initWithBitmapDataPlanes:NULL
                             pixelsWide:contentSize.width
                             pixelsHigh:contentSize.height
                             bitsPerSample:8
                             samplesPerPixel:4
                             hasAlpha:YES
                             isPlanar:NO
                             colorSpaceName:NSCalibratedRGBColorSpace
                             bytesPerRow:0
                             bitsPerPixel:0];
    
    [image addRepresentation:rep];
    [image lockFocus];
    
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    
    CGContextClearRect(context, NSMakeRect(0, 0, contentSize.width, contentSize.height));
    CGContextSetFillColorWithColor(context, [[NSColor blueColor] CGColor]);
    CGContextFillEllipseInRect(context, NSMakeRect(0, 0, contentSize.width, contentSize.height));
    
    [image unlockFocus];
    
    CGImageRef cgRef = [image CGImageForProposedRect:NULL
                                             context:nil
                                               hints:nil];
    
    NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
    [newRep setSize:contentSize];
    
    NSData *pngData = [newRep representationUsingType:NSPNGFileType properties:nil];
    [pngData writeToURL:url
             atomically:YES];
}

@end

//
//  SUTImageExporter.m
//  Suture
//
//  Created by James Campbell on 17/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTImageExporter.h"
#import "SUTSpriteLayout.h"

@import CoreServices;
@import ImageIO;

CGContextRef SUTCreateImageContext (CGSize size)
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    
    size_t bitsPerComponent = 8;
    size_t bytesPerPixel  = 4;
    size_t bytesPerRow  = (size.width * bytesPerPixel);
    int bitmapByteCount  = (bytesPerRow * size.height);
    
    colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    bitmapData = malloc( bitmapByteCount );
    
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        return NULL;
    }
    context = CGBitmapContextCreate(bitmapData,
                                    size.width,
                                    size.height,
                                    bitsPerComponent,
                                    bytesPerRow,
                                    colorSpace,
                                    (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    if (context== NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
        return NULL;
    }
    
    CGColorSpaceRelease(colorSpace);
    
    return context;
}

@implementation SUTImageExporter

- (NSString *)name
{
    return @"Image Only";
}

- (void)exportDocument:(SUTDocument *)document
                   URL:(NSURL *)url
{
    CGSize contentSize = [document.layout contentSize];
    CGContextRef context = SUTCreateImageContext(contentSize);


    CGContextClearRect(context, NSMakeRect(0, 0, contentSize.width, contentSize.height));
    CGContextSetStrokeColorWithColor(context, [[NSColor redColor] CGColor]);
    
    for (NSInteger spriteIndex = 0 ; spriteIndex < document.sprites.count; spriteIndex ++)
    {
        CGRect spriteFrame = [document.layout frameForSpriteAtIndex:spriteIndex];
        CGContextStrokeRect(context, NSMakeRect(spriteFrame.origin.x,
                                                spriteFrame.origin.y,
                                                contentSize.width,
                                                contentSize.height));
    }
    
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
    CGContextRelease(context);
}

@end

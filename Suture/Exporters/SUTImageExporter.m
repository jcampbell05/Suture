//
//  SUTImageExporter.m
//  Suture
//
//  Created by James Campbell on 17/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTImageExporter.h"

@import CoreServices;

#import "SUTGeometry.h"
#import "SUTSprite.h"
#import "SUTSpriteLayout.h"
#import "NSImage+CGImage.h"

//TODO: Handle Errors in UI.
@interface SUTImageExporter ()

- (CGContextRef)createExportingImageContextWithSize:(CGSize)size;

@end

@implementation SUTImageExporter

//TODO: Break this function down.
- (void)exportDocument:(SUTDocument *)document
                   URL:(NSURL *)url
{
    [super exportDocument:document
                      URL:url];
    
    NSInteger numberOfSprites = document.sprites.count;
    self.progress.completedUnitCount = 0;
    self.progress.totalUnitCount = numberOfSprites + 1;
    
    CGSize contentSize = [document.layout contentSize];
    CGContextRef context = [self createExportingImageContextWithSize:contentSize];

    CGContextClearRect(context, NSMakeRect(0, 0, contentSize.width, contentSize.height));
    CGContextSetStrokeColorWithColor(context, [[NSColor redColor] CGColor]);
    
    for (NSInteger spriteIndex = 0; spriteIndex < numberOfSprites; spriteIndex ++)
    {
        CGRect spriteFrame = [document.layout frameForSpriteAtIndex:spriteIndex];
        spriteFrame = SUTFlipCGRect(spriteFrame, contentSize);
        
        SUTSprite *sprite = document.sprites[spriteIndex];
        CGImageRef image = sprite.image.CGImage;
        
        CGContextDrawImage(context,
                           spriteFrame,
                           image);
        
        CGImageRelease(image);
        
        self.progress.completedUnitCount ++;
    }
    
    [self writeContext:context
                   url:url];
    
    CGContextRelease(context);
    
    self.progress.completedUnitCount ++;
    [self.delegate exporterDidExport:self];
}

- (void)writeJPEG:(CGContextRef)context
              url:(NSURL *)url
{
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)url,
                                                                        kUTTypeJPEG,
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

- (void)writeContext:(CGContextRef)context
                 url:(NSURL *)url
{
    
}

- (CGContextRef)createExportingImageContextWithSize:(CGSize)size
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 size.width,
                                                 size.height,
                                                 8,
                                                 size.width * 4,
                                                 colorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    
    CGColorSpaceRelease(colorSpace);
    
    return context;
}

@end

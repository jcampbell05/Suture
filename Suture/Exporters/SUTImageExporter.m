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

@interface SUTImageExporter ()

@property (nonatomic, strong, readwrite) NSProgress *progress;
@property (nonatomic, strong) NSOperationQueue *exportingQueue;

- (CGContextRef)createExportingImageContextWithSize:(CGSize)size;

@end

@implementation SUTImageExporter

- (NSString *)name
{
    return NSLocalizedString(@"image_exporter_nav", nil);
}

- (NSString *)extension
{
    return @"png";
}

- (NSProgress *)progress
{
    if (!_progress)
    {
        _progress = [[NSProgress alloc] init];
    }
    
    return _progress;
}

//TODO: Break this function down.
- (void)exportDocument:(SUTDocument *)document
                   URL:(NSURL *)url
{
    [self.delegate exporterWillExport:self];
    
    NSInteger numberOfSprites = document.sprites.count;
    self.progress.completedUnitCount = 0;
    self.progress.totalUnitCount = numberOfSprites;
    
    CGSize contentSize = [document.layout contentSize];
    CGContextRef context = [self createExportingImageContextWithSize:contentSize];

    CGContextClearRect(context, NSMakeRect(0, 0, contentSize.width, contentSize.height));
    CGContextSetStrokeColorWithColor(context, [[NSColor redColor] CGColor]);
    
    for (NSInteger spriteIndex = 0 ; spriteIndex < numberOfSprites; spriteIndex ++)
    {
        CGRect spriteFrame = [document.layout frameForSpriteAtIndex:spriteIndex];
        spriteFrame = SUTFlipCGRect(spriteFrame, contentSize);
        
        SUTSprite *sprite = document.sprites[spriteIndex];
        CGImageRef image = sprite.image.CGImage;
        
        CGContextDrawImage(context,
                           spriteFrame,
                           image);
        
        CGImageRelease(image);
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

- (CGContextRef)createExportingImageContextWithSize:(CGSize)size
{
    size_t bitsPerComponent = 8;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 size.width,
                                                 size.height,
                                                 bitsPerComponent,
                                                 0,
                                                 colorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGColorSpaceRelease(colorSpace);
    
    return context;
}

@end

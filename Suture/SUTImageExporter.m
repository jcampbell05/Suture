//
//  SUTImageExporter.m
//  Suture
//
//  Created by James Campbell on 17/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTImageExporter.h"
#import "SUTSprite.h"
#import "SUTSpriteLayout.h"

@import CoreServices;
@import ImageIO;

CGContextRef SUTCreateImageContext (CGSize size)
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

CGImageRef CGImageFromNSImage(NSImage *image)
{
   NSData * imageData = [image TIFFRepresentation];
   CGImageRef imageRef;
    
    if (imageData)
    {
        CGImageSourceRef imageSource = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
        imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
    }
    
    return imageRef;
}

CGRect SUTFlipCGRect(CGRect rect, CGSize size)
{
    rect.origin.y = size.height - CGRectGetMaxY(rect);
    
    return rect;
}

@implementation SUTImageExporter

- (NSString *)name
{
    return NSLocalizedString(@"image_exporter_nav", nil);
}

- (NSString *)extension
{
    return @"png";
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
        spriteFrame = SUTFlipCGRect(spriteFrame, contentSize);
        
        SUTSprite *sprite = document.sprites[spriteIndex];
        
        CGContextDrawImage(context,
                           spriteFrame,
                           CGImageFromNSImage(sprite.image));
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

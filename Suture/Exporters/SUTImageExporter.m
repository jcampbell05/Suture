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

#import "SUTPNGQuant.h"

//TODO: Handle Errors in UI.
@interface SUTImageExporter ()

@end

@implementation SUTImageExporter

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.type = SUTImageExporterPNG8Type;
    }
    
    return self;
}

//TODO: Break this function down.
- (void)exportDocument:(SUTDocument *)document
                   URL:(NSURL *)url
{
    
    
    
    
    if (self.type & SUTImageExporterPNGTypeBit)
    {
        [self writePNG:context
                   url:url];
    }
    else
    {
        [self writeJPEG:context
                    url:url];
    }
    
    CGContextRelease(context);
    
    self.progress.completedUnitCount ++;
    self.progress = nil;
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

- (void)writePNG:(CGContextRef)context
             url:(NSURL *)url
{
    if (self.type == SUTImageExporterPNG8Type)
    {
        png8_image outImage = SUTCreate8BitPNGImageFromContext(context);
        
        FILE *outfile = fopen([url.path UTF8String], "wb");
        rwpng_write_image8(outfile, &outImage);
        fclose(outfile);
    }
    else
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

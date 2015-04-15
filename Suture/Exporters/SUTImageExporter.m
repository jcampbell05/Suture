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

@property (nonatomic, strong, readwrite) NSProgress *progress;

- (CGContextRef)createExportingImageContextWithSize:(CGSize)size;

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

#pragma mark - Exporter Info

- (NSString *)name
{
    switch (self.type)
    {
        case SUTImageExporterPNG8Type:
            return NSLocalizedString(@"png_8_image_exporter_nav",
                                     nil);
            break;
            
        case SUTImageExporterPNG32Type:
            return NSLocalizedString(@"png_32_image_exporter_nav",
                                     nil);
            break;
            
        case SUTImageExporterJPEGType:
            return NSLocalizedString(@"jpeg_image_exporter_nav",
                                     nil);
            break;
    }
}

- (NSString *)extension
{
    NSString *extension = nil;
    
    if (self.type & SUTImageExporterPNGTypeBit)
    {
        extension = @"png";
    }
    else
    {
        extension = @"jpg";
    }
    
    return extension;
}

#pragma mark - Progress

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
    png24_image inImage = SUTCreate24BitPNGImageFromContext(context);
    png8_image outImage = SUTCreate8BitPNGImageFrom24BitPNGImage(inImage);
    
    
    FILE *outfile = fopen([url.path UTF8String], "wb");
    
    rwpng_write_image8(outfile, &outImage);
    
    fclose(outfile);
}

- (CGContextRef)createExportingImageContextWithSize:(CGSize)size
{
    size_t bitsPerComponent = (self.type == SUTImageExporterPNG8Type) ? 2 : 8;
    
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

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

#import "libimagequant.h"
#import "rwpng.h"

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
    self.progress.totalUnitCount = numberOfSprites + 1 + 1;
    
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
    
    CGImageRef image = CGBitmapContextCreateImage(context);
    CFStringRef exportType;
    
    if (self.type & SUTImageExporterPNGTypeBit)
    {
        exportType = kUTTypePNG;
    }
    else
    {
        exportType = kUTTypeJPEG;
    }
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)url,
                                                                        exportType,
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
    
    self.progress.completedUnitCount ++;
    
    CGImageRelease(image);
    CGContextRelease(context);
    
    if (self.type & SUTImageExporterPNGTypeBit)
    {
        const char *filepath = [url.path UTF8String];
        
        FILE *inFile = fopen(filepath,
                             "rb");
        
        if (inFile == NULL)
        {
            NSLog(@"Error writing to \"%s\", %s", filepath, strerror(errno));
        }
        else
        {
            //TODO: Handle Errors Via UI.
            png24_image input_image = {};
            
            rwpng_read_image24(inFile,
                               &input_image,
                               true);
            
            fclose(inFile);
            
            FILE *outFile = fopen(filepath,
                                 "w");
            
            png8_image output_image = {};
            
            rwpng_write_image8(outFile,
                               &output_image);
            
            fclose(outFile);
        }
    }
    
    self.progress.completedUnitCount ++;
    self.progress = nil;
    [self.delegate exporterDidExport:self];
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

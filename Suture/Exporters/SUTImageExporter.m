//
//  SUTImageExporter.m
//  Suture
//
//  Created by James Campbell on 17/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTImageExporter.h"

@import CoreServices;

#import "SUTSprite.h"
#import "SUTSpritesheetLayout.h"
#import "SUTImageExporterOptionsView.h"
#import "SUTSpriteRenderer.h"
#import "SUTSpecificationExporter.h"

NSString const * SUTImageExporterShouldExportSpecificationOptionKey = @"ShouldExportSpecification";

//TODO: Handle Errors in UI.
@interface SUTImageExporter ()

- (CGContextRef)createImageContextWithSize:(CGSize)size;
- (void)exportSpecificationIfNeededWithExportDocument:(SUTDocument *)document
                                                  URL:(NSURL *)url
                                              options:(NSDictionary *)options;

@end

@implementation SUTImageExporter

- (SUTImageExporterOptionsView *)optionsView
{
    SUTImageExporterOptionsView *optionsView = [[SUTImageExporterOptionsView alloc] init];
    return optionsView;
}

- (void)exportDocument:(SUTDocument *)document
                   URL:(NSURL *)url
               options:(NSDictionary *)options
{
    [super exportDocument:document
                      URL:url
                  options:options];

    NSInteger numberOfSprites = document.sprites.count;
    
    self.progress.completedUnitCount = 0;
    self.progress.totalUnitCount = numberOfSprites + 2;
    [self.progress becomeCurrentWithPendingUnitCount:self.progress.totalUnitCount];
    
    /**
     Was the export specification option selected ?
     */
    if ([options[SUTImageExporterShouldExportSpecificationOptionKey] boolValue])
    {
        [self exportSpecificationIfNeededWithExportDocument:document
                                                        URL:url
                                                    options:options];
    }
    
    CGSize contentSize = [document.layout contentSize];
    CGContextRef context = [self createImageContextWithSize:contentSize];

    CGContextClearRect(context, NSMakeRect(0, 0, contentSize.width, contentSize.height));
    
    
    SUTSpriteRenderer *renderer = [[SUTSpriteRenderer alloc] init];
    
    [document.sprites enumerateObjectsWithOptions:NSEnumerationConcurrent
                                       usingBlock:^(SUTSprite *sprite, NSUInteger idx, BOOL *stop)
     {
         CGRect spriteFrame = [document.layout frameForSpriteAtIndex:idx];
         CGContextRef spriteContext = [self createImageContextWithSize:sprite.size];
         
         [renderer renderSprite:sprite
                        context:spriteContext];
         
         CGImageRef spriteImage = CGBitmapContextCreateImage(spriteContext);
         CGContextDrawImage(context,
                            spriteFrame,
                            spriteImage);
         
         CGContextRelease(spriteContext);
         
         self.progress.completedUnitCount++;
     }];
    
    [self writeContext:context
                   url:url];
    
    CGContextRelease(context);
    
    self.progress.completedUnitCount++;
    [self.delegate exporterDidExport:self];
}

- (void)exportSpecificationIfNeededWithExportDocument:(SUTDocument *)document
                                                  URL:(NSURL *)url
                                              options:(NSDictionary *)options
{
    SUTSpecificationExporter *specificationExporter = [[SUTSpecificationExporter alloc] init];
    specificationExporter.progress = [[NSProgress alloc] initWithParent:self.progress
                                                               userInfo:nil];
    
    NSURL *specificationURL = [url URLByAppendingPathExtension:@"txt"];
    
    [specificationExporter exportDocument:document
                                      URL:specificationURL
                                  options:options];
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

- (CGContextRef)createImageContextWithSize:(CGSize)size
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

//
//  SUTJPEGExporter.m
//  Suture
//
//  Created by James Campbell on 26/05/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTJPEGExporter.h"

@interface SUTJPEGExporter ()

@property (nonatomic, strong, readwrite) NSProgress *progress;

- (CGContextRef)createExportingImageContextWithSize:(CGSize)size;

@end

@implementation SUTJPEGExporter

- (NSString *)name
{
    return NSLocalizedString(@"jpeg_image_exporter_nav",
                             nil);
}

- (NSString *)extension
{
    return @"jpeg";
}

@end

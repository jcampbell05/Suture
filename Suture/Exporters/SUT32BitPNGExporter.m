//
//  SUT32BitPNGExporter.m
//  Suture
//
//  Created by James Campbell on 26/05/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUT32BitPNGExporter.h"

@interface SUT32BitPNGExporter ()

@property (nonatomic, strong, readwrite) NSProgress *progress;

- (CGContextRef)createExportingImageContextWithSize:(CGSize)size;

@end

@implementation SUT32BitPNGExporter

- (NSString *)name
{
    return NSLocalizedString(@"png_32_image_exporter_nav",
                             nil);
}

- (NSString *)extension
{
    return @"png";
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

@end

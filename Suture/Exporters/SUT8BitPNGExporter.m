//
//  SUT8BitPNGExporter.m
//  Suture
//
//  Created by James Campbell on 26/05/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUT8BitPNGExporter.h"

@interface SUT8BitPNGExporter ()

@property (nonatomic, strong, readwrite) NSProgress *progress;

@end

@implementation SUT8BitPNGExporter

- (NSString *)name
{
    return NSLocalizedString(@"png_8_image_exporter_nav",
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

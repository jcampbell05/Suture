//
//  SUTExporter.m
//  Suture
//
//  Created by James Campbell on 26/05/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTExporter.h"

@interface SUTExporter ()

@property (nonatomic, strong, readwrite) NSProgress *progress;

- (CGContextRef)createExportingImageContextWithSize:(CGSize)size;

@end

@implementation SUTExporter

#pragma mark - Name and Extension

- (NSString *)name
{
    return nil;
}

- (NSString *)extension
{
    return nil;
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

#pragma mark - Export

- (void)exportDocument:(SUTDocument *)document
                   URL:(NSURL *)url
               options:(NSDictionary *)options
{
    self.progress = nil;
    [self.delegate exporterWillExport:self];
}

@end

//
//  SUTJPEGExporter.m
//  Suture
//
//  Created by James Campbell on 26/05/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTJPEGExporter.h"

@implementation SUTJPEGExporter

- (NSString *)name
{
    return NSLocalizedString(@"specification_exporter_nav",
                             nil);
}

- (NSString *)extension
{
    return @"jpeg";
}

@end

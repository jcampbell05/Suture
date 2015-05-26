//
//  SUTExporterRegistry.h
//  Suture
//
//  Created by James Campbell on 17/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTExporter.h"

@interface SUTExporterRegistry : NSObject

@property (nonatomic, strong, readonly) NSArray *exporters;

+ (instancetype)sharedRegistry;
- (void)registerExporter:(SUTExporter *)exporter;

@end

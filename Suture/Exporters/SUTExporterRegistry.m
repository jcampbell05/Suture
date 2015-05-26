//
//  SUTExporterRegistry.m
//  Suture
//
//  Created by James Campbell on 17/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTExporterRegistry.h"

@interface SUTExporterRegistry ()

@property (nonatomic, strong) NSMutableArray *mutableExporters;

@end

@implementation SUTExporterRegistry

#pragma mark - Singleton

static SUTExporterRegistry *sharedRegistry = nil;

+ (instancetype)sharedRegistry
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        sharedRegistry = [[SUTExporterRegistry alloc] init];
    });
    
    return sharedRegistry;
}

#pragma mark - Exporters

- (NSArray *)exporters
{
    return [self.mutableExporters copy];
}

- (NSMutableArray *)mutableExporters
{
    if (!_mutableExporters)
    {
        _mutableExporters = [[NSMutableArray alloc] init];
    }
    
    return _mutableExporters;
}

#pragma mark - Register

- (void)registerExporter:(SUTExporter *)exporter
{
    [self.mutableExporters addObject:exporter];
}

@end

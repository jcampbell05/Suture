//
//  SUTImageExporter.h
//  Suture
//
//  Created by James Campbell on 17/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTExporter.h"

typedef NS_ENUM(NSUInteger, SUTImageExporterType) {
    SUTImageExporterPNGType,
    SUTImageExporterJPEGType
};

@interface SUTImageExporter : NSObject <SUTExporter>

@property (nonatomic, weak) id<SUTExporterDelegate> delegate;
@property (nonatomic, assign) SUTImageExporterType type;

@end

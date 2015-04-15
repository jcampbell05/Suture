//
//  SUTImageExporter.h
//  Suture
//
//  Created by James Campbell on 17/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTExporter.h"

#define SUTImageExporterPNGTypeBit 10
#define SUTImageExporterJPEGTypeBit 20

typedef NS_ENUM(NSUInteger, SUTImageExporterType)
{
    SUTImageExporterPNG8Type = 0 | SUTImageExporterPNGTypeBit,
    SUTImageExporterPNG32Type = 1 | SUTImageExporterPNGTypeBit,
    SUTImageExporterJPEGType = 2 | SUTImageExporterJPEGTypeBit
};

@interface SUTImageExporter : NSObject <SUTExporter>

@property (nonatomic, weak) id<SUTExporterDelegate> delegate;
@property (nonatomic, assign) SUTImageExporterType type;

@end

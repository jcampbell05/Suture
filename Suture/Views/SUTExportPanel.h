//
//  SUTExportPanel.h
//  Suture
//
//  Created by James Campbell on 17/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

@import Cocoa;
#import "SUTDocument.h"
#import "SUTExporter.h"

@interface SUTExportPanel : NSSavePanel

@property (nonatomic, readonly) SUTExporter *selectedExporter;

@end

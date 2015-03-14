//
//  SUTExportAccessoryView.h
//  Suture
//
//  Created by James Campbell on 14/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

@import Cocoa;

@interface SUTExportAccessoryView : NSView

@property (nonatomic, strong, readonly) NSSavePanel *savePanel;

- (instancetype)initWithSavePanel:(NSSavePanel *)savePanel;

@end

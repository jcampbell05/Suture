//
//  SUTExportAccessoryView.m
//  Suture
//
//  Created by James Campbell on 14/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTExportAccessoryView.h"

@interface SUTExportAccessoryView ()

@property (nonatomic, strong, readwrite) NSSavePanel *savePanel;

@end

@implementation SUTExportAccessoryView

- (instancetype)initWithSavePanel:(NSSavePanel *)savePanel
{
    self = [super init];
    
    if (self)
    {
        self.frame = NSMakeRect(0.0f,
                                0.0f,
                                400.0f,
                                100.0f);
        
        self.savePanel = savePanel;
        self.savePanel.accessoryView = self;
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    self.wantsLayer = YES;
    self.layer.backgroundColor = [NSColor redColor].CGColor;
}

@end

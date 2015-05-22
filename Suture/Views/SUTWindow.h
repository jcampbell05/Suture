//
//  SUTWindow.h
//  Suture
//
//  Created by James Campbell on 27/4/15.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

@import Cocoa;
#import "SUTEditorView.h"
#import "SUTPropertyView.h"
#import "SUTOutlineView.h"

@interface SUTWindow : NSWindow

@property (nonatomic, strong, readonly) SUTOutlineView *dropHighlightView;
@property (nonatomic, strong, readonly) SUTEditorView *editorView;
@property (nonatomic, strong, readonly) SUTPropertyView *propertyView;
@property (atomic, strong) NSView *contentView;

+ (instancetype)window;

@end

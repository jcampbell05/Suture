//
//  SUTEditorView.h
//  Suture
//
//  Created by James Campbell on 10/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

@import Cocoa;
@class SUTDocument;

@interface SUTEditorView : NSView

@property (nonatomic, weak) SUTDocument *document;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, strong, readonly) NSScrollView *scrollView;

- (void)addSpritesForURLS:(NSArray *)urls;
- (void)removeSelectedSprite;

@end

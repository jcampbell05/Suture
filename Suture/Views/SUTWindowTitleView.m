//
//  SUTWindowTitleView.m
//  Suture
//
//  Created by James Campbell on 29/4/15.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTWindowTitleView.h"

@interface SUTWindowTitleView ()

@property (nonatomic, strong) NSTextField *titleTextField;

@end

@implementation SUTWindowTitleView

#pragma mark - View Life Cycle

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    
    if (self)
    {
        self.wantsLayer = YES;
        
        [self addSubview:self.titleTextField];
    }
    
    return self;
}


- (void)viewDidMoveToWindow
{
//    NSButton *documentIconButton = [NSWindow standardWindowButton:NSWindowDocumentIconButton
//                                                     forStyleMask:self.window.styleMask];
//    NSButton *documentVersionsButton = [NSWindow standardWindowButton:NSWindowDocumentVersionsButton
//                                                         forStyleMask:self.window.styleMask];
//    
//    [self addSubview:documentIconButton];
//    [self addSubview:documentVersionsButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowResized:) name:NSWindowDidResizeNotification object:[self window]];
    [self.titleTextField bind:NSStringFromSelector(@selector(stringValue))
                     toObject:self.window
                  withKeyPath:NSStringFromSelector(@selector(title))
                      options:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)windowResized:(NSNotification *)notification;
{
    [self.titleTextField sizeToFit];
    self.titleTextField.frame = CGRectMake(0.0f,
                                           7.0f,
                                           self.titleTextField.frame.size.width,
                                           20.0f);
}
#pragma mark - Views

- (NSTextField *)titleTextField
{
    if (!_titleTextField)
    {
        _titleTextField = [[NSTextField alloc] initWithFrame:self.bounds];
        
        _titleTextField.alignment = NSCenterTextAlignment;
        _titleTextField.bezeled = NO;
        _titleTextField.drawsBackground = NO;
        _titleTextField.editable = NO;
        _titleTextField.selectable = NO;
    }
    
    return  _titleTextField;
}

@end

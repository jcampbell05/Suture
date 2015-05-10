//
//  SUTWindowTitleView.m
//  Suture
//
//  Created by James Campbell on 29/4/15.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTWindowTitleView.h"

static NSInteger const SUTWindowTitleControlsWidth = 50.0f;

@interface SUTWindowTitleView ()

@property (nonatomic, strong) NSTextField *titleTextField;

- (void)updateTitleView;

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


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self updateTitleView];
}

- (void)viewWillMoveToWindow:(NSWindow *)newWindow
{
    NSButton *documentIconButton = [NSWindow standardWindowButton:NSWindowDocumentIconButton
                                                     forStyleMask:self.window.styleMask];
    NSButton *documentVersionsButton = [NSWindow standardWindowButton:NSWindowDocumentVersionsButton
                                                         forStyleMask:self.window.styleMask];
    
    [self addSubview:documentIconButton];
    [self addSubview:documentVersionsButton];
    
    [self.window removeObserver:self
                     forKeyPath:NSStringFromSelector(@selector(title))];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowResized:) name:NSWindowDidResizeNotification object:[self window]];

    [newWindow addObserver:self
                forKeyPath:NSStringFromSelector(@selector(title))
                   options:0
                   context:NULL];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)windowResized:(NSNotification *)notification;
{
    [self updateTitleView];
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
        
        [self updateTitleView];
    }
    
    return  _titleTextField;
}

- (void)updateTitleView
{
    if (self.window.title)
    {
        self.titleTextField.stringValue = self.window.title;
    }
    
    [self.titleTextField sizeToFit];
    
    self.titleTextField.frame = CGRectMake(((self.window.frame.size.width / 2) - (self.titleTextField.frame.size.width / 2)) - SUTWindowTitleControlsWidth,
                                           7.0f,
                                           self.titleTextField.frame.size.width,
                                           20.0f);
}

@end

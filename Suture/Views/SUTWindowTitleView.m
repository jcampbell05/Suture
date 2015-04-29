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
    }
    
    return self;
}

- (void)viewDidMoveToWindow
{
    NSButton *documentIconButton = [NSWindow standardWindowButton:NSWindowDocumentIconButton
                                                     forStyleMask:self.window.styleMask];
    NSButton *documentVersionsButton = [NSWindow standardWindowButton:NSWindowDocumentVersionsButton
                                                         forStyleMask:self.window.styleMask];
    
    [self addSubview:documentIconButton];
    [self addSubview:documentVersionsButton];
    [self addSubview:self.titleTextField];
    
    NSLayoutConstraint *centerXTitleTextFieldConstraint = [NSLayoutConstraint constraintWithItem:self.titleTextField
                                                                                       attribute:NSLayoutAttributeCenterX
                                                                                       relatedBy:NSLayoutRelationEqual
                                                                                          toItem:self
                                                                                       attribute:NSLayoutAttributeCenterX
                                                                                      multiplier:0.5f
                                                                                        constant:0.0f];
    [self addConstraint:centerXTitleTextFieldConstraint];
    
    NSLayoutConstraint *centerYTitleTextFieldConstraint = [NSLayoutConstraint constraintWithItem:self.titleTextField
                                                                                       attribute:NSLayoutAttributeCenterY
                                                                                       relatedBy:NSLayoutRelationEqual
                                                                                          toItem:self
                                                                                       attribute:NSLayoutAttributeCenterY
                                                                                      multiplier:0.5f
                                                                                        constant:0.0f];
    [self addConstraint:centerYTitleTextFieldConstraint];
    
    NSLayoutConstraint *hieghtTitleTextFieldConstraint = [NSLayoutConstraint constraintWithItem:self.titleTextField
                                                                                       attribute:NSLayoutAttributeHeight
                                                                                       relatedBy:NSLayoutRelationEqual
                                                                                          toItem:nil
                                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                                      multiplier:0.0f
                                                                                        constant:10.0f];
    [self addConstraint:hieghtTitleTextFieldConstraint];
    
    NSLayoutConstraint *wTitleTextFieldConstraint = [NSLayoutConstraint constraintWithItem:self.titleTextField
                                                                                      attribute:NSLayoutAttributeWidth
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:nil
                                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                                     multiplier:0.0f
                                                                                       constant:10.0f];
    [self addConstraint:wTitleTextFieldConstraint];
}

#pragma mark - Views

- (NSTextField *)titleTextField
{
    if (!_titleTextField)
    {
        _titleTextField = [[NSTextField alloc] init];
        _titleTextField.translatesAutoresizingMaskIntoConstraints = NO;
        
        _titleTextField.alignment = NSCenterTextAlignment;
        _titleTextField.bezeled = NO;
        _titleTextField.drawsBackground = NO;
        _titleTextField.editable = NO;
        _titleTextField.selectable = NO;
        _titleTextField.stringValue = @"A Document Title";
        
        [_titleTextField sizeToFit];
    }
    
    return  _titleTextField;
}

@end

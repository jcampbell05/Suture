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
    
}

#pragma mark - Views

- (NSTextField *)titleTextField
{
    if (!_titleTextField)
    {
        _titleTextField = [[NSTextField alloc] init];
        
        _titleTextField.alignment = NSCenterTextAlignment;
        _titleTextField.bezeled = NO;
        _titleTextField.drawsBackground = NO;
        _titleTextField.editable = NO;
        _titleTextField.selectable = NO;
        
        [_titleTextField sizeToFit];
    }
    
    return  _titleTextField;
}

@end

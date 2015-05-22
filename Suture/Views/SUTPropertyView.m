//
//  SUTPropertyView.m
//  Suture
//
//  Created by James Campbell on 22/05/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTPropertyView.h"

@interface SUTPropertyView ()

@property (nonatomic, strong) NSTextField *specificationsTitleView;

@end

@implementation SUTPropertyView

#pragma mark - Init

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:(NSRect)frameRect];
    
    if (self)
    {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor colorWithRed:55.0f/255.0f
                                                     green:58.0f/255.0f
                                                      blue:71.0f/255.0f
                                                     alpha:1.0f].CGColor;
        
        [self addSubview:self.specificationsTitleView];
    }
    
    return self;
}

#pragma mark - Specifications

- (NSTextField *)specificationsTitleView
{
    if (!_specificationsTitleView)
    {
        _specificationsTitleView = [[NSTextField alloc] init];
        
        _specificationsTitleView.alignment = NSCenterTextAlignment;
        _specificationsTitleView.bezeled = NO;
        _specificationsTitleView.textColor = [NSColor whiteColor];
        _specificationsTitleView.drawsBackground = NO;
        _specificationsTitleView.editable = NO;
        _specificationsTitleView.selectable = NO;
        
        _specificationsTitleView.stringValue = NSLocalizedString(@"specifications_nav",
                                                         nil);
        
        [_specificationsTitleView sizeToFit];
        
        CGRect frame = _specificationsTitleView.frame;
        frame.size.width = self.bounds.size.width;
        _specificationsTitleView.frame = frame;
    }
    
    return _specificationsTitleView;
}

@end

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
        self.orientation = NSUserInterfaceLayoutOrientationVertical;
        self.edgeInsets = NSEdgeInsetsMake(10.0f,
                                           10.0f,
                                           10.0f,
                                           10.0f);
        
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor colorWithRed:55.0f/255.0f
                                                     green:58.0f/255.0f
                                                      blue:71.0f/255.0f
                                                     alpha:1.0f].CGColor;
        
        [self addView:self.specificationsTitleView
            inGravity:NSStackViewGravityTop];
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
    }
    
    return _specificationsTitleView;
}

@end

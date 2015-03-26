//
//  SUTProgressPanel.m
//  Suture
//
//  Created by James Campbell on 26/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTProgressPanel.h"

static CGFloat const SUTProgressIndicatorHeight = 40.0f;
static CGFloat const SUTProgressIndicatorMargin = 20.0f;

@interface SUTProgressPanel ()

@property (nonatomic, strong) NSProgressIndicator *progressIndicator;

@end

@implementation SUTProgressPanel

#pragma mark - Init

- (instancetype)initWithContentRect:(NSRect)contentRect
                          styleMask:(NSUInteger)aStyle
                            backing:(NSBackingStoreType)bufferingType
                              defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect
                            styleMask:aStyle
                              backing:bufferingType
                                defer:flag];
    
    if (self)
    {
        [self.contentView addSubview:self.progressIndicator];
    }
    
    return self;
}

#pragma mark - ProgressIndicator

- (NSProgressIndicator *)progressIndicator
{
    if (!_progressIndicator)
    {
        CGFloat width = [self.contentView bounds].size.width - (SUTProgressIndicatorMargin * 2);
        _progressIndicator = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(SUTProgressIndicatorMargin,
                                                                                   ([self.contentView bounds].size.width / 2) - (width / 2),
                                                                                   width,
                                                                                   SUTProgressIndicatorHeight)];
    }
    
    return _progressIndicator;
}

@end

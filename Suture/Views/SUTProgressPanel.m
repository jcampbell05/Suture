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

- (void)updateProgress;

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

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([object isEqual:self.progress])
    {
        [self updateProgress];
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Progress

- (void)setProgress:(NSProgress *)progress
{
    if (![_progress isEqual:progress])
    {
        if (_progress)
        {
            [_progress removeObserver:self
                           forKeyPath:NSStringFromSelector(@selector(totalUnitCount))];
            [_progress removeObserver:self
                           forKeyPath:NSStringFromSelector(@selector(completedUnitCount))];
        }
        
        [self willChangeValueForKey:NSStringFromSelector(@selector(progress))];
        _progress = progress;
        [self didChangeValueForKey:NSStringFromSelector(@selector(progress))];
        
        [self updateProgress];
        
        if (progress)
        {
            [progress addObserver:self
                       forKeyPath:NSStringFromSelector(@selector(totalUnitCount))
                          options:NSKeyValueObservingOptionNew
                          context:NULL];
            [progress addObserver:self
                       forKeyPath:NSStringFromSelector(@selector(completedUnitCount))
                          options:NSKeyValueObservingOptionNew
                          context:NULL];
        }
    }
}

- (void)updateProgress
{
    dispatch_sync(dispatch_get_main_queue(), ^
    {
        if (self.progressIndicator.maxValue != self.progress.totalUnitCount)
        {
            self.progressIndicator.maxValue = self.progress.totalUnitCount;
        }
        
        self.progressIndicator.doubleValue = self.progress.completedUnitCount;
        
        NSLog(@"Progress: %f", self.progressIndicator.doubleValue);
    });
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
        _progressIndicator.indeterminate = NO;
        _progressIndicator.controlTint = NSBlueControlTint;
    }
    
    return _progressIndicator;
}

@end

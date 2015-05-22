//
//  SUTPropertyView.m
//  Suture
//
//  Created by James Campbell on 22/05/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTPropertyView.h"

#import "SUTDocument.h"

@interface SUTPropertyView ()

@property (nonatomic, strong) NSTextField *specificationsTitleView;
@property (nonatomic, strong) NSTextField *framesTitleView;
@property (nonatomic, strong) NSTextField *frameSizeTitleView;

- (void)updateFrameSpecificationText;

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
        
        [self addSubview:self.specificationsTitleView];
        [self addSubview:self.framesTitleView];
        [self addSubview:self.frameSizeTitleView];
        
        [self setViews:@[self.specificationsTitleView,
                         self.framesTitleView,
                         self.frameSizeTitleView]
              inGravity:NSStackViewGravityTop];
    }
    
    return self;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    [self updateFrameSpecificationText];
}

#pragma mark - Document

- (void)setDocument:(SUTDocument *)document
{
    if (![_document isEqualTo:document])
    {
        if (_document)
        {
            [_document removeObserver:self
                           forKeyPath:NSStringFromSelector(@selector(sprites))];
        }
        
        [self willChangeValueForKey:NSStringFromSelector(@selector(document))];
        _document = document;
        [self didChangeValueForKey:NSStringFromSelector(@selector(document))];
        
        if (_document)
        {
            [_document addObserver:self
                        forKeyPath:NSStringFromSelector(@selector(sprites))
                           options:0
                           context:NULL];
        }
        
        [self updateFrameSpecificationText];
    }
}

#pragma mark - Specifications

- (NSTextField *)specificationsTitleView
{
    if (!_specificationsTitleView)
    {
        CGRect adjustedBounds = NSInsetRect(self.bounds, self.edgeInsets.left + self.edgeInsets.right, 0.0f);
        _specificationsTitleView = [[NSTextField alloc] initWithFrame:NSMakeRect(0.0f,
                                                                                 0.0f,
                                                                                 CGRectGetWidth(adjustedBounds),
                                                                                 75.0f)];
        
        _specificationsTitleView.alignment = NSCenterTextAlignment;
        _specificationsTitleView.bezeled = NO;
        _specificationsTitleView.textColor = [NSColor whiteColor];
        _specificationsTitleView.drawsBackground = NO;
        _specificationsTitleView.editable = NO;
        _specificationsTitleView.selectable = NO;
        
        _specificationsTitleView.stringValue = NSLocalizedString(@"specifications_nav",
                                                         nil);
    }
    
    return _specificationsTitleView;
}

- (NSTextField *)framesTitleView
{
    if (!_framesTitleView)
    {
        CGRect adjustedBounds = NSInsetRect(self.bounds, self.edgeInsets.left + self.edgeInsets.right, 0.0f);
        _framesTitleView = [[NSTextField alloc] initWithFrame:NSMakeRect(0.0f,
                                                                         0.0f,
                                                                         CGRectGetWidth(adjustedBounds),
                                                                         75.0f)];
        
        _framesTitleView.alignment = NSCenterTextAlignment;
        _framesTitleView.bezeled = NO;
        _framesTitleView.textColor = [NSColor whiteColor];
        _framesTitleView.drawsBackground = NO;
        _framesTitleView.editable = NO;
        _framesTitleView.selectable = NO;
    }
    
    return _framesTitleView;
}

- (NSTextField *)frameSizeTitleView
{
    if (!_frameSizeTitleView)
    {
        CGRect adjustedBounds = NSInsetRect(self.bounds, self.edgeInsets.left + self.edgeInsets.right, 0.0f);
        _frameSizeTitleView = [[NSTextField alloc] initWithFrame:NSMakeRect(0.0f,
                                                                            0.0f,
                                                                            CGRectGetWidth(adjustedBounds),
                                                                            75.0f)];
        
        _frameSizeTitleView.alignment = NSCenterTextAlignment;
        _frameSizeTitleView.bezeled = NO;
        _frameSizeTitleView.textColor = [NSColor whiteColor];
        _frameSizeTitleView.drawsBackground = NO;
        _frameSizeTitleView.editable = NO;
        _frameSizeTitleView.selectable = NO;
    }
    
    return _frameSizeTitleView;
}

- (void)updateFrameSpecificationText
{
    self.framesTitleView.stringValue = [NSString stringWithFormat:@"Frames: %lu", [self.document.sprites count]];
    self.frameSizeTitleView.stringValue = [NSString stringWithFormat:@"Frame Size: %@", NSStringFromSize([self.document largestSpriteSize])];
}

@end

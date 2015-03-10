//
//  SUTEditorView.m
//  Suture
//
//  Created by James Campbell on 10/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTEditorView.h"

#import "SUTEmptySpriteView.h"

@interface SUTEditorView ()

@property (nonatomic, strong) SUTEmptySpriteView *emptySpriteView;

@end

@implementation SUTEditorView

#pragma mark - Init

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self)
    {
        [self addSubview:self.emptySpriteView];
    }
    
    return self;
}

#pragma mark - emptySpriteView

- (SUTEmptySpriteView *)emptySpriteView
{
    if (!_emptySpriteView)
    {
        _emptySpriteView = [[SUTEmptySpriteView alloc] initWithFrame:self.bounds];
    }
    
    return _emptySpriteView;
}

@end

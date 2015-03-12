//
//  Document.m
//  Suture
//
//  Created by James Campbell on 10/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "Document.h"

@interface Document ()

@property (nonatomic, strong) NSFileWrapper *fileWrapper;

@end

@implementation Document

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        // Add your subclass-specific initialization here.
    }
    
    return self;
}

#pragma mark - Sprites

- (NSMutableArray *)sprites
{
    if (!_sprites)
    {
        _sprites = [[NSMutableArray alloc] init];
    }
    
    return _sprites;
}

- (NSFileWrapper *)fileWrapper
{
    if (!_fileWrapper)
    {
        _fileWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:nil];
    }
    
    return _fileWrapper;
}

#pragma mark - DocumentLifecycle

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

#pragma mark - Read/Write

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    [NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    [NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
    return YES;
}

#pragma mark - Menu Item

- (IBAction)addImage:(NSMenuItem *)menuItem
{
    
}

@end

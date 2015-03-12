//
//  Document.m
//  Suture
//
//  Created by James Campbell on 10/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "Document.h"
#import "SUTSprite.h"

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

#pragma mark - FileWrapper

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

- (NSFileWrapper *)fileWrapperOfType:(NSString *)typeName error:(NSError **)outError
{
    // this holds the files to be added
    NSMutableDictionary *files = [NSMutableDictionary dictionary];
    
    // encode the index
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.sprites];
    NSFileWrapper *indexWrapper = [[NSFileWrapper alloc] initRegularFileWithContents:data];
    
    // add it to the files
    [files setObject:indexWrapper forKey:@"index.plist"];
    
    // copy all other referenced files too
//    for (SUTSprite *sprite in self.sprites)
//    {
//        NSString *fileName = oneItem.fileName;
//        NSFileWrapper *existingFile = [_fileWrapper.fileWrappers objectForKey:fileName];
//        [files setObject:existingFile forKey:fileName];
//    }
    
    // create a new fileWrapper for the bundle
    NSFileWrapper *newWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:files];
    
    return newWrapper;
}

- (BOOL)readFromFileWrapper:(NSFileWrapper *)fileWrapper ofType:(NSString *)typeName error:(NSError **)outError
{
    if (![fileWrapper isDirectory])
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Illegal Document Format" forKey:NSLocalizedDescriptionKey];
        *outError = [NSError errorWithDomain:@"Shoebox" code:1 userInfo:userInfo];
        return NO;
    }
    
    // store reference for later image access
    self.fileWrapper = fileWrapper;
    
    // decode the index
    NSFileWrapper *indexWrapper = [fileWrapper.fileWrappers objectForKey:@"index.plist"];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:indexWrapper.regularFileContents];
    
    // set document property for all items
    [array makeObjectsPerformSelector:@selector(setDocument:) withObject:self];
    
    // set the property
    self.sprites = [array mutableCopy];
    
    // YES because of successful reading
    return YES;
}

#pragma mark - Menu Item

- (IBAction)addImage:(NSMenuItem *)menuItem
{
    
}

@end

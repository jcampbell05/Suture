//
//  Document.m
//  Suture
//
//  Created by James Campbell on 10/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "Document.h"

#import "SUTSprite.h"
#import "SUTWindowController.h"

@interface Document ()

@property (nonatomic, strong) NSFileWrapper *fileWrapper;

@end

@implementation Document

@synthesize sprites = _sprites;

#pragma mark - FileWrapper

- (NSFileWrapper *)fileWrapper
{
    if (!_fileWrapper)
    {
        _fileWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:nil];
    }
    
    return _fileWrapper;
}

- (NSArray *)sprites
{
    if (!_sprites)
    {
        _sprites = [[NSArray alloc] init];
    }
    
    return _sprites;
}

#pragma mark - DocumentLifecycle

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (void)makeWindowControllers
{
    SUTWindowController *windowController = [[SUTWindowController alloc] init];
    [self addWindowController:windowController];
    [windowController window];
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
    _sprites = [array mutableCopy];
    
    // YES because of successful reading
    return YES;
}

#pragma mark - Image

- (NSImage *)imageForURL:(NSURL *)url
{
    NSFileWrapper *imageFileWrapper = [self.fileWrapper.fileWrappers objectForKey:[url absoluteString]];
    return [[NSImage alloc] initWithData:imageFileWrapper.regularFileContents];
}

#pragma mark - Sprites

- (void)addSprite:(SUTSprite *)sprite
{
    [self insertObject:sprite
      inSpritesAtIndex:_sprites.count];
}

- (void)insertObject:(SUTSprite *)sprite
    inSpritesAtIndex:(NSUInteger)index
{
    sprite.document = self;
    
    NSFileWrapper *fileWrapper = [[NSFileWrapper alloc] initWithURL:sprite.fileURL
                                                            options:0
                                                              error:NULL];
    fileWrapper.preferredFilename = [sprite.fileURL absoluteString];
    [self.fileWrapper addFileWrapper:fileWrapper];
    
    NSMutableArray *newSprites = [self.sprites mutableCopy];
    newSprites[index] = sprite;
    _sprites = newSprites;
}

- (void)removeObjectFromSpritesAtIndex:(NSUInteger)index
{
    NSMutableArray *newSprites = [self.sprites mutableCopy];
    [newSprites removeObjectAtIndex:index];
    _sprites = newSprites;
}

@end

//
//  SUTDocument.m
//  Suture
//
//  Created by James Campbell on 10/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTDocument.h"

#import "SUTSprite.h"
#import "SUTSpriteLayout.h"
#import "SUTWindowController.h"

#import <os/activity.h>

@interface SUTDocument () <SUTSpriteLayoutDelegate>

@property (nonatomic, strong) NSFileWrapper *fileWrapper;

- (NSString *)sanatizeFilePath:(NSString *)path;

@end

@implementation SUTDocument

@synthesize sprites = _sprites;

#pragma mark - Data

- (NSFileWrapper *)fileWrapper
{
    if (!_fileWrapper)
    {
        _fileWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:nil];
    }
    
    return _fileWrapper;
}

- (SUTSpriteLayout *)layout
{
    if (!_layout)
    {
        _layout = [[SUTSpriteLayout alloc] init];
        _layout.delegate = self;
        [_layout prepareLayout];
    }
    
    return _layout;
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

- (NSString *)defaultDraftName
{
    return NSLocalizedString(@"new_document_nav",
                             nil);
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
    
    for (SUTSprite *sprite in self.sprites)
    {
        NSString *fileName = [self sanatizeFilePath:[sprite.fileURL path]];
        NSFileWrapper *existingFile = [self.fileWrapper.fileWrappers objectForKey:fileName];
        [files setObject:existingFile
                  forKey:fileName];
    }
    
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

#pragma mark - Image

- (NSImage *)imageForURL:(NSURL *)url
{
    NSString *path = [self sanatizeFilePath:[url path]];
    NSFileWrapper *imageFileWrapper = [self.fileWrapper.fileWrappers objectForKey:path];
    NSImage *image = nil;
    
    if (imageFileWrapper)
    {
        image = [[NSImage alloc] initWithData:imageFileWrapper.regularFileContents];
    }
    
    return image;
}

#pragma mark - Sprites

- (void)addSprite:(SUTSprite *)sprite
{
    [self insertObject:sprite
      inSpritesAtIndex:_sprites.count];
}

- (void)removeSprite:(SUTSprite *)sprite
{
    NSInteger indexOfSprite = [self.sprites indexOfObject:sprite];
    [self removeObjectFromSpritesAtIndex:indexOfSprite];
}

- (void)insertObject:(SUTSprite *)sprite
    inSpritesAtIndex:(NSUInteger)index
{
    sprite.document = self;
    
    NSFileWrapper *fileWrapper = [[NSFileWrapper alloc] initWithURL:sprite.fileURL
                                                            options:0
                                                              error:NULL];
    fileWrapper.preferredFilename = [self sanatizeFilePath:[sprite.fileURL path]];
    [self.fileWrapper addFileWrapper:fileWrapper];
    
    NSMutableArray *newSprites = [self.sprites mutableCopy];
    newSprites[index] = sprite;
    _sprites = newSprites;
    
    [self.layout prepareLayout];
}

- (void)removeObjectFromSpritesAtIndex:(NSUInteger)index
{
    SUTSprite *sprite = self.sprites[index];
    
    NSString *path = [self sanatizeFilePath:[sprite.fileURL path]];
    NSFileWrapper *imageFileWrapper = [self.fileWrapper.fileWrappers objectForKey:path];
    [self.fileWrapper removeFileWrapper:imageFileWrapper];
    
    NSMutableArray *newSprites = [self.sprites mutableCopy];
    [newSprites removeObjectAtIndex:index];
    _sprites = newSprites;
}

#pragma mark - Sanaity

- (NSString *)sanatizeFilePath:(NSString *)path
{
    NSCharacterSet* illegalFileNameCharacters = [NSCharacterSet characterSetWithCharactersInString:@"/\\?%*|\"<>"];
    return [[path componentsSeparatedByCharactersInSet:illegalFileNameCharacters] componentsJoinedByString:@""];
}


#pragma mark - SUTSpriteLayoutDelegate

- (NSInteger)numberOfSprites
{
    return self.sprites.count;
}

- (CGSize)sizeForSpriteAtIndex:(NSInteger)index
{
    SUTSprite *sprite = self.sprites[index];
    return sprite.size;
}

@end

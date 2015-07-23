//
//  SUTDocument.m
//  Suture
//
//  Created by James Campbell on 10/03/2015.
//  Copyright (c) 2015 James Campbell. All rights reserved.
//

#import "SUTDocument.h"

#import "SUTSprite.h"
#import "SUTSpritesheetLayout.h"
#import "SUTWindowController.h"

#import <os/activity.h>

@interface SUTDocument () <SUTSpritesheetLayoutDelegate>

@property (nonatomic, strong) NSFileWrapper *fileWrapper;

- (NSString *)sanatizeFilePath:(NSString *)path;

@end

@implementation SUTDocument

@synthesize sprites = _sprites;

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.duration = 1.0f;
    }
    
    return self;
}

#pragma mark - Data

- (NSFileWrapper *)fileWrapper
{
    if (!_fileWrapper)
    {
        _fileWrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:nil];
    }
    
    return _fileWrapper;
}

- (SUTSpritesheetLayout *)layout
{
    if (!_layout)
    {
        _layout = [[SUTSpritesheetLayout alloc] init];
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
        *outError = [NSError errorWithDomain:@"com.unii.suture" code:1 userInfo:userInfo];
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

#pragma mark - Sprite

- (CGSize)largestSpriteSize
{
    CGSize spriteSize = CGSizeZero;
    
    for (SUTSprite *sprite in self.sprites)
    {
        spriteSize = (CGSize)
        {
            MAX(sprite.size.width, spriteSize.width),
            MAX(sprite.size.height, spriteSize.height)
        };
    }
    
    return spriteSize;
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
      inSpritesAtIndex:self.sprites.count];
}

- (void)removeSprite:(SUTSprite *)sprite
{
    NSInteger indexOfSprite = [self indexOfSprite:sprite];
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
    self.sprites = [newSprites copy];
}

- (void)removeObjectFromSpritesAtIndex:(NSUInteger)index
{
    SUTSprite *sprite = self.sprites[index];
    
    NSString *path = [self sanatizeFilePath:[sprite.fileURL path]];
    NSFileWrapper *imageFileWrapper = [self.fileWrapper.fileWrappers objectForKey:path];
    [self.fileWrapper removeFileWrapper:imageFileWrapper];
    
    NSMutableArray *newSprites = [self.sprites mutableCopy];
    [newSprites removeObjectAtIndex:index];
    self.sprites = [newSprites copy];
}

- (NSInteger)indexOfSprite:(SUTSprite *)sprite
{
    return [self.sprites indexOfObject:sprite];
}

- (void)exchangeSpriteAtIndex:(NSUInteger)idx1
            withSpriteAtIndex:(NSUInteger)idx2
{
    NSMutableArray *newSprites = [self.sprites mutableCopy];
    [newSprites exchangeObjectAtIndex:idx1
                    withObjectAtIndex:idx2];
    self.sprites = [newSprites copy];
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

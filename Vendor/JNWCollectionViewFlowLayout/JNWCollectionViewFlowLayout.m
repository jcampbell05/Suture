//
//  JNWCollectionViewFlowLayout.m
//  JNWCollectionView
//
//  Created by Jonathan Willing on 4/11/13.
//  Copyright (c) 2013 AppJon. All rights reserved.
//
//  Copyright (modifications and additions) 2014 Crispin Bennett

#import "JNWCollectionViewFlowLayout.h"

NSString * const JNWCollectionViewFlowLayoutFooterKind = @"JNWCollectionViewFlowLayoutFooterKind";
NSString * const JNWCollectionViewFlowLayoutHeaderKind = @"JNWCollectionViewFlowLayoutHeaderKind";

typedef struct {
	CGPoint origin;
	CGSize size;
} JNWCollectionViewFlowLayoutItemInfo;

typedef struct {
    CGFloat height;
    CGFloat cursor;
    NSRange itemsRange;
} JNWCollectionViewFlowLayoutRowInfo;

@interface JNWCollectionViewFlowLayoutSection : NSObject
- (instancetype)initWithNumberOfItems:(NSInteger)numberOfItems;
@property (nonatomic, assign) CGFloat offset; // items' cached frames are relative to this
@property (nonatomic, assign) CGFloat height; // as per JNW's grid layout, this is height excluding header/footer

@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;
@property (nonatomic, assign) NSInteger numberOfItems;
@property (nonatomic, assign) JNWCollectionViewFlowLayoutItemInfo *itemInfo;
@end

@implementation JNWCollectionViewFlowLayoutSection

- (instancetype)initWithNumberOfItems:(NSInteger)numberOfItems
{
	self = [super init];
	if (self == nil) {return nil;}
	_numberOfItems = numberOfItems;
	self.itemInfo = calloc(numberOfItems, sizeof(JNWCollectionViewFlowLayoutItemInfo));
	return self;
}

- (void)dealloc
{
	if (_itemInfo != NULL)
    {
		free(_itemInfo);
	}
}

@end

@interface JNWCollectionViewFlowLayout ()
@property (nonatomic, strong) NSMutableArray *sections;
@end

@implementation JNWCollectionViewFlowLayout

- (instancetype)init
{
	self = [super init];
    
	if (self)
    {
        _minimumInterItemSpacing = 10.0f;
        _minimumLineSpacing = 10.0f;
        _alignment = JNWCollectionViewFlowLayoutAlignmentTop;
    }
	
	return self;
}

- (NSMutableArray *)sections
{
	if (_sections == nil)
    {
		_sections = [NSMutableArray array];
	}
    
	return _sections;
}

- (void)prepareLayout {

	NSParameterAssert(self.delegate);
	if (![self.delegate conformsToProtocol:@protocol(JNWCollectionViewFlowLayoutDelegate)])
    {
		NSLog(@"delegate does not conform to JNWCollectionViewFlowLayoutDelegate!");
	}

	[self.sections removeAllObjects];
	NSInteger numberOfSections = [self.collectionView numberOfSections];
	CGFloat rowWidth = self.collectionView.contentSize.width;
	CGFloat globalVerticalCursor = 0;

	for (NSInteger section = 0; section < numberOfSections; section++)
    {
		NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        //TODO now: these calls must be checked first! Can't rely on conformsToProtocol!
		CGFloat headerHeight = [self.delegate collectionView:self.collectionView heightForHeaderInSection:section];
		CGFloat footerHeight = [self.delegate collectionView:self.collectionView heightForFooterInSection:section];

		JNWCollectionViewFlowLayoutSection *sectionInfo = [[JNWCollectionViewFlowLayoutSection alloc]
		                                                                                       initWithNumberOfItems:numberOfItems];
		sectionInfo.headerHeight = headerHeight;
		sectionInfo.footerHeight = footerHeight;
		sectionInfo.offset = globalVerticalCursor + headerHeight;

		CGFloat sectionCursor = 0;

        JNWCollectionViewFlowLayoutRowInfo row = [self emptyRowWithFirstItemIndex:0];

		for (NSInteger itemIndex = 0; itemIndex < numberOfItems; itemIndex++)
        {
            row.itemsRange.length++;
			NSIndexPath *indexPath = [NSIndexPath jnw_indexPathForItem:itemIndex inSection:section];
			CGSize itemSize = [self.delegate collectionView:self.collectionView sizeForItemAtIndexPath:indexPath];

            // new row
			if ((row.cursor + itemSize.width) > rowWidth)
            {
				[self adjustVerticalAlignmentForRow:row inSection:sectionInfo];
                sectionCursor += row.height + self.minimumLineSpacing;
                row = [self emptyRowWithFirstItemIndex:itemIndex];
			}

			sectionInfo.itemInfo[itemIndex].origin = NSMakePoint(row.cursor, sectionCursor);
			sectionInfo.itemInfo[itemIndex].size = itemSize;

			row.height = MAX(itemSize.height, row.height);
            row.cursor += itemSize.width + self.minimumInterItemSpacing;
		}
        
        // adjustment for final row
		[self adjustVerticalAlignmentForRow:row inSection:sectionInfo];

		sectionInfo.height = sectionCursor + row.height;
		[self.sections addObject:sectionInfo];

		globalVerticalCursor = sectionInfo.offset + sectionInfo.height + footerHeight;
	}
}

- (void)adjustVerticalAlignmentForRow:(JNWCollectionViewFlowLayoutRowInfo)row inSection:(JNWCollectionViewFlowLayoutSection *)sectionInfo
{
    if(self.alignment == JNWCollectionViewFlowLayoutAlignmentTop) {return;}

    for (NSUInteger idx = row.itemsRange.location; idx < row.itemsRange.location + row.itemsRange.length; idx++) {
        CGFloat alignmentShift = row.height - sectionInfo.itemInfo[idx].size.height;
        alignmentShift = (self.alignment == JNWCollectionViewFlowLayoutAlignmentBottom) ? alignmentShift : alignmentShift / 2.0f;
        sectionInfo.itemInfo[idx].origin.y += alignmentShift;
    }
}

- (JNWCollectionViewFlowLayoutRowInfo)emptyRowWithFirstItemIndex:(NSInteger)firstItemIndex
{
    return (JNWCollectionViewFlowLayoutRowInfo){.height=0, .cursor=0, .itemsRange=NSMakeRange(firstItemIndex, 0)};
}

- (JNWCollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{

	NSParameterAssert(indexPath);

	JNWCollectionViewFlowLayoutSection *section = self.sections[[indexPath indexAtPosition:0]];
	JNWCollectionViewFlowLayoutItemInfo itemInfo = section.itemInfo[[indexPath indexAtPosition:1]];
	CGFloat offset = section.offset;

	JNWCollectionViewLayoutAttributes *attributes = [[JNWCollectionViewLayoutAttributes alloc] init];
	attributes.frame = CGRectMake(itemInfo.origin.x,
	                              itemInfo.origin.y + offset,
	                              itemInfo.size.width,
	                              itemInfo.size.height);
	attributes.alpha = 1.f;
	return attributes;
}

#pragma mark - Overrides primarily intended for optimisation

/// returns indexpaths for items whose rect intersects with the supplied rect
- (NSArray *)indexPathsForItemsInRect:(CGRect)rect
{
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    for (NSUInteger sectionIndex = 0; sectionIndex < self.sections.count; sectionIndex++)
    {
        JNWCollectionViewFlowLayoutSection *section = self.sections[sectionIndex];
        
        for (int itemIndex=0; itemIndex < section.numberOfItems; itemIndex++)
        {
            NSIndexPath *itemIndexPath = [NSIndexPath jnw_indexPathForItem:itemIndex inSection:sectionIndex];
            JNWCollectionViewFlowLayoutItemInfo item = section.itemInfo[itemIndex];
            NSRect itemRect = NSMakeRect(item.origin.x, item.origin.y + section.offset, item.size.width, item.size.height);
            if (NSIntersectsRect(rect, itemRect))
            {
                [indexPaths addObject:itemIndexPath];
            }
        }
    }

	return indexPaths;
}

// seems to be called when resizing
- (CGRect)rectForSectionAtIndex:(NSInteger)sectionIndex
{
	JNWCollectionViewFlowLayoutSection *section = self.sections[sectionIndex];
	NSRect rect = NSMakeRect(0.0f, section.offset, self.collectionView.contentSize.width, section.height);

	return rect;
}


// TODO: need a more refined approach (read: one that works) to finding above/below items
- (NSIndexPath *)indexPathForNextItemInDirection:(JNWCollectionViewDirection)direction
                                currentIndexPath:(NSIndexPath *)currentIndexPath
{
    NSIndexPath *newIndexPath;
    NSRect currentItemFrame;
    NSRect candidateFrame;
    NSArray *candidateIndexPaths;
    
    switch (direction)
    {
        case JNWCollectionViewDirectionLeft:
            newIndexPath = [self.collectionView indexPathForNextSelectableItemBeforeIndexPath:currentIndexPath];
            break;
        case JNWCollectionViewDirectionRight:
            newIndexPath = [self.collectionView indexPathForNextSelectableItemAfterIndexPath:currentIndexPath];
            break;
        case JNWCollectionViewDirectionUp:
            currentItemFrame = [self.collectionView rectForItemAtIndexPath:currentIndexPath];
            candidateFrame = CGRectApplyAffineTransform(currentItemFrame, CGAffineTransformMakeTranslation(0, -currentItemFrame.size.height));
            candidateIndexPaths = [self.collectionView indexPathsForItemsInRect:candidateFrame];
            if(candidateIndexPaths.count > 0){
                newIndexPath = candidateIndexPaths[0];
            }
            break;
        case JNWCollectionViewDirectionDown:
            currentItemFrame = [self.collectionView rectForItemAtIndexPath:currentIndexPath];
            candidateFrame = CGRectApplyAffineTransform(currentItemFrame, CGAffineTransformMakeTranslation(0, currentItemFrame.size.height));
            candidateIndexPaths = [self.collectionView indexPathsForItemsInRect:candidateFrame];
            if(candidateIndexPaths.count > 0){
                newIndexPath = candidateIndexPaths[0];
            }
            break;
        default:
            assert(NO);
            break;
    }

    return newIndexPath;
}

#pragma mark - Headers and Footers

- (JNWCollectionViewLayoutAttributes *)layoutAttributesForSupplementaryItemInSection:(NSInteger)idx kind:(NSString *)kind
{
	JNWCollectionViewFlowLayoutSection *section = self.sections[idx];
	CGFloat width = self.collectionView.visibleSize.width;
	CGRect frame = CGRectZero;
	
	if ([kind isEqualToString:JNWCollectionViewFlowLayoutHeaderKind]) {
		frame = CGRectMake(0, section.offset - section.headerHeight, width, section.headerHeight);
	} else if ([kind isEqualToString:JNWCollectionViewFlowLayoutFooterKind]) {
		frame = CGRectMake(0, section.offset + section.height, width, section.footerHeight);
	}
	
	JNWCollectionViewLayoutAttributes *attributes = [[JNWCollectionViewLayoutAttributes alloc] init];
	attributes.frame = frame;
	attributes.alpha = 1.f;
	return attributes;
}

@end

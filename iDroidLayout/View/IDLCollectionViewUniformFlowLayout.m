//
// Created by Jose Rojas on 3/31/15.
// Copyright (c) 2015 Jose Rojas. All rights reserved.
//

#import "IDLCollectionViewUniformFlowLayout.h"

@implementation IDLCollectionViewUniformFlowLayout

- (instancetype) init {
    self = [super init];

    self.minimumInteritemSpacing = 0;
    self.maximumInteritemSpacing = 0;

    return self;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray* arr = [super layoutAttributesForElementsInRect:rect];
    CGFloat spacing = NAN;
    for (UICollectionViewLayoutAttributes* atts in arr) {
        if (nil == atts.representedElementKind) {
            NSIndexPath* ip = atts.indexPath;

            atts.frame = [self layoutAttributesForItemAtIndexPath:ip withOriginalSpacing:&spacing].frame;
        }
    }
    return arr;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat spacing = NAN;
    UICollectionViewLayoutAttributes* atts =
        [self layoutAttributesForItemAtIndexPath:indexPath withOriginalSpacing:&spacing];
    return atts;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath*)indexPath
                                                     withOriginalSpacing: (CGFloat*) spacing {

    UICollectionViewLayoutAttributes* atts =
        [super layoutAttributesForItemAtIndexPath:indexPath];

    if (indexPath.item == 0) // degenerate case 1, first item of section
        return atts;

    /*
      assuming the items all have equal horizontal spacing and equal widths... (won't work in more complex flow layouts)
      eliminate the extra spacing by removing the delta between the actual spacing and the maximum spacing.
     */

    CGFloat spacingValue = self.maximumInteritemSpacing;

    CGRect rect;
    rect.size = atts.frame.size;
    rect.origin.x = indexPath.item * (atts.frame.size.width + spacingValue);
    rect.origin.y = 0;
    atts.frame = rect;

    return atts;

}

@end
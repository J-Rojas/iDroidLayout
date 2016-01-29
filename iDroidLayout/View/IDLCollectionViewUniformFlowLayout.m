//
// Created by Jose Rojas on 3/31/15.
// Copyright (c) 2015 Jose Rojas. All rights reserved.
//

#import "IDLCollectionViewUniformFlowLayout.h"

@implementation IDLCollectionViewUniformFlowLayout

- (instancetype) init {
    self = [super init];

    self.minimumInteritemSpacing = 0;

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

    NSIndexPath* ipPrev = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
    CGRect fPrev = [super layoutAttributesForItemAtIndexPath:ipPrev].frame;
    CGFloat rightPrev = indexPath.item * fPrev.size.width;
    CGFloat spacingValue = fmaxf(fminf(atts.frame.origin.x - rightPrev, self.maximumInteritemSpacing), self.minimumInteritemSpacing);

    //adjust the rightPrev based on previous spacing
    rightPrev += spacingValue * indexPath.item;

    //handle maximum interitem spacing
    if (atts.frame.origin.x <= rightPrev) //the current applied spacing is within range
        return atts;

    CGRect f = atts.frame;
    f.origin.x = rightPrev;
    atts.frame = f;

    return atts;

}

@end
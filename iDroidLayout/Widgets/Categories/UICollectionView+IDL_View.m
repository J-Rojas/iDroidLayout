//
// Created by Jose Rojas on 3/31/15.
// Copyright (c) 2015 Jose Rojas. All rights reserved.
//

#import <UIKit/UICollectionViewFlowLayout.h>
#import "UIView+IDL_Layout.h"
#import "UICollectionView+IDL_View.h"
#import "IDLCollectionViewFlowLayout.h"

@implementation UICollectionView (IDL_View)

- (instancetype)initWithAttributes:(NSDictionary *)attrs {
    [self setupFromAttributes:attrs];
    self = [self initWithFrame:self.frame collectionViewLayout:[IDLCollectionViewFlowLayout new]];
    return self;
}

- (void)requestLayout {
    //Table should not use IDL layout - it manages its own layout mechanism
}

- (void)onLayoutWithFrame:(CGRect)frame didFrameChange:(BOOL)changed {
    //Table should not use IDL layout - it manages its own layout mechanism
}

@end
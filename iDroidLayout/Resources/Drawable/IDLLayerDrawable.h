//
//  IDLLayerDrawable.h
//  iDroidLayout
//
//  Created by Tom Quist on 17.12.12.
//  Copyright (c) 2012 Tom Quist. All rights reserved.
//

#import "IDLDrawable.h"

@interface IDLLayerDrawable : IDLDrawable <IDLDrawableDelegate>

- (IDLDrawable*) drawableAtIndex: (NSUInteger) index;

@property (nonatomic, readonly) NSUInteger numberOfLayers;

@end

@interface IDLLayerDrawableConstantState : IDLDrawableConstantState

@end

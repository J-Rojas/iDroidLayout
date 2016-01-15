//
//  MarginLayoutParams.m
//  iDroidLayout
//
//  Created by Tom Quist on 22.07.12.
//  Copyright (c) 2012 Tom Quist. All rights reserved.
//

#import <iDroidLayout/NSDictionary+IDL_ResourceManager.h>
#import "IDLMarginLayoutParams.h"

@implementation IDLMarginLayoutParams

@synthesize margin = _margin;



- (instancetype)initWithWidth:(CGFloat)width height:(CGFloat)height {
	self = [super initWithWidth:width height:height];
	if (self != nil) {
		
	}
	return self;
}

- (instancetype)initWithLayoutParams:(IDLLayoutParams *)layoutParams {
    self = [super initWithLayoutParams:layoutParams];
    if (self != nil) {
        if ([layoutParams isKindOfClass:[IDLMarginLayoutParams class]]) {
            IDLMarginLayoutParams *otherLP = (IDLMarginLayoutParams *)layoutParams;
            self.margin = otherLP.margin;
        }
    }
    return self;
}

- (instancetype)initWithAttributes:(NSDictionary *)attrs {
    self = [super initWithAttributes:attrs];
    if (self) {
        NSString *marginString = attrs[@"layout_margin"];
        if (marginString != nil) {
            CGFloat margin = [attrs dimensionFromIDLValueForKey:@"layout_margin"];
            _margin = UIEdgeInsetsMake(margin, margin, margin, margin);
        } else {
            CGFloat marginLeft = [attrs dimensionFromIDLValueForKey:@"layout_marginLeft"];
            CGFloat marginTop = [attrs dimensionFromIDLValueForKey:@"layout_marginTop"];
            CGFloat marginBottom = [attrs dimensionFromIDLValueForKey:@"layout_marginBottom"];
            CGFloat marginRight = [attrs dimensionFromIDLValueForKey:@"layout_marginRight"];
            _margin = UIEdgeInsetsMake(marginTop, marginLeft, marginBottom, marginRight);
        }
    }
    return self;
}

@end

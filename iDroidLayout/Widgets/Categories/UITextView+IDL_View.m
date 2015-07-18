//
//  UITextView+IDL_View.m
//  iDroidLayout
//
//  Created by Tom Quist on 03.01.13.
//  Copyright (c) 2013 Tom Quist. All rights reserved.
//

#import "UITextView+IDL_View.h"
#import "UIView+IDL_ViewGroup.h"
#import "NSDictionary+IDL_ResourceManager.h"

@implementation UITextView (IDL_View)

- (void)setupFromAttributes:(NSDictionary *)attrs {

    self.textContainer.lineFragmentPadding = 0;
    self.textContainerInset = UIEdgeInsetsZero;

    [super setupFromAttributes:attrs];

    self.text = [attrs stringFromIDLValueForKey:@"text"];

    IDLColorStateList *textColorStateList = [attrs colorStateListFromIDLValueForKey:@"textColor"];
    if (textColorStateList != nil) {
        self.textColor = [textColorStateList colorForControlState:UIControlStateNormal];
    } else {
        UIColor *color = [attrs colorFromIDLValueForKey:@"textColor"];
        if (color != nil) {
            self.textColor = color;
        }
    }

    NSString *fontName = attrs[@"font"];
    NSString *textSize = attrs[@"textSize"];
    if (fontName != nil) {
        CGFloat size = self.font.pointSize;
        if (textSize != nil) size = [textSize floatValue];
        self.font = [UIFont fontWithName:fontName size:size];
    } else if (textSize != nil) {
        CGFloat size = [textSize floatValue];
        self.font = [UIFont systemFontOfSize:size];
    }
}

- (void)setPadding:(UIEdgeInsets)padding {
    [super setPadding:padding];
    self.contentInset = padding;
    self.textContainerInset = UIEdgeInsetsZero;
}

- (BOOL)isViewGroup {
    return FALSE;
}

@end

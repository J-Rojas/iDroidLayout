//
//  UIImage+IDL_FromColor.m
//  iDroidLayout
//
//  Created by Tom Quist on 08.12.12.
//  Copyright (c) 2012 Tom Quist. All rights reserved.
//

#import "UIImage+IDL_FromColor.h"

@implementation UIImage (IDL_FromColor)

+ (UIImage *)idl_imageFromColor:(UIColor *)color withSize:(CGSize)size {
    UIImage *image = nil;
    @autoreleasepool {
        CGRect rect = CGRectZero;
        rect.size = size;
        
        UIGraphicsBeginImageContextWithOptions(rect.size, FALSE, 0.f);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, rect);
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if ([image respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)]) {
            image = [image resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
        } else if ([image respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
            image = [image resizableImageWithCapInsets:UIEdgeInsetsZero];
        } else if ([image respondsToSelector:@selector(stretchableImageWithLeftCapWidth:topCapHeight:)]) {
            image = [image stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        } else {
            image = image;
        }
    }
    return image;
}

+ (UIImage *)idl_image:(UIImage*) image withTintColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0f);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end


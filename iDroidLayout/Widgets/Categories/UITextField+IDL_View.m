//
// Created by Jose Rojas on 4/9/15.
//

#import <iDroidLayout/IDLGravity.h>
#import "UITextField+IDL_View.h"
#import "UIView+IDL_Layout.h"
#import "IDLResourceManager+Core.h"
#import "IDLResourceManager+String.h"
#import "NSDictionary+IDL_ResourceManager.h"
#import <objc/runtime.h>

static const char *kIDLUITextFieldColorStateList = "IDLUITextFieldColorStateList";

@implementation UITextField (IDL_View)

- (void)setupFromAttributes:(NSDictionary *)attrs {

    [super setupFromAttributes:attrs];

    self.text = [attrs stringFromIDLValueForKey:@"text"];
    self.gravity = [IDLGravity gravityFromAttribute:attrs[@"gravity"]];

    [self setInputType:[attrs stringFromIDLValueForKey:@"inputType"]];

    //placeholder
    NSString *placeholderText = attrs[@"hint"];
    NSString *placeholderString;
    if ([[IDLResourceManager currentResourceManager] isValidIdentifier:placeholderText]) {
        placeholderString = [[IDLResourceManager currentResourceManager] stringForIdentifier:placeholderText];
    } else {
        placeholderString = placeholderText;
    }

    UIColor *hintColor = [attrs colorFromIDLValueForKey:@"hintColor"];
    if (hintColor != nil) {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderString attributes:@{NSForegroundColorAttributeName: hintColor}];
    } else {
        self.placeholder = placeholderString;
    }

    IDLColorStateList *textColorStateList = [attrs colorStateListFromIDLValueForKey:@"textColor"];
    if (textColorStateList != nil) {
        self.textColor = [textColorStateList colorForControlState:UIControlStateNormal];
        [self setTextColorList:textColorStateList];
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

- (void)setInputType:(NSString *)inputType {

    if ([inputType containsString:@"textEmailAddress"]) {
        self.keyboardType = UIKeyboardTypeEmailAddress;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    } else if ([inputType containsString:@"textVisiblePassword"]) {
        self.secureTextEntry = NO;
    } else if ([inputType containsString:@"textPassword"]) {
        self.secureTextEntry = YES;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    } else if ([inputType containsString:@"numberSigned"]) {
        self.keyboardType = UIKeyboardTypeDecimalPad;
    } else if ([inputType containsString:@"numberPassword"]) {
        self.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    } else if ([inputType containsString:@"number"]) {
        self.keyboardType = UIKeyboardTypeNumberPad;
    } else if ([inputType containsString:@"phone"]) {
        self.keyboardType = UIKeyboardTypePhonePad;
    }

    if ([inputType containsString:@"textCapCharacters"]) {
        self.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    } else if ([inputType containsString:@"textCapWords"]) {
        self.autocapitalizationType = UITextAutocapitalizationTypeWords;
    } else if ([inputType containsString:@"textCapSentences"]) {
        self.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    } else if ([inputType containsString:@"textCapCharacters"]) {
        self.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    }

    self.autocorrectionType = UITextAutocorrectionTypeNo;
    if ([inputType containsString:@"textAutoCorrect"]) {
        self.autocorrectionType = UITextAutocorrectionTypeYes;
    }
}


- (void)setGravity:(IDLViewContentGravity)gravity {
    if ((gravity & IDLViewContentGravityLeft) == IDLViewContentGravityLeft) {
        self.textAlignment = NSTextAlignmentLeft;
    } else if ((gravity & IDLViewContentGravityRight) == IDLViewContentGravityRight) {
        self.textAlignment = NSTextAlignmentRight;
    } else {
        self.textAlignment = NSTextAlignmentCenter;
    }
}

- (void)setTextColorList:(IDLColorStateList *)list {
    objc_setAssociatedObject(self, kIDLUITextFieldColorStateList, list, OBJC_ASSOCIATION_RETAIN);
}

- (IDLColorStateList *)textColorList {
    return objc_getAssociatedObject(self, kIDLUITextFieldColorStateList);
}

@end
//
// Created by Jose Rojas on 4/9/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UITextField.h>

@class IDLColorStateList;

@interface UITextField (IDL_View)

- (void)setInputType: (NSString*) inputType;

@property (nonatomic, readwrite, strong) IDLColorStateList * textColorList;

@end
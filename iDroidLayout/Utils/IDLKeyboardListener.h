//
// Created by Jose Rojas on 4/25/15.
//

#import <Foundation/Foundation.h>


@interface IDLKeyboardListener : NSObject

+ (instancetype) shared;
+ (void) terminate;

- (BOOL) isVisible;

- (CGRect) getLocalKeyboardFrame: (UIWindow*) window toView: (UIView*) view;

@end
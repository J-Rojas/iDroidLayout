//
// Created by Jose Rojas on 4/25/15.
//

#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import "IDLKeyboardListener.h"

static IDLKeyboardListener* sListener;

@implementation IDLKeyboardListener {
    BOOL _visible;
    CGRect _keyboardFrame;
}

+ (instancetype) shared {

    if ( nil == sListener ) sListener = [[IDLKeyboardListener alloc] init];

    return sListener;
}

+ (void)terminate {
    if (sListener != nil) {
        sListener = nil;
    }
}

- (instancetype) init {
    self = [super init];

    if ( self ) {
        NSNotificationCenter		*center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(noticeWillShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
        [center addObserver:self selector:@selector(noticeShowKeyboard:) name:UIKeyboardDidShowNotification object:nil];
        [center addObserver:self selector:@selector(noticeHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
        [center addObserver:self selector:@selector(noticeKeyboardFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [center addObserver:self selector:@selector(noticeKeyboardFrameChanged:) name:UIKeyboardDidChangeFrameNotification object:nil];

    }

    return self;
}

- (void) dealloc {
    NSNotificationCenter		*center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [center removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
};

-(void) noticeWillShowKeyboard:(NSNotification *)inNotification {
    _keyboardFrame = [(inNotification.userInfo)[UIKeyboardFrameEndUserInfoKey] CGRectValue];
}

-(void) noticeShowKeyboard:(NSNotification *)inNotification {
    _visible = true;
    _keyboardFrame = [(inNotification.userInfo)[UIKeyboardFrameEndUserInfoKey] CGRectValue];
}

-(void) noticeHideKeyboard:(NSNotification *)inNotification {
    _visible = false;
    _keyboardFrame = [(inNotification.userInfo)[UIKeyboardFrameEndUserInfoKey] CGRectValue];
}

- (void) noticeKeyboardFrameChanged: (NSNotification *) inNotification {

}

- (CGRect)getLocalKeyboardFrame:(UIWindow *)window toView: (UIView*) view notification: (NSNotification *) notification {
    //handle out of order NSNotifications
    if (_keyboardFrame.size.height == 0) {
        [self noticeWillShowKeyboard:notification];
    }
    return [view convertRect:_keyboardFrame fromView:window];
}

-(BOOL) isVisible {
    return _visible;
}



@end
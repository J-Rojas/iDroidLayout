//
//  LayoutBridge.m
//  iDroidLayout
//
//  Created by Tom Quist on 22.07.12.
//  Copyright (c) 2012 Tom Quist. All rights reserved.
//

#import "IDLLayoutBridge.h"
#import "UIView+IDL_Layout.h"
#import "IDLMarginLayoutParams.h"
#import "IDLLayoutInflater.h"
#import "IDLKeyboardListener.h"
#import "UIView+IDL_KVOObserver.h"

@implementation UIView (IDLLayoutBridge)

- (UIView *)findAndScrollToFirstResponder {
    UIView *ret = nil;
    if (self.isFirstResponder) {
        ret = self;
    }
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findAndScrollToFirstResponder];
        if (firstResponder) {
            if ([self isKindOfClass:[UIScrollView class]]) {
                UIScrollView *sv = (UIScrollView *)self;
                CGRect r = [self convertRect:firstResponder.frame fromView:firstResponder];
                [sv scrollRectToVisible:r animated:FALSE];
                ret = self;
            } else {
                ret = firstResponder;
            }
            break;
        }
    }
    return ret;
}

@end

@implementation IDLLayoutBridge {
    CGRect _lastFrame;
    CGRect _keyboardFrame;
    BOOL _resizeOnKeyboard;
    BOOL _scrollToTextField;
}

@synthesize resizeOnKeyboard = _resizeOnKeyboard;
@synthesize scrollToTextField = _scrollToTextField;

- (void)dealloc {

    [self idl_removeKVOObservers];

	if (_resizeOnKeyboard) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
    if (_scrollToTextField) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
        [center removeObserver:self name:UITextFieldTextDidEndEditingNotification object:nil];
        [center removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
        [center removeObserver:self name:UITextViewTextDidEndEditingNotification object:nil];
    }
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)addSubview:(UIView *)view {
    for (UIView *subviews in [self subviews]) {
        [subviews removeFromSuperview];
    }
    [super addSubview:view];
}

- (void)onLayoutWithFrame:(CGRect)frame didFrameChange:(BOOL)changed {
    UIView *firstChild = [self.subviews lastObject];
    if (firstChild != nil) {
        CGSize size = firstChild.measuredSize;
        IDLMarginLayoutParams *lp = (IDLMarginLayoutParams *)firstChild.layoutParams;
        UIEdgeInsets margin = lp.margin;
        [firstChild layoutWithFrame:CGRectMake(margin.left, margin.top, size.width, size.height)];
    }
}

- (void)onMeasureWithWidthMeasureSpec:(IDLLayoutMeasureSpec)widthMeasureSpec heightMeasureSpec:(IDLLayoutMeasureSpec)heightMeasureSpec {
    NSUInteger size = [self.subviews count];
    for (int i = 0; i < size; ++i) {
        UIView *child = (self.subviews)[i];
        if (child.visibility != IDLViewVisibilityGone) {
            [self measureChildWithMargins:child parentWidthMeasureSpec:widthMeasureSpec widthUsed:0 parentHeightMeasureSpec:heightMeasureSpec heightUsed:0];
        }
    }

    UIView* firstChild = self.subviews.firstObject;
    IDLLayoutParams * layoutParams = self.layoutParams;

    IDLLayoutMeasuredSize measuredSize;
    measuredSize.width.state = IDLLayoutMeasuredStateNone;
    measuredSize.width.size = layoutParams.width == IDLLayoutParamsSizeWrapContent ? firstChild.measuredSize.width : widthMeasureSpec.size;
    measuredSize.height.state = IDLLayoutMeasuredStateNone;
    measuredSize.height.size = layoutParams.height == IDLLayoutParamsSizeWrapContent ? firstChild.measuredSize.height : heightMeasureSpec.size;

    [self setMeasuredDimensionSize:measuredSize];
}

- (IDLLayoutParams *)generateDefaultLayoutParams {
    IDLMarginLayoutParams *lp = [[IDLMarginLayoutParams alloc] initWithWidth:IDLLayoutParamsSizeMatchParent height:IDLLayoutParamsSizeMatchParent];
    lp.width = IDLLayoutParamsSizeMatchParent;
    lp.height = IDLLayoutParamsSizeMatchParent;
    return lp;;
}

-(IDLLayoutParams *)generateLayoutParamsFromLayoutParams:(IDLLayoutParams *)layoutParams {
    return [[IDLMarginLayoutParams alloc] initWithLayoutParams:layoutParams];
}

- (IDLLayoutParams *)generateLayoutParamsFromAttributes:(NSDictionary *)attrs {
    return [[IDLMarginLayoutParams alloc] initWithAttributes:attrs];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!CGRectEqualToRect(self.frame, _lastFrame) || self.isLayoutRequested) {
        NSDate *methodStart = [NSDate date];
        [self measureAndLayout];
        _lastFrame = self.frame;
        NSDate *methodFinish = [NSDate date];
        NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
        NSLog(@"Relayout took %.2fms", executionTime*1000);
    }
}

- (void) adjustKeyboardFrame: (NSNotification *) notification {
    CGRect f = self.frame;
    CGRect rectKeyboard = [[IDLKeyboardListener shared] getLocalKeyboardFrame:self.window toView:self notification: notification];
    f.size.height = rectKeyboard.origin.y;
    _keyboardFrame = f;
}

- (void)willShowKeyboard:(NSNotification *)notification {
    [self adjustKeyboardFrame: notification];
    self.frame = _keyboardFrame;
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [self layoutIfNeeded];
        
    }];
}

- (void)didShowKeyboard:(NSNotification *)notification {

}

- (void)willHideKeyboard:(NSNotification *)notification {
    CGRect rectKeyboard = [[IDLKeyboardListener shared] getLocalKeyboardFrame:self.window toView:self notification: notification];
    CGRect f = self.frame;
    f.size.height = rectKeyboard.origin.y;
    self.frame = f;
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)didBeginEditing:(NSNotification *)notification {
    [UIView animateWithDuration:0.3 animations:^{
        [self findAndScrollToFirstResponder];        
    }];
}

- (void)didEndEditing:(NSNotification *)notification {
    
}

- (void)setScrollToTextField:(BOOL)scrollToTextField {
    if (scrollToTextField && !_scrollToTextField) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(didBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
        [center addObserver:self selector:@selector(didEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
        [center addObserver:self selector:@selector(didBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
        [center addObserver:self selector:@selector(didEndEditing:) name:UITextViewTextDidEndEditingNotification object:nil];
    } else if (!scrollToTextField && _scrollToTextField) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
        [center removeObserver:self name:UITextFieldTextDidEndEditingNotification object:nil];
        [center removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
        [center removeObserver:self name:UITextViewTextDidEndEditingNotification object:nil];
    }
    _scrollToTextField = scrollToTextField;
}

- (void)setResizeOnKeyboard:(BOOL)resizeOnKeyboard {
    [IDLKeyboardListener shared];
    if (resizeOnKeyboard && !_resizeOnKeyboard) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
        [center addObserver:self selector:@selector(didShowKeyboard:) name:UIKeyboardDidShowNotification object:nil];
        [center addObserver:self selector:@selector(willHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    } else if (!resizeOnKeyboard && _resizeOnKeyboard) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [center removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
    _resizeOnKeyboard = resizeOnKeyboard;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"layout"]) {
        NSString *pathExtension = [value pathExtension];
        if ([pathExtension length] == 0) {
            pathExtension = @"xml";
        }
        NSURL *url = [[NSBundle mainBundle] URLForResource:[value stringByDeletingPathExtension] withExtension:pathExtension];
        if (url != nil) {
            IDLLayoutInflater *inflater = [[IDLLayoutInflater alloc] init];
            [inflater inflateURL:url intoRootView:self attachToRoot:TRUE];
        }
    } else {
        [super setValue:value forUndefinedKey:key];
    }
}

- (void)setFrame:(CGRect)frame {
    if ([[IDLKeyboardListener shared] isVisible] && _resizeOnKeyboard) {
        if (_keyboardFrame.size.height == 0) {
            [super setFrame:frame];
            [self adjustKeyboardFrame: nil];
        }
        [super setFrame:_keyboardFrame];
    } else{
        [super setFrame:frame];
    }

}

- (void)measureAndLayout {
    IDLLayoutParams * layoutParams = self.layoutParams;

    IDLLayoutMeasureSpec widthMeasureSpec;
    IDLLayoutMeasureSpec heightMeasureSpec;
    widthMeasureSpec.size = self.frame.size.width;
    heightMeasureSpec.size = self.frame.size.height;
    widthMeasureSpec.mode = layoutParams.width == IDLLayoutParamsSizeWrapContent ? IDLLayoutMeasureSpecModeUnspecified : IDLLayoutMeasureSpecModeExactly;
    heightMeasureSpec.mode = layoutParams.height == IDLLayoutParamsSizeWrapContent ? IDLLayoutMeasureSpecModeUnspecified : IDLLayoutMeasureSpecModeExactly;

    [self measureWithWidthMeasureSpec:widthMeasureSpec heightMeasureSpec:heightMeasureSpec];

    CGRect rect = {self.frame.origin, self.measuredSize};
    self.frame = rect;
    [self layoutWithFrame:rect];
}

@end

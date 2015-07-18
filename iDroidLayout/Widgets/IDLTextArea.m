//
//  IDLTextArea.m
//  iDroidLayout
//
//  Created by Tom Quist on 03.01.13.
//  Copyright (c) 2013 Tom Quist. All rights reserved.
//

#import <ViewUtils/ViewUtils.h>
#import "IDLTextArea.h"
#import "UIView+IDL_Layout.h"
#import "UILabel+IDL_View.h"
#import "IDLResourceManager+Core.h"
#import "IDLResourceManager+String.h"
#import "UIView+IDL_ViewGroup.h"
#import "IDLTextView.h"

@implementation IDLTextArea {
    IDLTextView * _placeHolderLabel;
}

- (void)setupFromAttributes:(NSDictionary *)attrs {
    [super setupFromAttributes:attrs];

    //placeholder
    NSString* text = attrs[@"hint"];
    if ([[IDLResourceManager currentResourceManager] isValidIdentifier:text]) {
        NSString *title = [[IDLResourceManager currentResourceManager] stringForIdentifier:text];
        self.placeholder = title;
    } else {
        self.placeholder = text;
    }

    if (_placeHolderLabel == nil )
    {
        _placeHolderLabel = [[IDLTextView alloc] initWithFrame:CGRectMake(0,0,self.bounds.size.width,0)];
        _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _placeHolderLabel.numberOfLines = 0;
        _placeHolderLabel.font = self.font;
        _placeHolderLabel.backgroundColor = [UIColor clearColor];
        _placeHolderLabel.textColor = self.placeholderColor;
        [self addSubview:_placeHolderLabel];
    }

    _placeHolderLabel.text = self.placeholder;
    [_placeHolderLabel sizeToFit];

}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
    [self requestLayout];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self requestLayout];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    if (_placeHolderLabel) {
        _placeHolderLabel.text = placeholder;
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];

    if (_placeHolderLabel) {
        CGRect rect = CGRectMake(0, 0, 0, 0);
        rect.size = [_placeHolderLabel sizeThatFits:frame.size];
        _placeHolderLabel.frame = rect;

        IDLLayoutMeasureSpec width = { rect.size.width, IDLLayoutMeasureSpecModeExactly };
        IDLLayoutMeasureSpec height = { rect.size.height, IDLLayoutMeasureSpecModeExactly };
        [_placeHolderLabel measureWithWidthMeasureSpec:width heightMeasureSpec:height];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }

    return self;
}

- (void)textChanged:(NSNotification *)notification
{
    if([[self placeholder] length] == 0)
    {
        return;
    }

    _placeHolderLabel.hidden = [self text].length != 0;
}

- (void)drawRect:(CGRect)rect
{

    if( [[self placeholder] length] > 0 )
    {
        [self sendSubviewToBack:_placeHolderLabel];
    }

    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
    {
        _placeHolderLabel.hidden = NO;
    }

    [super drawRect:rect];
}

- (BOOL) isViewGroup {
    return YES;
}


@end

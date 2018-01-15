//
//  IDLCollectionViewCell.m
//  iDroidLayout
//
//  Created by Jose Rojas on 3/31/15.
//  Copyright (c) 2015 Jose Rojas.
//

#import "IDLCollectionViewCell.h"
#import "IDLLayoutInflater.h"

@implementation IDLCollectionViewCell {

}

@synthesize layoutBridge = _layoutBridge;
@synthesize layoutURL = _layoutURL;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    IDLLayoutBridge *bridge = [[IDLLayoutBridge alloc] initWithFrame:self.contentView.bounds];
    bridge.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:bridge];

    _layoutBridge = bridge;

    return self;
}

- (void) setLayoutResource:(NSString *)resource {
    [self setLayoutResource:resource
                   inflater:[[IDLLayoutInflater alloc] init]];
}

- (void) setLayoutResource:(NSString *)resource
                  inflater: (IDLLayoutInflater *) inflater {
    for (UIView* subview in _layoutBridge.subviews)
        [subview removeFromSuperview];
    [inflater inflateResource:resource intoRootView:_layoutBridge attachToRoot:TRUE];
}

- (void) setLayoutURL:(NSURL *)url {
    _layoutURL = url;
    [self setLayoutURL:url inflater:[[IDLLayoutInflater alloc] init]];
};

- (void) setLayoutURL:(NSURL *)url inflater: (IDLLayoutInflater *) inflater {
    for (UIView* subview in _layoutBridge.subviews)
        [subview removeFromSuperview];
    [inflater inflateURL:url intoRootView:_layoutBridge attachToRoot:TRUE];
}

- (BOOL)isViewGroup {
    return TRUE;
}

@end

//
//  IDLCollectionViewCell.m
//  iDroidLayout
//
//  Created by Tom Quist on 22.07.12.
//  Copyright (c) 2012 Tom Quist. All rights reserved.
//

#import "IDLCollectionViewCell.h"
#import "IDLLayoutInflater.h"

@implementation IDLCollectionViewCell

@synthesize layoutBridge = _layoutBridge;

- (void) setLayoutResource:(NSString *)resource {
    [self setLayoutResource:resource
                   inflater:[[IDLLayoutInflater alloc] init]];
}

- (void) setLayoutResource:(NSString *)resource
                  inflater: (IDLLayoutInflater *) inflater {
    IDLLayoutBridge *bridge = [[IDLLayoutBridge alloc] initWithFrame:self.contentView.bounds];
    bridge.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:bridge];
    [inflater inflateResource:resource intoRootView:bridge attachToRoot:TRUE];

    _layoutBridge = bridge;
}

- (void) setLayoutURL:(NSURL *)url {
    [self setLayoutURL:url inflater:[[IDLLayoutInflater alloc] init]];
};

- (void) setLayoutURL:(NSURL *)url inflater: (IDLLayoutInflater *) inflater {
    IDLLayoutBridge *bridge = [[IDLLayoutBridge alloc] initWithFrame:self.contentView.bounds];
    bridge.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:bridge];
    [inflater inflateURL:url intoRootView:bridge attachToRoot:TRUE];

    _layoutBridge = bridge;
}

- (BOOL)isViewGroup {
    return TRUE;
}

@end

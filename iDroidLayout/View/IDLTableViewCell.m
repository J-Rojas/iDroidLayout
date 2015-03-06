//
//  IDLTableViewCell.m
//  iDroidLayout
//
//  Created by Tom Quist on 22.07.12.
//  Copyright (c) 2012 Tom Quist. All rights reserved.
//

#import "IDLTableViewCell.h"
#import "IDLLayoutInflater.h"

@implementation IDLTableViewCell

@synthesize layoutBridge = _layoutBridge;

- (instancetype)initWithLayoutResource:(NSString *)resource reuseIdentifier:(NSString *)reuseIdentifier {
    return [self initWithLayoutResource:resource
                        reuseIdentifier:reuseIdentifier
                               inflater:[[IDLLayoutInflater alloc] init]];
}

- (instancetype)initWithLayoutResource:(NSString *)resource
                       reuseIdentifier:(NSString *)reuseIdentifier
                              inflater: (IDLLayoutInflater *) inflater {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        IDLLayoutBridge *bridge = [[IDLLayoutBridge alloc] initWithFrame:self.contentView.bounds];
        bridge.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:bridge];
        [inflater inflateResource:resource intoRootView:bridge attachToRoot:TRUE];
        
        _layoutBridge = bridge;
    }
    return self;
}

- (instancetype)initWithLayoutURL:(NSURL *)url
                  reuseIdentifier:(NSString *)reuseIdentifier {
    return [self initWithLayoutURL:url reuseIdentifier:reuseIdentifier inflater:[[IDLLayoutInflater alloc] init]];
};

- (instancetype)initWithLayoutURL:(NSURL *)url
                  reuseIdentifier:(NSString *)reuseIdentifier
                         inflater: (IDLLayoutInflater *) inflater{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        IDLLayoutBridge *bridge = [[IDLLayoutBridge alloc] initWithFrame:self.contentView.bounds];
        bridge.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:bridge];
        [inflater inflateURL:url intoRootView:bridge attachToRoot:TRUE];
        
        _layoutBridge = bridge;
    }
    return self;
}

- (BOOL)isViewGroup {
    return TRUE;
}

@end

//
//  IDLCollectionViewCell.h
//  iDroidLayout
//
//  Created by Tom Quist on 22.07.12.
//  Copyright (c) 2012 Tom Quist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDLLayoutBridge.h"

@class IDLLayoutInflater;

@interface IDLCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic, readonly) IDLLayoutBridge *layoutBridge;

- (void) setLayoutResource: (NSString *)resource;

- (void) setLayoutURL: (NSURL *)url;

- (void) setLayoutResource: (NSString *)resource
                  inflater: (IDLLayoutInflater *) inflater;

- (void) setLayoutURL: (NSURL *)url
             inflater: (IDLLayoutInflater *) inflater;

@end

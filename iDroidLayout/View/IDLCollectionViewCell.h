//
//  IDLCollectionViewCell.h
//  iDroidLayout
//
//  Created by Jose Rojas on 3/31/15.
//  Copyright (c) 2015 Jose Rojas.
//

#import <UIKit/UIKit.h>
#import "IDLLayoutBridge.h"

@class IDLLayoutInflater;

@interface IDLCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic, readonly) IDLLayoutBridge *layoutBridge;
@property (strong, nonatomic) NSURL *layoutURL;

- (void) setLayoutResource: (NSString *)resource;

- (void) setLayoutResource: (NSString *)resource
                  inflater: (IDLLayoutInflater *) inflater;

- (void) setLayoutURL: (NSURL *)url
             inflater: (IDLLayoutInflater *) inflater;

@end

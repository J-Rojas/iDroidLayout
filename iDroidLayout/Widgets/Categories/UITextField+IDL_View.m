//
// Created by Jose Rojas on 4/9/15.
//

#import "UITextField+IDL_View.h"
#import "UIView+IDL_Layout.h"


@implementation UITextField (IDL_View)

- (void)setupFromAttributes:(NSDictionary *)attrs {

    [super setupFromAttributes:attrs];

    //placeholder
    self.placeholder = attrs[@"hint"];
}

@end
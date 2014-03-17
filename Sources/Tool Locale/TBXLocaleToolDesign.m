//
//  TBXLocaleToolDesign.m
//  Toolbox
//
//  Created by Martin Kiss on 17.3.14.
//  Copyright (c) 2014 Triceratops Software s.r.o. All rights reserved.
//

#import "TBXLocaleToolDesign.h"










@implementation TBXLocaleToolDesign





- (instancetype)init {
    self = [super init];
    if (self) {
        
        self->_workingLocale = [NSLocale currentLocale];
        self->_title = @"Locale";
        
        [[OCAProperty(self, workingLocale, NSLocale) transformValues:
         [OCATransformer objectForKey:NSLocaleCountryCode],
          nil] connectTo:OCAProperty(self, subtitle, NSString)];
    }
    return self;
}





@end



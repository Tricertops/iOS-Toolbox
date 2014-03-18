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
        
        self->_workingLocaleDesign = [[TBXLocaleDesign alloc] init];
        self->_displayLocaleDesign = [[TBXLocaleDesign alloc] init];
        
        [OCAProperty(self, displayLocaleDesign.locale, NSLocale) connectTo:OCAProperty(self, workingLocaleDesign.displayLocale, NSLocale)];
        
        [OCAProperty(self, workingLocaleDesign.countryCode, NSString) connectTo:OCAProperty(self, titleSymbol, NSString)];
    }
    return self;
}





@end



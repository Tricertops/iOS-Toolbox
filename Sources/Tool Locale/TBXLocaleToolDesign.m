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
        
        [[[OCAHub combine:
          OCAProperty(self, workingLocaleDesign.countryCode, NSString),
          OCAProperty(self, workingLocaleDesign.languageCode, NSString),
          nil] transformValues:
          [OCATransformer removeNullsFromArray], // In case the countryCode is missing, will use languageCode
          [OCATransformer objectAtIndex:0],
          nil] connectTo:OCAProperty(self, titleSymbol, NSString)];
    }
    return self;
}





@end



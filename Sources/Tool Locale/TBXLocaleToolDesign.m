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
        
        [[OCAProperty(self, workingLocale, NSLocale) transformValues:
         [OCATransformer objectForKey:NSLocaleCountryCode],
          nil] connectTo:OCAProperty(self, representation, NSString)];
        
        [[OCAProperty(self, workingLocale, NSLocale) transformValues:
          [OCATransformer branchArray:@[
                                        [self.class transformLocaleToDisplayNameForKey:NSLocaleLanguageCode],
                                        [self.class transformLocaleToDisplayNameForKey:NSLocaleCountryCode],
                                        [self.class transformLocaleToDisplayNameForKey:NSLocaleVariantCode],
                                        ]],
          [OCATransformer formatString:@"%@ (%@)"],
          nil] connectTo:OCAProperty(self, workingLocaleTitle, NSString)];
        
        [[OCAProperty(self, workingLocale, NSLocale) transformValues:
          [OCATransformer objectForKey:NSLocaleIdentifier],
          nil] connectTo:OCAProperty(self, workingLocaleSubtitle, NSString)];
    }
    return self;
}


+ (NSValueTransformer *)transformLocaleToDisplayNameForKey:(NSString *)key {
    return [OCATransformer fromClass:[NSLocale class] toClass:[NSString class]
                           asymetric:^NSString *(NSLocale *input) {
                               
                               id value = [input objectForKey:key];
                               return [[NSLocale currentLocale] displayNameForKey:key value:value];
                           }];
}





@end



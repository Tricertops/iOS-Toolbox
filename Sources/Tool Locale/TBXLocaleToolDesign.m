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
          nil] connectTo:OCAProperty(self, workingRepresentation, NSString)];
        
        [[OCAProperty(self, workingLocale, NSLocale) transformValues:
          [self.class transformLocaleToDisplayNameForKey:NSLocaleIdentifier],
          nil] connectTo:OCAProperty(self, workingTitle, NSString)];
        
        [[OCAProperty(self, workingLocale, NSLocale) transformValues:
          [OCATransformer objectForKey:NSLocaleIdentifier],
          nil] connectTo:OCAProperty(self, workingSubtitle, NSString)];
        
        self->_componentTitles = @[
                                   @"Identifier",
                                   @"Language",
                                   @"Country",
                                   @"Script",
                                   @"Variant",
                                   @"Currency",
                                   @"Currency Code",
                                   @"Currency Symbol",
                                   @"Measurement System",
                                   @"Decimal Separator",
                                   @"Grouping Separator",
                                   ];
        self->_componentCount = self.componentTitles.count;
        [[OCAProperty(self, workingLocale, NSLocale) transformValues:
          [OCATransformer branchArray:@[
                                        [OCATransformer objectForKey:NSLocaleIdentifier],
                                        [self.class transformLocaleToDisplayNameForKey:NSLocaleLanguageCode],
                                        [self.class transformLocaleToDisplayNameForKey:NSLocaleCountryCode],
                                        [self.class transformLocaleToDisplayNameForKey:NSLocaleScriptCode],
                                        [self.class transformLocaleToDisplayNameForKey:NSLocaleVariantCode],
                                        [self.class transformLocaleToDisplayNameForKey:NSLocaleCurrencyCode],
                                        [OCATransformer objectForKey:NSLocaleCurrencyCode],
                                        [OCATransformer objectForKey:NSLocaleCurrencySymbol],
                                        [OCATransformer objectForKey:NSLocaleMeasurementSystem],
                                        [OCATransformer objectForKey:NSLocaleDecimalSeparator],
                                        [OCATransformer sequence:@[
                                                                   [OCATransformer objectForKey:NSLocaleGroupingSeparator],
                                                                   [OCATransformer if:[OCAPredicate isIn:@"  "] // SPACE, NO-BREAK SPACE
                                                                    then:[OCATransformer replaceWith:@"(space)"]
                                                                    else:[OCATransformer pass]],
                                                                   ]],
                                        ]],
          nil] connectTo:OCAProperty(self, componentValues, NSArray)];
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



//
//  TBXLocaleChooserDesign.m
//  Toolbox
//
//  Created by Martin Kiss on 17.3.14.
//  Copyright (c) 2014 Triceratops Software s.r.o. All rights reserved.
//

#import "TBXLocaleChooserDesign.h"





@implementation TBXLocaleChooserDesign





- (instancetype)initWithLocale:(NSLocale *)locale {
    self = [super init];
    if (self) {
        self->_initialLocale = locale;
        self->_availableLocales = [[NSLocale availableLocaleIdentifiers]
                                   map:^NSLocale *(NSString *identifier) {
                                       return [NSLocale localeWithLocaleIdentifier:identifier];
                                   }];
        self->_chosenLocale = locale;
        
        [[OCANotificator notify:NSCurrentLocaleDidChangeNotification] invoke:OCAInvocation(self, updateSystemLocale)];
        
        [[OCAProperty(self, systemLocale, NSLocale) transformValues:
         [self.class transformLocaleToDisplayNameForKey:NSLocaleIdentifier],
          nil] connectTo:OCAProperty(self, systemLocaleTitle, NSString)];
        
        [[OCAProperty(self, systemLocale, NSLocale) transformValues:
          [OCATransformer objectForKey:NSLocaleIdentifier],
          nil] connectTo:OCAProperty(self, systemLocaleSubtitle, NSString)];
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


- (void)updateSystemLocale {
    self.systemLocale = [NSLocale currentLocale];
}


- (NSString *)titleOfLocaleAtIndex:(NSUInteger)index {
    NSLocale *locale = [self.availableLocales objectAtIndex:index];
    return [[NSLocale currentLocale] displayNameForKey:NSLocaleIdentifier value:locale.localeIdentifier];
}


- (NSString *)subtitleOfLocaleAtIndex:(NSUInteger)index {
    NSLocale *locale = [self.availableLocales objectAtIndex:index];
    return locale.localeIdentifier;
}





@end



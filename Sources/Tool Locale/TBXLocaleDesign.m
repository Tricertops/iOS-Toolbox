//
//  TBXLocaleDesign.m
//  Toolbox
//
//  Created by Martin Kiss on 18.3.14.
//  Copyright (c) 2014 Triceratops Software s.r.o. All rights reserved.
//

#import "TBXLocaleDesign.h"





@implementation TBXLocaleDesign





- (instancetype)init {
    self = [super init];
    if (self) {
        self->_locale = [NSLocale currentLocale];
        self->_displayLocale = [NSLocale currentLocale];
        
        OCAProperty *locale = OCAProperty(self, locale, NSLocale);
        OCAProducer *localeForDisplay = [locale dependOn:OCAProperty(self, displayLocale, NSLocale), nil];
        
        
        
        [[locale transformValues:
          [OCATransformer objectForKey:NSLocaleIdentifier],
          nil] connectTo:OCAProperty(self, identifier, NSString)];
        
        [[[locale dependOn:[OCANotificator notify:NSCurrentLocaleDidChangeNotification], nil]
          transformValues:
          [OCATransformer evaluatePredicate:[OCAPredicate isEqualTo:[NSLocale autoupdatingCurrentLocale]]],
          nil] connectTo:OCAProperty(self, isCurrentLocale, BOOL)];
        
        [[OCAProperty(self, identifier, NSString) transformValues:
          [OCATransformer fromClass:[NSString class] toClass:[NSNumber class]
                          asymetric:^NSNumber *(NSString *input) {
                              uint32_t code = [NSLocale windowsLocaleCodeFromLocaleIdentifier:input];
                              return @(code);
                          }],
          nil] connectTo:OCAProperty(self, windowsCode, NSUInteger)];
        
        [[localeForDisplay transformValues:
          [self transformLocaleToDisplayNameForKey:NSLocaleIdentifier],
          nil] connectTo:OCAProperty(self, title, NSString)];
        
        
        
        [[locale transformValues:
          [OCATransformer objectForKey:NSLocaleLanguageCode],
          nil] connectTo:OCAProperty(self, languageCode, NSString)];
        
        [[localeForDisplay transformValues:
          [self transformLocaleToDisplayNameForKey:NSLocaleLanguageCode],
          nil] connectTo:OCAProperty(self, languageName, NSString)];
        
        [[locale transformValues:
          [OCATransformer objectForKey:NSLocaleCountryCode],
          nil] connectTo:OCAProperty(self, countryCode, NSString)];
        
        [[localeForDisplay transformValues:
          [self transformLocaleToDisplayNameForKey:NSLocaleCountryCode],
          nil] connectTo:OCAProperty(self, countryName, NSString)];
        
        [[locale transformValues:
          [OCATransformer objectForKey:NSLocaleVariantCode],
          nil] connectTo:OCAProperty(self, variantCode, NSString)];
        
        
        
        [[locale transformValues:
          [OCATransformer objectForKey:NSLocaleScriptCode],
          nil] connectTo:OCAProperty(self, scriptCode, NSString)];
        
        [[OCAProperty(self, languageCode, NSString) transformValues:
          [OCATransformer fromClass:[NSString class] toClass:[NSNumber class]
                          asymetric:^NSNumber *(NSString *input) {
                              NSLocaleLanguageDirection direction = [NSLocale lineDirectionForLanguage:input];
                              return @(direction);
                          }],
          nil] connectTo:OCAProperty(self, lineDirection, NSUInteger)];
        
        [[OCAProperty(self, languageCode, NSString) transformValues:
          [OCATransformer fromClass:[NSString class] toClass:[NSNumber class]
                          asymetric:^NSNumber *(NSString *input) {
                              NSLocaleLanguageDirection direction = [NSLocale characterDirectionForLanguage:input];
                              return @(direction);
                          }],
          nil] connectTo:OCAProperty(self, characterDirection, NSUInteger)];
        
        [[locale transformValues:
          [OCATransformer objectForKey:NSLocaleExemplarCharacterSet],
          [self transformCharacterSetToString],
          nil] connectTo:OCAProperty(self, exemplarCharacters, NSString)];
        
        
        
        [[locale transformValues:
          [OCATransformer objectForKey:NSLocaleCalendar],
          [OCATransformer access:OCAKeyPath(NSCalendar, calendarIdentifier, NSString)],
          [OCATransformer map:@{
                                NSGregorianCalendar: @"Gregorian",
                                NSBuddhistCalendar: @"Buddhist",
                                NSChineseCalendar: @"Chinese",
                                NSHebrewCalendar: @"Hebrew",
                                NSIslamicCalendar: @"Islamic",
                                NSIslamicCivilCalendar: @"Islamic Civil",
                                NSJapaneseCalendar: @"Japanese",
                                NSRepublicOfChinaCalendar: @"Taiwan",
                                NSPersianCalendar: @"Persian",
                                NSIndianCalendar: @"Indian",
                                NSISO8601Calendar: @"ISO-8601",
                                NSNull.null : @"(unknown)",
                                }],
          nil] connectTo:OCAProperty(self, calendarName, NSString)];
        
        OCAProducer *timedCalendarProducer = [[locale transformValues:
                                     [OCATransformer objectForKey:NSLocaleCalendar],
                                     nil] dependOn:[OCATimer timerWithInterval:1 owner:self], nil];
        
        [[timedCalendarProducer transformValues:
          [self transformCalendarToDateWithStyle:NSDateFormatterShortStyle],
          nil] connectTo:OCAProperty(self, shortDate, NSString)];
        
        [[timedCalendarProducer transformValues:
          [self transformCalendarToDateWithStyle:NSDateFormatterMediumStyle],
          nil] connectTo:OCAProperty(self, mediumDate, NSString)];
        
        [[timedCalendarProducer transformValues:
          [self transformCalendarToDateWithStyle:NSDateFormatterLongStyle],
          nil] connectTo:OCAProperty(self, longDate, NSString)];
        
        [[timedCalendarProducer transformValues:
          [self transformCalendarToDateWithStyle:NSDateFormatterFullStyle],
          nil] connectTo:OCAProperty(self, fullDate, NSString)];
    }
    return self;
}


- (NSValueTransformer *)transformLocaleToDisplayNameForKey:(NSString *)key {
    return [OCATransformer fromClass:[NSLocale class] toClass:[NSString class]
                           asymetric:^NSString *(NSLocale *input) {
                               
                               id value = [input objectForKey:key];
                               return [self.displayLocale displayNameForKey:key value:value];
                           }];
}


- (NSValueTransformer *)transformCharacterSetToString {
    return [OCATransformer fromClass:[NSCharacterSet class] toClass:[NSString class]
                           transform:^NSString *(NSCharacterSet *input) {
                               
                               NSMutableString *characters = [[NSMutableString alloc] init];
                               
                               for (unichar c = 0; c < USHRT_MAX; c++) {
                                   if ([input characterIsMember:c]) {
                                       NSString *s = [NSString stringWithCharacters:&c length:1];
                                       BOOL isLowercase = [[s lowercaseString] isEqualToString:s];
                                       if (isLowercase) {
                                           [characters appendString:s];
                                       }
                                   }
                               }
                               
                               return characters;
                               
                           } reverse:^NSCharacterSet *(NSString *input) {
                               return [NSCharacterSet characterSetWithCharactersInString:input];
                           }];
}


- (NSValueTransformer *)transformCalendarToDateWithStyle:(NSDateFormatterStyle)style {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = style;
    return [OCATransformer fromClass:[NSCalendar class] toClass:[NSString class]
                           asymetric:^NSString *(NSCalendar *input) {
                               formatter.calendar = input;
                               formatter.locale = input.locale;
                               return [formatter stringFromDate:[NSDate date]];
                           }];
}





@end



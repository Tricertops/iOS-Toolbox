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
          [self transformCharacterSetToStringSorted:YES],
          nil] connectTo:OCAProperty(self, exemplarCharacters, NSString)];
        
        
        OCATransformer *transformLocaleToQuotedString = [OCATransformer sequence:
                                                         @[
                                                           [OCATransformer objectForKey:NSLocaleExemplarCharacterSet],
                                                           [self transformCharacterSetToStringSorted:YES],
                                                           [OCATransformer substringToIndex:5],
                                                           ]];
        
        [[locale transformValues:
          [OCATransformer branchArray:@[
                                        [OCATransformer objectForKey:NSLocaleQuotationBeginDelimiterKey],
                                        transformLocaleToQuotedString,
                                        [OCATransformer objectForKey:NSLocaleQuotationEndDelimiterKey],
                                        ]],
          [OCATransformer removeNullsFromArray],
          [OCATransformer joinWithString:@""], // Result: “abc”
          nil] connectTo:OCAProperty(self, quotationExample, NSString)];
        
        [[locale transformValues:
          [OCATransformer branchArray:@[
                                        [OCATransformer objectForKey:NSLocaleAlternateQuotationBeginDelimiterKey],
                                        transformLocaleToQuotedString,
                                        [OCATransformer objectForKey:NSLocaleAlternateQuotationEndDelimiterKey],
                                        ]],
          [OCATransformer removeNullsFromArray],
          [OCATransformer joinWithString:@""], // Result: ‘abc’
          nil] connectTo:OCAProperty(self, alternateQuotationExample, NSString)];
        
        
        
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
        
        
        
        [[locale transformValues:
          [OCATransformer objectForKey:NSLocaleMeasurementSystem],
          nil] connectTo:OCAProperty(self, measurementSystem, NSString)];
        
        [[locale transformValues:
          [OCATransformer objectForKey:NSLocaleDecimalSeparator],
          [OCATransformer map:@{
                                @".": @"Dot",
                                @",": @"Comma",
                                }],
          nil] connectTo:OCAProperty(self, decimalSeparator, NSString)];
        
        [[locale transformValues:
          [OCATransformer objectForKey:NSLocaleGroupingSeparator],
          [OCATransformer map:@{
                                @".": @"Dot",
                                @",": @"Comma",
                                @" ": @"Space",
                                @"'": @"Apostrophe",
                                NSNull.null: @"None",
                                }],
          nil] connectTo:OCAProperty(self, groupingSeparator, NSString)];
        
        [[locale transformValues:
          [self transformLocaleToFormattedNumber:@12345.6789 style:NSNumberFormatterDecimalStyle],
          nil] connectTo:OCAProperty(self, numberExample, NSString)];
        
        
        
        [[locale transformValues:
          [OCATransformer objectForKey:NSLocaleCurrencyCode],
          [OCATransformer replaceNil:@"(none)"],
          nil] connectTo:OCAProperty(self, currencyCode, NSString)];
        
        [[localeForDisplay transformValues:
          [self transformLocaleToDisplayNameForKey:NSLocaleCurrencyCode],
          [OCATransformer replaceNil:@"(none)"],
          nil] connectTo:OCAProperty(self, currencyName, NSString)];
        
        [[locale transformValues:
          [OCATransformer objectForKey:NSLocaleCurrencySymbol],
          nil] connectTo:OCAProperty(self, currencySymbol, NSString)];
        
        [[locale transformValues:
          [self transformLocaleToFormattedNumber:@1 style:NSNumberFormatterCurrencyStyle],
          nil] connectTo:OCAProperty(self, currencyExample, NSString)];
    }
    return self;
}


- (NSValueTransformer *)transformLocaleToDisplayNameForKey:(NSString *)key {
    OCAWeakify(self);
    return [OCATransformer fromClass:[NSLocale class] toClass:[NSString class]
                           asymetric:^NSString *(NSLocale *input) {
                               OCAStrongify(self);
                               
                               id value = [input objectForKey:key];
                               return [self.displayLocale displayNameForKey:key value:value];
                           }];
}


- (NSValueTransformer *)transformCharacterSetToStringSorted:(BOOL)sorted {
    OCAWeakify(self);
    return [OCATransformer fromClass:[NSCharacterSet class] toClass:[NSString class]
                           transform:^NSString *(NSCharacterSet *input) {
                               OCAStrongify(self);
                               
                               NSMutableArray *characters = [[NSMutableArray alloc] init];
                               
                               for (unichar c = 0; c < USHRT_MAX; c++) {
                                   if ([input characterIsMember:c]) {
                                       NSString *s = [NSString stringWithCharacters:&c length:1];
                                       BOOL isLowercase = [[s lowercaseString] isEqualToString:s];
                                       if (isLowercase) {
                                           [characters addObject:s];
                                       }
                                   }
                               }
                               
                               if (sorted) {
                                   [characters sortUsingComparator:^NSComparisonResult(NSString *stringA, NSString *stringB) {
                                       NSComparisonResult result =  [stringA compare:stringB
                                                                             options:(NSCaseInsensitiveSearch | NSForcedOrderingSearch)
                                                                               range:NSMakeRange(0, 1)
                                                                              locale:self.locale];
                                       return result;
                                   }];
                               }
                               
                               return [characters join:@""];
                               
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


- (NSValueTransformer *)transformLocaleToFormattedNumber:(NSNumber *)number style:(NSNumberFormatterStyle)style {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = style;
    formatter.maximumFractionDigits = 5;
    return [OCATransformer fromClass:[NSLocale class] toClass:[NSString class]
                           asymetric:^NSString *(NSLocale *input) {
                               formatter.locale = input;
                               return [formatter stringFromNumber:number];
                           }];
}





@end



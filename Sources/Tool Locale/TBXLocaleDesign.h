//
//  TBXLocaleDesign.h
//  Toolbox
//
//  Created by Martin Kiss on 18.3.14.
//  Copyright (c) 2014 Triceratops Software s.r.o. All rights reserved.
//

@import Foundation.NSObject;
@import Foundation.NSLocale;





@interface TBXLocaleDesign : NSObject


@property (atomic, readwrite, strong) NSLocale *locale;
@property (atomic, readwrite, strong) NSLocale *displayLocale;

@property (atomic, readonly, copy) NSString *identifier;
@property (atomic, readonly, assign) BOOL isCurrentLocale;
@property (atomic, readonly, assign) NSUInteger windowsCode;
@property (atomic, readonly, copy) NSString *title;

@property (atomic, readonly, copy) NSString *languageCode;
@property (atomic, readonly, copy) NSString *languageName;
@property (atomic, readonly, copy) NSString *countryCode;
@property (atomic, readonly, copy) NSString *countryName;
@property (atomic, readonly, copy) NSString *variantCode;

@property (atomic, readonly, copy) NSString *scriptCode;
@property (atomic, readonly, assign) NSLocaleLanguageDirection lineDirection;
@property (atomic, readonly, assign) NSLocaleLanguageDirection characterDirection;
@property (atomic, readonly, copy) NSString *exemplarCharacters;

@property (atomic, readonly, copy) NSString *calendarName;
@property (atomic, readonly, copy) NSString *shortDate;
@property (atomic, readonly, copy) NSString *mediumDate;
@property (atomic, readonly, copy) NSString *longDate;
@property (atomic, readonly, copy) NSString *fullDate;

@property (atomic, readonly, copy) NSString *measurementSystem;
@property (atomic, readonly, copy) NSString *decimalSeparator;
@property (atomic, readonly, copy) NSString *groupingSeparator;

@property (atomic, readonly, copy) NSString *currencyCode;
@property (atomic, readonly, copy) NSString *currencyName;
@property (atomic, readonly, copy) NSString *currencySymbol;
@property (atomic, readonly, copy) NSString *currencyExample;

@property (atomic, readonly, copy) NSString *quotationSymbols;
@property (atomic, readonly, copy) NSString *quotationExample;
@property (atomic, readonly, copy) NSString *alternateQuotationSymbols;
@property (atomic, readonly, copy) NSString *alternateQuotationExample;


@end



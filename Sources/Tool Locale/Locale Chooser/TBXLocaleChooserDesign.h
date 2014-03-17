//
//  TBXLocaleChooserDesign.h
//  Toolbox
//
//  Created by Martin Kiss on 17.3.14.
//  Copyright (c) 2014 Triceratops Software s.r.o. All rights reserved.
//

@import Foundation.NSObject;





@interface TBXLocaleChooserDesign : NSObject


- (instancetype)initWithLocale:(NSLocale *)locale;
@property (atomic, readonly, strong) NSLocale *initialLocale;

@property (atomic, readwrite, strong) NSLocale *chosenLocale;

@property (atomic, readwrite, strong) NSLocale *systemLocale;
@property (atomic, readonly, copy) NSString *systemLocaleTitle;
@property (atomic, readonly, copy) NSString *systemLocaleSubtitle;

@property (atomic, readonly, strong) NSArray *availableLocales;
- (NSString *)titleOfLocaleAtIndex:(NSUInteger)index;
- (NSString *)subtitleOfLocaleAtIndex:(NSUInteger)index;


@end



//
//  TBXLocaleToolDesign.h
//  Toolbox
//
//  Created by Martin Kiss on 17.3.14.
//  Copyright (c) 2014 Triceratops Software s.r.o. All rights reserved.
//

@import Foundation.NSObject;
@import Foundation.NSLocale;
#import "TBXLocaleChooserDesign.h"





@interface TBXLocaleToolDesign : NSObject


@property (atomic, readwrite, strong) NSLocale *workingLocale;

@property (atomic, readonly, copy) NSString *workingRepresentation;
@property (atomic, readonly, copy) NSString *workingLocaleTitle;

@property (atomic, readonly, assign) NSUInteger componentCount;
@property (atomic, readonly, copy) NSArray *componentTitles;
@property (atomic, readonly, copy) NSArray *componentValues;


- (TBXLocaleChooserDesign *)createChooserDesign;


@end



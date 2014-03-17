//
//  TBXLocaleToolDesign.h
//  Toolbox
//
//  Created by Martin Kiss on 17.3.14.
//  Copyright (c) 2014 Triceratops Software s.r.o. All rights reserved.
//

@import Foundation.NSObject;
@import Foundation.NSLocale;





@interface TBXLocaleToolDesign : NSObject




@property (atomic, readwrite, strong) NSLocale *workingLocale;

@property (atomic, readonly, strong) NSString *workingRepresentation;
@property (atomic, readonly, strong) NSString *workingTitle;
@property (atomic, readonly, strong) NSString *workingSubtitle;

@property (atomic, readonly, assign) NSUInteger componentCount;
@property (atomic, readonly, strong) NSArray *componentTitles;
@property (atomic, readonly, strong) NSArray *componentValues;


@end



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



@property (atomic, readonly, strong) NSString *representation;

@property (atomic, readwrite, strong) NSLocale *workingLocale;
@property (atomic, readonly, strong) NSString *workingLocaleTitle;
@property (atomic, readonly, strong) NSString *workingLocaleSubtitle;


@end



//
//  TBXLocaleToolDesign.h
//  Toolbox
//
//  Created by Martin Kiss on 17.3.14.
//  Copyright (c) 2014 Triceratops Software s.r.o. All rights reserved.
//

@import Foundation.NSObject;
@import Foundation.NSLocale;
#import "TBXLocaleDesign.h"
#import "TBXLocaleChooserDesign.h"





@interface TBXLocaleToolDesign : NSObject


@property (atomic, readwrite, strong) TBXLocaleDesign *workingLocaleDesign;
@property (atomic, readwrite, strong) TBXLocaleDesign *displayLocaleDesign;

@property (atomic, readonly, copy) NSString *titleSymbol;


@end



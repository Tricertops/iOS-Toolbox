//
//  TBXSection.m
//  Toolbox
//
//  Created by Martin Kiss on 18.3.14.
//  Copyright (c) 2014 Triceratops Software s.r.o. All rights reserved.
//

#import "TBXSection.h"










@implementation TBXSection





+ (instancetype)sectionWithHeader:(NSString *)header footer:(NSString *)footer cells:(UITableViewCell *)cell, ... NS_REQUIRES_NIL_TERMINATION {
    TBXSection *section = [[self alloc] init];
    section.headerTitle = header;
    section.footerTitle = footer;
    section.cells = NSArrayFromVariadicArguments(cell);
    return section;
}





@end



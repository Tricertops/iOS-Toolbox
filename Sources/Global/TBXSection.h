//
//  TBXSection.h
//  Toolbox
//
//  Created by Martin Kiss on 18.3.14.
//  Copyright (c) 2014 Triceratops Software s.r.o. All rights reserved.
//

@import UIKit.UITableViewCell;





@interface TBXSection : NSObject


+ (instancetype)sectionWithHeader:(NSString *)header footer:(NSString *)footer cells:(UITableViewCell *)cell, ... NS_REQUIRES_NIL_TERMINATION;

@property (nonatomic, readwrite, copy) NSString *headerTitle;
@property (nonatomic, readwrite, copy) NSArray *cells;
@property (nonatomic, readwrite, copy) NSString *footerTitle;


@end



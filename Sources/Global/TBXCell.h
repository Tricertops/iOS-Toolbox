//
//  TBXCell.h
//  Toolbox
//
//  Created by Martin Kiss on 17.3.14.
//  Copyright (c) 2014 Triceratops Software s.r.o. All rights reserved.
//

@import UIKit.UITableViewCell;





@interface TBXCell : UITableViewCell



+ (Class)defaultStyleCellClass;
+ (Class)rightValueStyleCellClass;
+ (Class)leftValueStyleCellClass;
+ (Class)subtitleStyleCellClass;


@property (nonatomic, readonly, strong) OCACommand *selectionCallback;



@end



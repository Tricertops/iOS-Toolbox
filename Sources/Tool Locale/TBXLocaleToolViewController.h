//
//  TBXLocaleToolViewController.h
//  Toolbox
//
//  Created by Martin Kiss on 17.3.14.
//  Copyright (c) 2014 Triceratops Software s.r.o. All rights reserved.
//

@import UIKit.UITableViewController;
#import "TBXLocaleToolDesign.h"





@interface TBXLocaleToolViewController : UITableViewController


- (instancetype)init;
- (instancetype)initWithDesign:(TBXLocaleToolDesign *)design;
@property (nonatomic, readonly, strong) TBXLocaleToolDesign *design;


@end



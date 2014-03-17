//
//  TBXLocaleChooserViewController.h
//  Toolbox
//
//  Created by Martin Kiss on 17.3.14.
//  Copyright (c) 2014 Triceratops Software s.r.o. All rights reserved.
//

@import UIKit.UITableViewController;
#import "TBXLocaleChooserDesign.h"





@interface TBXLocaleChooserViewController : UITableViewController


- (instancetype)init;
- (instancetype)initWithDesign:(TBXLocaleChooserDesign *)design;
@property (nonatomic, readonly, strong) TBXLocaleChooserDesign *design;


@end



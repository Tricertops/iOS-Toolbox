//
//  TBXLocaleToolViewController.m
//  Toolbox
//
//  Created by Martin Kiss on 17.3.14.
//  Copyright (c) 2014 Triceratops Software s.r.o. All rights reserved.
//

#import "TBXLocaleToolViewController.h"
#import "TBXCell.h"





@interface TBXLocaleToolViewController ()



@property (nonatomic, readwrite, strong) TBXCell *workingLocaleCell;



@end










@implementation TBXLocaleToolViewController





- (instancetype)init {
    return [self initWithDesign:nil];
}


- (id)initWithStyle:(__unused UITableViewStyle)style {
    return [self initWithDesign:nil];
}


- (instancetype)initWithDesign:(TBXLocaleToolDesign *)design {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self->_design = design ?: [[TBXLocaleToolDesign alloc] init];
        
        self.title = @"Locale";
        
        [[OCAProperty(self.design, representation, NSString) transformValues:
          [self.class transformStringToTabBarImage],
          nil] connectTo:OCAProperty(self, tabBarItem.image, UIImage)];
    }
    return self;
}


+ (NSValueTransformer *)transformStringToTabBarImage {
    return [OCATransformer fromClass:[NSString class] toClass:[UIImage class]
                           asymetric:^UIImage *(NSString *input) {
                               UILabel *label = [[UILabel alloc] init];
                               label.text = input;
                               label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:26];
                               label.backgroundColor = [UIColor clearColor];
                               [label sizeToFit];
                               return [label snapshot];
                           }];
}





- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.workingLocaleCell = [[TBXCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    self.workingLocaleCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [OCAProperty(self.design, workingLocaleTitle, NSString) connectTo:OCAProperty(self, workingLocaleCell.textLabel.text, NSString)];
    [OCAProperty(self.design, workingLocaleSubtitle, NSString) connectTo:OCAProperty(self, workingLocaleCell.detailTextLabel.text, NSString)];
}





- (NSInteger)tableView:(__unused UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 1;
    }
    return 0;
}


- (NSString *)tableView:(__unused UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: return @"Working Locale";
    }
    return nil;
}


- (UITableViewCell *)tableView:(__unused UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: return self.workingLocaleCell;
    }
    return nil;
}





@end



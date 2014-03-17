//
//  TBXLocaleToolViewController.m
//  Toolbox
//
//  Created by Martin Kiss on 17.3.14.
//  Copyright (c) 2014 Triceratops Software s.r.o. All rights reserved.
//

#import "TBXLocaleToolViewController.h"
#import "TBXCell.h"
#import "TBXLocaleChooserViewController.h"





@interface TBXLocaleToolViewController ()



@property (nonatomic, readwrite, strong) TBXCell *workingLocaleCell;
@property (nonatomic, readwrite, strong) NSArray *componentCells;



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
        
        [[OCAProperty(self.design, workingRepresentation, NSString) transformValues:
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
    self.workingLocaleCell.textLabel.text = @"Current";
    [OCAProperty(self.design, workingLocaleTitle, NSString) connectTo:OCAProperty(self, workingLocaleCell.detailTextLabel.text, NSString)];
    
    
    NSMutableArray *componentCells = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < self.design.componentCount; index++) {
        TBXCell *cell = [[TBXCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [[OCAProperty(self.design, componentTitles, NSArray) transformValues:
          [OCATransformer objectAtIndex:index],
          nil] connectTo:OCAProperty(cell, textLabel.text, NSString)];
        
        [[OCAProperty(self.design, componentValues, NSArray) transformValues:
          [OCATransformer objectAtIndex:index],
          nil] connectTo:OCAProperty(cell, detailTextLabel.text, NSString)];
        
        [componentCells addObject:cell];
    }
    self.componentCells = componentCells;
}





- (NSInteger)numberOfSectionsInTableView:(__unused UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(__unused UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 1;
        case 1: return self.componentCells.count;
    }
    return 0;
}


- (NSString *)tableView:(__unused UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: return @"Working Locale";
        case 1: return @"Components";
    }
    return nil;
}


- (UITableViewCell *)tableView:(__unused UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: return self.workingLocaleCell;
        case 1: return [self.componentCells objectAtIndex:indexPath.row];
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath && indexPath.section == 0 && indexPath.row == 0) {
        [self presentLocaleChooser];
    }
    else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


- (void)presentLocaleChooser {
    TBXLocaleChooserDesign *chooserDesign = [self.design createChooserDesign];
    TBXLocaleChooserViewController *localeChooser = [[TBXLocaleChooserViewController alloc] initWithDesign:chooserDesign];
    [self.navigationController pushViewController:localeChooser animated:YES];
}





@end



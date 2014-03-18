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
@property (nonatomic, readwrite, strong) TBXCell *displayLocaleCell;



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
        
        [[OCAProperty(self.design, titleSymbol, NSString) transformValues:
          [self.class transformStringToTabBarImage],
          nil] connectTo:OCAProperty(self, tabBarItem.image, UIImage)]; //TODO: Doesn't update, reason unknown.
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
    self.workingLocaleCell.textLabel.text = @"Working";
    [OCAProperty(self.design, workingLocaleDesign.title, NSString) connectTo:OCAProperty(self, workingLocaleCell.detailTextLabel.text, NSString)];
    
    self.displayLocaleCell = [[TBXCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    self.displayLocaleCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.displayLocaleCell.textLabel.text = @"Display";
    [OCAProperty(self.design, displayLocaleDesign.title, NSString) connectTo:OCAProperty(self, displayLocaleCell.detailTextLabel.text, NSString)];
    
}





- (NSInteger)numberOfSectionsInTableView:(__unused UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(__unused UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 2;
    }
    return 0;
}


- (NSString *)tableView:(__unused UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: return @"Locales";
    }
    return nil;
}


- (UITableViewCell *)tableView:(__unused UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: return self.workingLocaleCell;
                case 1: return self.displayLocaleCell;
            }
        }
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath) {
        if (indexPath.section == 0) {
            TBXLocaleChooserDesign *chooserDesign = [[TBXLocaleChooserDesign alloc] initWithLocale:self.design.workingLocaleDesign.locale];
            [OCAProperty(chooserDesign, chosenLocale, NSLocale)
             connectTo:(indexPath.row == 0
                        ? OCAProperty(self.design, workingLocaleDesign.locale, NSLocale)
                        : OCAProperty(self.design, displayLocaleDesign.locale, NSLocale))];
            
            TBXLocaleChooserViewController *localeChooser = [[TBXLocaleChooserViewController alloc] initWithDesign:chooserDesign];
            [self.navigationController pushViewController:localeChooser animated:YES];
        }
    }
    else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}





@end



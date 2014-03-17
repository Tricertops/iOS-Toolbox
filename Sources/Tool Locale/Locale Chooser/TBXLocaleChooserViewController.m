//
//  TBXLocaleChooserViewController.m
//  Toolbox
//
//  Created by Martin Kiss on 17.3.14.
//  Copyright (c) 2014 Triceratops Software s.r.o. All rights reserved.
//

#import "TBXLocaleChooserViewController.h"
#import "TBXCell.h"





@interface TBXLocaleChooserViewController ()


@property (nonatomic, readwrite, strong) TBXCell *systemLocaleCell;


@end



NSString * const TBXLocaleChooserCellReuseIdentifier = @"TBXLocaleChooserCell";










@implementation TBXLocaleChooserViewController





- (instancetype)init {
    return [self initWithDesign:nil];
}


- (instancetype)initWithStyle:(__unused UITableViewStyle)style {
    return [self initWithDesign:nil];
}


- (instancetype)initWithDesign:(TBXLocaleChooserDesign *)design {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self->_design = design ?: [[TBXLocaleChooserDesign alloc] init];
        
        self.title = @"Choose";
    }
    return self;
}





- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.systemLocaleCell = [[TBXCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    [OCAProperty(self.design, systemLocaleTitle, NSString) connectTo:OCAProperty(self.systemLocaleCell, textLabel.text, NSString)];
    [OCAProperty(self.design, systemLocaleSubtitle, NSString) connectTo:OCAProperty(self.systemLocaleCell, detailTextLabel.text, NSString)];
    
    [self.tableView registerClass:[TBXCell subtitleStyleCellClass] forCellReuseIdentifier:TBXLocaleChooserCellReuseIdentifier];
}





- (NSInteger)numberOfSectionsInTableView:(__unused UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(__unused UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 1;
        case 1: return self.design.availableLocales.count;
    }
    return 0;
}


- (NSString *)tableView:(__unused UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: return @"System Locale";
        case 1: return @"Available Locales";
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: return self.systemLocaleCell;
        case 1: {
            TBXCell *cell = [tableView dequeueReusableCellWithIdentifier:TBXLocaleChooserCellReuseIdentifier forIndexPath:indexPath];
            cell.textLabel.text = [self.design titleOfLocaleAtIndex:indexPath.row];
            cell.detailTextLabel.text = [self.design subtitleOfLocaleAtIndex:indexPath.row];
            return cell;
        }
    }
    return nil;
}


- (void)tableView:(__unused UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            self.design.chosenLocale = self.design.systemLocale;
            break;
        }
        case 1: {
            self.design.chosenLocale = [self.design.availableLocales objectAtIndex:indexPath.row];
            break;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}





@end



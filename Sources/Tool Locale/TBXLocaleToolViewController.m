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
    
    self.displayLocaleCell = [self createLocaleCellWithTitle:OCAProperty(self.design, displayLocaleDesign.title, NSString)
                                                        fade:OCAProperty(self.design, displayLocaleDesign.isCurrentLocale, BOOL)
                                           selectionProperty:OCAProperty(self.design, displayLocaleDesign.locale, NSLocale)];
    
    self.workingLocaleCell = [self createLocaleCellWithTitle:OCAProperty(self.design, workingLocaleDesign.title, NSString)
                                                        fade:OCAProperty(self.design, workingLocaleDesign.isCurrentLocale, BOOL)
                                           selectionProperty:OCAProperty(self.design, workingLocaleDesign.locale, NSLocale)];
}


- (TBXCell *)createLocaleCellWithTitle:(OCAProducer *)title fade:(OCAProducer *)fade selectionProperty:(OCAProperty *)selectionProperty {
    TBXCell *cell = [[TBXCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [title connectTo:OCAProperty(cell, textLabel.text, NSString)];
    [[fade transformValues:
      [OCATransformer ifYes:[UIColor grayColor]
                       ifNo:[UIColor blackColor]],
      nil] connectTo:OCAProperty(cell, textLabel.textColor, UIColor)];
    [cell.selectionCallback invoke:OCAInvocation(self, presentLocaleChooserForProperty:selectionProperty)];
    
    return cell;
}





- (NSInteger)numberOfSectionsInTableView:(__unused UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(__unused UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 1;
        case 1: return 1;
    }
    return 0;
}


- (NSString *)tableView:(__unused UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: return @"Display Locale";
        case 1: return @"Working Locale";
    }
    return nil;
}


- (UITableViewCell *)tableView:(__unused UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: return self.displayLocaleCell;
        case 1: return self.workingLocaleCell;
    }
    return nil;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TBXCell *cell = (TBXCell *)[[tableView cellForRowAtIndexPath:indexPath] ofClass:[TBXCell class] or:nil];
    return (cell.selectionCallback.consumers.count? indexPath : nil);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TBXCell *cell = (TBXCell *)[[tableView cellForRowAtIndexPath:indexPath] ofClass:[TBXCell class] or:nil];
    [cell.selectionCallback sendValue:nil];
}


- (void)presentLocaleChooserForProperty:(OCAProperty *)localeProperty {
    TBXLocaleChooserDesign *chooserDesign = [[TBXLocaleChooserDesign alloc] initWithLocale:localeProperty.value];
    [OCAProperty(chooserDesign, chosenLocale, NSLocale) connectTo:localeProperty];
    
    TBXLocaleChooserViewController *localeChooser = [[TBXLocaleChooserViewController alloc] initWithDesign:chooserDesign];
    [self.navigationController pushViewController:localeChooser animated:YES];
}







@end



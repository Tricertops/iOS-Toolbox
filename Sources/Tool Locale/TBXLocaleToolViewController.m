//
//  TBXLocaleToolViewController.m
//  Toolbox
//
//  Created by Martin Kiss on 17.3.14.
//  Copyright (c) 2014 Triceratops Software s.r.o. All rights reserved.
//

#import "TBXLocaleToolViewController.h"
#import "TBXCell.h"
#import "TBXSection.h"
#import "TBXLocaleChooserViewController.h"





@interface TBXLocaleToolViewController ()


@property (nonatomic, readwrite, strong) NSArray *sections;


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
          nil] invoke:OCAInvocation(self, updateTabBarImage:OCAPH(UIImage))];
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


- (void)updateTabBarImage:(UIImage *)image {
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:self.tabBarItem.title image:image tag:0];
    self.tabBarItem = item; // UIKit only observes .tabBarItem key-path, not tabBarItem.image.
}





- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *sections = [[NSMutableArray alloc] init];
    {
        TBXCell *displayLocaleCell = [self createLocaleCellWithTitle:OCAProperty(self.design, displayLocaleDesign.title, NSString)
                                                            subtitle:OCAProperty(self.design, displayLocaleDesign.identifier, NSString)
                                                                fade:OCAProperty(self.design, displayLocaleDesign.isCurrentLocale, BOOL)
                                                   selectionProperty:OCAProperty(self.design, displayLocaleDesign.locale, NSLocale)];
        TBXSection *displayLocaleSection = [TBXSection sectionWithHeader:@"Display Locale"
                                                                  footer:nil
                                                                   cells:displayLocaleCell, nil];
        [sections addObject:displayLocaleSection];
    }
    {
        TBXCell *workingLocaleCell = [self createLocaleCellWithTitle:OCAProperty(self.design, workingLocaleDesign.title, NSString)
                                                            subtitle:OCAProperty(self.design, workingLocaleDesign.identifier, NSString)
                                                                fade:OCAProperty(self.design, workingLocaleDesign.isCurrentLocale, BOOL)
                                                   selectionProperty:OCAProperty(self.design, workingLocaleDesign.locale, NSLocale)];
        TBXSection *workingLocaleSection = [TBXSection sectionWithHeader:@"Working Locale"
                                                                  footer:nil
                                                                   cells:workingLocaleCell, nil];
        [sections addObject:workingLocaleSection];
    }
    {
        TBXCell *languageCell = [[TBXCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        languageCell.textLabel.text = @"Language";
        [[[OCAHub combine:
         OCAProperty(self.design, workingLocaleDesign.languageName, NSString),
         OCAProperty(self.design, workingLocaleDesign.languageCode, NSString),
         nil] transformValues:
        [OCATransformer formatString:@"%@ (%@)"],
         nil] connectTo:OCAProperty(languageCell, detailTextLabel.text, NSString)];
        
        TBXCell *countryCell = [[TBXCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        countryCell.textLabel.text = @"Country";
        [[[OCAHub combine:
           OCAProperty(self.design, workingLocaleDesign.countryName, NSString),
           [OCAProperty(self.design, workingLocaleDesign.countryCode, NSString) transformValues:
            [OCATransformer replaceNil:@"none"], nil],
           nil] transformValues:
          [OCATransformer formatString:@"%@ (%@)"],
          nil] connectTo:OCAProperty(countryCell, detailTextLabel.text, NSString)];
        
        TBXCell *variantCell = [[TBXCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        variantCell.textLabel.text = @"Variant";
        [[OCAProperty(self.design, workingLocaleDesign.variantCode, NSString) transformValues:
          [OCATransformer if:[OCAPredicate isEmpty] then:[OCATransformer replaceWith:@"(none)"] else:nil],
          nil] connectTo:OCAProperty(variantCell, detailTextLabel.text, NSString)];
        
        TBXSection *componentsSection = [TBXSection sectionWithHeader:@"   Components"
                                                               footer:nil
                                                                cells:languageCell, countryCell, variantCell, nil];
        [sections addObject:componentsSection];
    }
    {
        TBXCell *scriptCell = [[TBXCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        scriptCell.textLabel.text = @"Script";
        [[OCAProperty(self.design, workingLocaleDesign.scriptCode, NSString) transformValues:
          [OCATransformer if:[OCAPredicate isEmpty] then:[OCATransformer replaceWith:@"(none)"] else:nil],
          nil] connectTo:OCAProperty(scriptCell, detailTextLabel.text, NSString)];
        
        NSDictionary *directionMapping = @{
                                           NSNull.null: @"(unknown)",
                                           @(NSLocaleLanguageDirectionUnknown): @"(unknown)",
                                           @(NSLocaleLanguageDirectionLeftToRight): @"→",
                                           @(NSLocaleLanguageDirectionRightToLeft): @"←",
                                           @(NSLocaleLanguageDirectionTopToBottom): @"↓",
                                           @(NSLocaleLanguageDirectionBottomToTop): @"↑",
                                           };
        
        TBXCell *characterDirectionCell = [[TBXCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        characterDirectionCell.textLabel.text = @"Character Direction";
        [[OCAProperty(self.design, workingLocaleDesign.characterDirection, NSLocaleLanguageDirection) transformValues:
          [OCATransformer map:directionMapping],
          nil] connectTo:OCAProperty(characterDirectionCell, detailTextLabel.text, NSString)];
        
        TBXCell *lineDirectionCell = [[TBXCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        lineDirectionCell.textLabel.text = @"Line Direction";
        [[OCAProperty(self.design, workingLocaleDesign.lineDirection, NSLocaleLanguageDirection) transformValues:
          [OCATransformer map:directionMapping],
          nil] connectTo:OCAProperty(lineDirectionCell, detailTextLabel.text, NSString)];
        
        TBXCell *exemplarCharactersCell = [[TBXCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        exemplarCharactersCell.textLabel.text = @"Exemplar Characters";
        exemplarCharactersCell.textLabel.font = lineDirectionCell.textLabel.font;
        exemplarCharactersCell.detailTextLabel.textColor = lineDirectionCell.detailTextLabel.textColor;
        
        [OCAProperty(self.design, workingLocaleDesign.exemplarCharacters, NSString)
         connectTo:OCAProperty(exemplarCharactersCell, detailTextLabel.text, NSString)];
        
        TBXSection *writingSection = [TBXSection sectionWithHeader:@"   Writing"
                                                               footer:nil
                                                                cells:scriptCell, characterDirectionCell, lineDirectionCell, exemplarCharactersCell, nil];
        [sections addObject:writingSection];
    }
    self.sections = sections;
}


- (TBXCell *)createLocaleCellWithTitle:(OCAProducer *)title subtitle:(OCAProducer *)subtitle fade:(OCAProducer *)fade selectionProperty:(OCAProperty *)selectionProperty {
    TBXCell *cell = [[TBXCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [title connectTo:OCAProperty(cell, textLabel.text, NSString)];
    [subtitle connectTo:OCAProperty(cell, detailTextLabel.text, NSString)];
    
    [[fade transformValues:
      [OCATransformer ifYes:[UIColor grayColor]
                       ifNo:[UIColor blackColor]],
      nil] connectToMany:
     OCAProperty(cell, textLabel.textColor, UIColor),
     OCAProperty(cell, detailTextLabel.textColor, UIColor),
     nil];
    
    [cell.selectionCallback invoke:OCAInvocation(self, presentLocaleChooserForProperty:selectionProperty)];
    
    return cell;
}





- (NSInteger)numberOfSectionsInTableView:(__unused UITableView *)tableView {
    return self.sections.count;
}


- (NSInteger)tableView:(__unused UITableView *)tableView numberOfRowsInSection:(NSInteger)index {
    TBXSection *section = [self.sections objectAtIndex:index];
    return section.cells.count;
}


- (NSString *)tableView:(__unused UITableView *)tableView titleForHeaderInSection:(NSInteger)index {
    TBXSection *section = [self.sections objectAtIndex:index];
    return section.headerTitle;
}


- (NSString *)tableView:(__unused UITableView *)tableView titleForFooterInSection:(NSInteger)index {
    TBXSection *section = [self.sections objectAtIndex:index];
    return section.footerTitle;
}


- (UITableViewCell *)tableView:(__unused UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TBXSection *section = [self.sections objectAtIndex:indexPath.section];
    return [section.cells objectAtIndex:indexPath.row];
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



//
//  TBXCell.m
//  Toolbox
//
//  Created by Martin Kiss on 17.3.14.
//  Copyright (c) 2014 Triceratops Software s.r.o. All rights reserved.
//

#import "TBXCell.h"





@interface TBXDefaultStyleCell : TBXCell @end
@interface TBXRightValueStyleCell : TBXCell @end
@interface TBXLeftValueStyleCell : TBXCell @end
@interface TBXSubtitleStyleCell : TBXCell @end





@interface TBXCell ()

@end










@implementation TBXCell





+ (Class)defaultStyleCellClass {
    return [TBXDefaultStyleCell class];
}


+ (Class)rightValueStyleCellClass {
    return [TBXRightValueStyleCell class];
}


+ (Class)leftValueStyleCellClass {
    return [TBXLeftValueStyleCell class];
}


+ (Class)subtitleStyleCellClass {
    return [TBXSubtitleStyleCell class];
}





- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self->_selectionCallback = [OCACommand commandForClass:nil];
        //TODO: Set selection style only if selection callback has consumers.
    }
    return self;
}





@end










@implementation TBXDefaultStyleCell

- (id)initWithStyle:(__unused UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}

@end





@implementation TBXRightValueStyleCell

- (id)initWithStyle:(__unused UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
}

@end





@implementation TBXLeftValueStyleCell

- (id)initWithStyle:(__unused UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
}

@end





@implementation TBXSubtitleStyleCell

- (id)initWithStyle:(__unused UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
}

@end



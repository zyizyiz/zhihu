//
//  BannerImageView.m
//  zhihu
//
//  Created by 张义镇 on 2018/5/7.
//  Copyright © 2018年 zyiz. All rights reserved.
//

#import "BannerImageView.h"
@interface BannerImageView()

@property (nonatomic,strong)UILabel *titleLabel;
@end
@implementation BannerImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [UILabel new];
        [self addSubview:self.titleLabel];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.sd_layout.centerXEqualToView(self).leftSpaceToView(self,25).rightSpaceToView(self, 25).bottomSpaceToView(self, 35);
    }
    return self;
}

- (void)setModel:(Top_storiesModel *)model{
    _model = model;
    [self sd_setImageWithURL:[NSURL URLWithString:model.image]];
    self.titleLabel.text = model.title;
}
@end

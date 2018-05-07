//
//  BannerView.m
//  zhihu
//
//  Created by 张义镇 on 2018/5/7.
//  Copyright © 2018年 zyiz. All rights reserved.
//

#import "BannerView.h"
#import "Top_storiesModel.h"
#import "BannerImageView.h"

@interface BannerView()<UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic,strong)NSMutableArray *imageViews;


@end
@implementation BannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc]init];
        [self addSubview:self.scrollView];
        self.scrollView.pagingEnabled = true;
        self.scrollView.bounces = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        
        self.pageControl = [[UIPageControl alloc]init];
        [self addSubview:self.pageControl];
        
        self.scrollView.sd_layout.topSpaceToView(self, 0).leftSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
        
        self.pageControl.sd_layout.centerXEqualToView(self.scrollView).widthIs(60).heightIs(15).bottomSpaceToView(self, 10);
    }
    return self;
}

- (void)setImages:(NSArray *)images{
    _images = images;
    
    self.pageControl.numberOfPages = images.count;
    
    for (Top_storiesModel *model in images) {
        BannerImageView *banner = [[BannerImageView alloc]init];
        banner.model = model;
       
        [self.scrollView addSubview:banner];
        
        if (self.images.count==0) {
            banner.sd_layout.topSpaceToView(self.scrollView, 10).leftSpaceToView(self.scrollView, 0).bottomSpaceToView(self.scrollView, 0).widthEqualToHeight(self.scrollView,1);
        }
        [self.imageViews addObject:banner];
        
    }
}

#pragma mark -- 懒加载
- (NSMutableArray *)imageViews{
    if (!_imageViews) {
        _imageViews = [NSMutableArray new];
    }
    return _imageViews;
}

@end

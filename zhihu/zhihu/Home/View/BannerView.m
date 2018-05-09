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
@property (nonatomic,strong)NSTimer *timer;


@end
@implementation BannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc]init];
        [self addSubview:self.scrollView];
        //是否开启平移
        self.scrollView.pagingEnabled = true;
        //是否开启回弹动画
        self.scrollView.bounces = NO;
        //是否显⽰示⽔水平滚动条
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.delegate = self;
        
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
            banner.sd_layout.topSpaceToView(self.scrollView, 0).leftSpaceToView(self.scrollView, 0).bottomSpaceToView(self.scrollView, 0).widthRatioToView(self.scrollView, 1);
        }else{
            //将图片加到前一张图片后面
            banner.sd_layout.topSpaceToView(self.scrollView, 0).leftSpaceToView([self.imageViews lastObject], 0).bottomSpaceToView(self.scrollView, 0).widthRatioToView(self.scrollView,1);
        }
        [self.imageViews addObject:banner];
        //设置scrollView可滚动的区域
        self.scrollView.contentSize = CGSizeMake(self.imageViews.count*self.width, self.height);
        
    }
    [self addTimer];
}

#pragma mark -- 滑动轮播图 设置pageControl当前的点
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat xOffset = scrollView.contentOffset.x;
    int currentPage = (int)(xOffset / self.width + 0.5);
    self.pageControl.currentPage = currentPage;
}

#pragma mark -- 当手动滑动的时候取消定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self addTimer];
}


#pragma mark -- 设置定时器
-(void)addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextImg) userInfo:nil repeats:YES];
}
-(void)nextImg{
    
    NSInteger page = (self.pageControl.currentPage + 1) % self.pageControl.numberOfPages;
    //self.pageControl.currentPage = page;
    //设置图片滚动
    CGFloat xOffset = page * self.width;
    [self.scrollView setContentOffset:CGPointMake(xOffset, 0) animated:YES];
}


#pragma mark -- 懒加载
- (NSMutableArray *)imageViews{
    if (!_imageViews) {
        _imageViews = [NSMutableArray new];
    }
    return _imageViews;
}

@end

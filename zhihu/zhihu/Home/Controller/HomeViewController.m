//
//  HomeViewController.m
//  zhihu
//
//  Created by 张义镇 on 2018/5/7.
//  Copyright © 2018年 zyiz. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "NewsLatestModel.h"
#import "StoriesModel.h"
#import "BannerView.h"

#define CELLID @"HomeCell"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *newsArray;

@property (nonatomic,strong)NewsLatestModel *lastModel;

@property (nonatomic,strong)BannerView *bannerView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bannerView];
    
    self.bannerView.sd_layout.topSpaceToView(self.view, 0).leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).heightIs(220);
    
    [self getLates];
}

#pragma mark -- 懒加载
- (BannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[BannerView alloc]init];
    }
    return _bannerView;
}


#pragma mark -- 获取知乎最新新闻
-(void)getLates {
    [[AFHTTPSessionManager manager] GET:@"https://news-at.zhihu.com/api/4/news/latest" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [NewsLatestModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"stories" : @"StoriesModel",
                     @"top_stories" : @"Top_storiesModel"
                     };
        }];
        NewsLatestModel *news = [NewsLatestModel mj_objectWithKeyValues:responseObject];
        self.newsArray = news.stories.mutableCopy;
        self.lastModel = news;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark -- 设置数据
-(void)setNewsArray:(NSMutableArray *) newsArray{
    _newsArray = newsArray;
    
    [_tableView reloadData];
}

- (void)setLastModel:(NewsLatestModel *)lastModel{
    _lastModel = lastModel;
    self.bannerView.images = lastModel.top_stories;
}

#pragma mark -- UITableView设置
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _newsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.tableView cellHeightForIndexPath:indexPath model:self.newsArray[indexPath.row] keyPath:@"model" cellClass:[HomeTableViewCell class] contentViewWidth:self.view.bounds.size.width];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    cell.model = self.newsArray[indexPath.row];
    return cell;
}
#pragma mark -- 表视图懒加载
-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[HomeTableViewCell class] forCellReuseIdentifier:CELLID];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        _tableView.tableHeaderView = headView;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

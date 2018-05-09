//
//  HomeViewController.m
//  zhihu
//
//  Created by 张义镇 on 2018/5/7.
//  Copyright © 2018年 zyiz. All rights reserved.
//

#import "HomeViewController.h"
#import "NewInfoViewController.h"

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

@property (nonatomic,strong)UIView *headerView;

@property (nonatomic,strong)UILabel *titleLable;

@property (nonatomic,strong)UIButton *leftBtn;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bannerView];
    [self.view addSubview:self.headerView];
    //self.bannerView.sd_layout.topSpaceToView(self.view, 0).leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).heightIs(220);
    
    [self getLates];
}

#pragma mark -- 导航栏
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [UIView new];
        _headerView.backgroundColor = [UIColor colorWithRed:23/255.0 green:150/255.0 blue:210/255.0 alpha:0];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
        
        [_headerView addSubview:self.leftBtn];
        [_headerView addSubview:self.titleLable];
        _leftBtn.sd_layout.topSpaceToView(_headerView, 25).leftSpaceToView(_headerView, 12).widthIs(25).heightIs(25);
        _titleLable.sd_layout.centerXEqualToView(_headerView).topEqualToView(_leftBtn).heightIs(25);
    }
    return _headerView;
}

- (UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [UILabel new];
        //自定义标题样式
        _titleLable.attributedText = [[NSAttributedString alloc]initWithString:@"今日要闻" attributes:@{
                                                                                                    NSFontAttributeName:[UIFont systemFontOfSize:20],
                                                                                                    NSForegroundColorAttributeName:[UIColor whiteColor]
                                                                                                    
                                                                                                        }];
        [_titleLable sizeToFit];
        _titleLable.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLable;
}

- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [UIButton new];
        [_leftBtn addTarget:self action:@selector(didLeftMenuButton) forControlEvents:UIControlEventTouchUpInside];
        [_leftBtn setImage:[UIImage imageNamed:@"icon_home_left"] forState:UIControlStateNormal];
        
    }
   return _leftBtn;
}

-(void)didLeftMenuButton{
    
}

#pragma mark -- 轮播图懒加载
- (BannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[BannerView alloc]init];
        _bannerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 240);
    }
    return _bannerView;
}


#pragma mark -- 获取知乎最新新闻
-(void)getLates {
    [[AFHTTPSessionManager manager] GET:@"https://news-at.zhihu.com/api/4/news/latest" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //使用字典解析
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
    //自适应高度
    return [self.tableView cellHeightForIndexPath:indexPath model:self.newsArray[indexPath.row] keyPath:@"model" cellClass:[HomeTableViewCell class] contentViewWidth:self.view.bounds.size.width];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    cell.model = self.newsArray[indexPath.row];
    return cell;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        //计算tableview的偏移量
        CGFloat yOffset = self.tableView.contentOffset.y;
        //初始值未-20 轮播图240 tableHeaderView 200
        NSLog(@"%f",yOffset);
        //下拉yOffset减小
        if (yOffset <= 0) {
            //使bannerView拉伸
            self.bannerView.height = 200 - yOffset;
            CGRect frame = self.bannerView.frame;
            frame.origin.y = 0;
            self.bannerView.frame = frame;
        }else{
            CGRect frame = self.bannerView.frame;
            frame.origin.y = 0 - yOffset;
            self.bannerView.frame = frame;
        }
        
        //设置headView随tableView的上拉而透明度加深
        CGFloat alpha = 0;
        if (yOffset < 100) {
            alpha = 0;
        }else if (yOffset < 165){
            alpha = (yOffset - 100) / (165 - 100);
        }else{
            alpha = 1;
        }
        _headerView.backgroundColor = [UIColor colorWithRed:23/255.0 green:150/255.0 blue:210/255.0 alpha:alpha];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //tableView元素的点击事件
    NewInfoViewController *newInfoVc = [[NewInfoViewController alloc]init];
    newInfoVc.storiesModel = self.newsArray[indexPath.row];
    [self presentViewController:newInfoVc animated:YES completion:nil];
}

#pragma mark -- 表视图懒加载
-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[HomeTableViewCell class] forCellReuseIdentifier:CELLID];
        //取消tableView的下划线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //设置tableView的监听事件
        [_tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
        //空出一块区域放置bannerView
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

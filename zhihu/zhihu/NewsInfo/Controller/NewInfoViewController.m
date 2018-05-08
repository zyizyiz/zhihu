//
//  NewInfoViewController.m
//  zhihu
//
//  Created by 张义镇 on 2018/5/8.
//  Copyright © 2018年 zyiz. All rights reserved.
//

#import "NewInfoViewController.h"
#import "NewsInfoModel.h"
#import "SectionModel.h"

@interface NewInfoViewController ()<UIWebViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)NewsInfoModel *model;

@end

@implementation NewInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    
    [self getNewsInfo:_storiesModel.id];
}

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
        _webView.delegate = self;
        _webView.scrollView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        
        _webView.frame = CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20);
    }
    return _webView;
}

#pragma mark -- 获取新闻详情
-(void)getNewsInfo:(NSInteger)ID {
    [[AFHTTPSessionManager manager] GET:[NSString stringWithFormat:@"https://news-at.zhihu.com/api/4/news/%ld",ID] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [NewsInfoModel mj_setupObjectClassInArray:^NSDictionary *{
           return @{
              @"section":@"SectionModel"
              };
        }];
        
        NewsInfoModel *model = [NewsInfoModel mj_objectWithKeyValues:responseObject];
        model.HTML = [NSString stringWithFormat:@"<html><head><link rel = \"stylesheet\" href = %@></link></head><body>%@</body></html>",model.css[0],model.body];
        self.model = model;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)setModel:(NewsInfoModel *)model{
    _model = model;
    [self.webView loadHTMLString:model.HTML baseURL:nil];
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

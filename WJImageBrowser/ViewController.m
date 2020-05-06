//
//  ViewController.m
//  WJImageBrowser
//
//  Created by 王杰 on 2018/10/23.
//  Copyright © 2018年 wangjie. All rights reserved.
//

#import "ViewController.h"
#import <UIImageView+WebCache.h>
#import "WJImageBrowserView.h"
#import "WJBannerView.h"

@interface ViewController ()<WJBannerViewDelegate, WJBannerViewDataSource>

@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, strong) NSArray *bannUrl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView1];
//    [self setupView2];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)setupView1 {
    self.array = [NSMutableArray array];
    
    UIImageView *imageView = [self createImageView];
    imageView.image = [UIImage imageNamed:@"1.jpg"];
    imageView.frame = CGRectMake(20, 100, 100, 100);
    [self.view addSubview:imageView];
    [self.array addObject:imageView];
    
    imageView = [self createImageView];
    imageView.image = [UIImage imageNamed:@"2.jpg"];
    imageView.frame = CGRectMake(120, 100, 100, 100);
    [self.view addSubview:imageView];
    [self.array addObject:imageView];
    
    imageView = [self createImageView];
    imageView.image = [UIImage imageNamed:@"3.jpg"];
    imageView.frame = CGRectMake(220, 100, 100, 100);
    [self.view addSubview:imageView];
    [self.array addObject:imageView];
    
    imageView = [self createImageView];
    imageView.image = [UIImage imageNamed:@"4.jpg"];
    imageView.frame = CGRectMake(20, 200, 100, 100);
    [self.view addSubview:imageView];
    [self.array addObject:imageView];
    
    imageView = [self createImageView];
    imageView.image = [UIImage imageNamed:@"5.jpg"];
    imageView.frame = CGRectMake(120, 200, 100, 100);
    [self.view addSubview:imageView];
    [self.array addObject:imageView];
    
    imageView = [self createImageView];
    imageView.image = [UIImage imageNamed:@"6.jpg"];
    imageView.frame = CGRectMake(220, 200, 100, 100);
    [self.view addSubview:imageView];
    [self.array addObject:imageView];
}

- (void)setupView2 {
    self.view.backgroundColor = [UIColor yellowColor];
    WJBannerView *bannerView = [[WJBannerView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.width)];
    bannerView.dataSource = self;
    bannerView.delegate = self;
    [self.view addSubview:bannerView];
    [bannerView reloadData];
}

- (UIImageView *)createImageView {
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.userInteractionEnabled = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [imgView addGestureRecognizer:tgr];
    return imgView;
}

- (void)click:(UITapGestureRecognizer *)tgr {
    WJImageBrowserView *browserView = [[WJImageBrowserView alloc] init];
    browserView.originalViews = self.array;
    browserView.currentIndex = [self.array indexOfObject:tgr.view];
    browserView.longBlock = ^(WJImageBrowserView *browserView) {
        
    };
    [browserView show];
}


#pragma mark WJBannerViewDataSource

//图片总个数
- (NSInteger)wj_numberOfRowInWJBannerView:(WJBannerView *)bannerView {
    return self.bannUrl.count;
}

//获取当前图片urlString
- (NSURL *)wj_bannerView:(WJBannerView *)bannerView imageNameForIndex:(NSInteger)index {
    if (index < self.bannUrl.count) {
        return [NSURL URLWithString:self.bannUrl[index]];
    }
    return nil;
}

#pragma mark WJBannerViewDelegate

- (void)wj_bannerView:(WJBannerView *)bannerView didSelectedRowAtIndex:(NSInteger)index {
    WJImageBrowserView *browserView = [[WJImageBrowserView alloc] init];
    browserView.originalViews = @[bannerView.currImageView];
    browserView.urls = self.bannUrl;
    browserView.currentIndex = index;
    browserView.browserViewType = WJImageBrowserViewTypeBanner;
    browserView.closeBlock = ^(NSInteger index) {
        [bannerView scrollToIndex:index];
    };
    [browserView show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)bannUrl {
    if (!_bannUrl) {
        _bannUrl = @[            @"https://img2.tbb.la/images/dis_group_img/201905/1557457455194942190.gif",
                                 @"https://img.tbb.la/images/201810/thumb_img/7620_thumb_P_1540594680509.jpg",
                                 @"https://img.tbb.la/images/201810/thumb_img/7620_thumb_P_1540594681895.jpg",
                                 @"https://img.tbb.la/images/201810/thumb_img/7620_thumb_P_1540594683398.jpg"
];
    }
    return _bannUrl;
}

@end

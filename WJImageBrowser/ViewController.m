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

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    // Do any additional setup after loading the view, typically from a nib.
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
    browserView.showTransitionAnimation = NO;
    browserView.originalViews = self.array;
    browserView.currentIndex = [self.array indexOfObject:tgr.view];
    [browserView show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

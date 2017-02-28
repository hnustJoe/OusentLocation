//
//  CSIIViewController.m
//  ScrollView
//
//  Created by Hu Di on 13-10-11.
//  Copyright (c) 2013年 Sanji. All rights reserved.
//

#import "HDViewController.h"

@interface HDViewController ()
{
    NSMutableArray *imageArray;
    HDScrollview *_scrollview;
}
@end

@implementation HDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        imageArray=[NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSArray *ImageArr;
    UIImage *image0;
    UIImage *image1;
    UIImage *image2;
    
        image0  = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"启动页1" ofType:@"jpg"]];
        image1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"启动页2" ofType:@"jpg"]];
        image2 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"启动页3" ofType:@"jpg"]];

    ImageArr=@[image0,image1,image2];
    

    
    
    
    
   
    for (int i=0; i<ImageArr.count; i++) {
        UIImageView *imageview=[[UIImageView alloc]init];
        imageview.image=[ImageArr objectAtIndex:i];
        imageview.contentMode=UIViewContentModeScaleAspectFit;
        [imageArray addObject:imageview];
    }
    _scrollview=[[HDScrollview alloc]initLoopScrollWithFrame:self.view.bounds withImageView:imageArray];
    _scrollview.delegate=self;
    _scrollview.HDdelegate=self;
    [self.view addSubview:_scrollview];
}

-(void)viewDidAppear:(BOOL)animated
{

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)BTNCLICK:(UIButton *)sender
{
    NSLog(@"%@",sender.titleLabel.text);
}
#pragma mark ==========UIScrollViewDelegate============

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    [_scrollview HDscrollViewDidScroll];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    [_scrollview HDscrollViewDidEndDecelerating];
}
-(void)TapView:(int)index
{
    
    NSLog(@"点击了第%d个页面",index);
    
    if (index == imageArray.count - 1) {
        [self.delegate lastPageClicked:self];
    }
    //下面可以根据自己的需求操作
    //Example
//    if (imageArray.count>1) {
//        //删除一个
//        [imageArray removeObjectAtIndex:index];
//        //_scrollview=[_scrollview initWithFrame:_scrollview.frame withImageView:imageArray];
//        
//        _scrollview=[_scrollview initLoopScrollWithFrame:_scrollview.frame withImageView:imageArray];
//        _scrollview.pagecontrol.currentPage=index;
//        
//    }
}
@end

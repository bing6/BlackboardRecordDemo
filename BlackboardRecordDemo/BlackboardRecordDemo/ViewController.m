//
//  ViewController.m
//  BlackboardRecordDemo
//
//  Created by bing.hao on 15/9/7.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import "ViewController.h"
#import "BRPackerViewController.h"
#import "AssetsEntity.h"
#import <MediaPlayer/MediaPlayer.h>
#import <KSRefresh/UIScrollView+KS.h>

@interface ViewController ()
<
    BRPackerViewControllerDelegate,
    KSRefreshViewDelegate,
    UITableViewDataSource,
    UITableViewDelegate
>

@property (nonatomic, assign) NSInteger      pageNumber;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) MPMoviePlayerController *player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    DTM_SHARE.logEnabled = YES;
    
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"板书录制";
    
    self.dataSource = [NSMutableArray new];
    self.tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.footer = [[KSAutoFootRefreshView new] initWithDelegate:self];
//    self.tableView.header = [[KSDefaultHeadRefreshView new] initWithDelegate:self];
//    self.tableView.separatorInset = UIEdgeInsetsZero;
//    
//    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    id rbtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(rbtn:)];
    id lbtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(lbtn:)];
    
    self.navigationItem.rightBarButtonItem = rbtn;
    self.navigationItem.leftBarButtonItem  = lbtn;
    
    [self reloadDataWithPage:1];
}

- (void)rbtn:(id)sender
{
    self.tableView.editing = !self.tableView.editing;
}

- (void)lbtn:(id)sender
{
    BRPackerViewController * pvc = [BRPackerViewController new];
    
    [pvc setDelegate:self];
    [self presentViewController:pvc animated:YES completion:nil];
}

- (void)reloadDataWithPage:(NSInteger)page
{
    NSArray * result = [AssetsEntity query].orderByDesc(@"createdAt").limit(page, 15).fetchArray();
    
    if (page == 0) {
        [self.dataSource removeAllObjects];
    }
    if ([result count] < 15) {
        self.tableView.footer.isLastPage = YES;
    }
    [self.dataSource addObjectsFromArray:result];
    
    self.pageNumber = page;
    
    [self.tableView reloadData];
}

#pragma mark - BRPackerViewControllerDelegate

- (void)packerViewControllerDidCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)packerViewControllerDidComplete:(BRPackerViewController *)sender video:(NSString *)vpath image:(NSString *)ipath
{
    AssetsEntity *entity = [AssetsEntity new];
    
    entity.author    = @"Howard";
    entity.videoPath = vpath;
    entity.imagePath = ipath;
    entity.duration  = sender.videoDuration;
    
    [entity save];
    [self reloadDataWithPage:1];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.textLabel.font = KS_FONT(14);
    }
    
    AssetsEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
    NSDate *crated = [NSDate dateWithTimeIntervalSince1970:[entity.createdAt doubleValue]];
    NSString *fileName = [[entity.imagePath componentsSeparatedByString:@"/"] lastObject];
    NSString *path = KS_PATH_CACHE_FORMAT(@"/%@", fileName);
    
    cell.imageView.image = [UIImage imageWithContentsOfFile:path];
    cell.textLabel.text = [NSString stringWithFormat:@"Created by %@", crated];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssetsEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
    NSString *fileName = [[entity.videoPath componentsSeparatedByString:@"/"] lastObject];
    NSString *path = KS_PATH_CACHE_FORMAT(@"/%@", fileName);
    NSURL *url = [NSURL fileURLWithPath:path];
    
    self.player = [[MPMoviePlayerController alloc] initWithContentURL:url];
    
    [self.player prepareToPlay];
    [self.view addSubview:self.player.view];
    [self.player setShouldAutoplay:YES];
    [self.player setFullscreen:YES];
    [self.player play];
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AssetsEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
        [entity destroy];
        [self.dataSource removeObject:entity];
        [self.tableView reloadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - KSRefreshViewDelegate

- (void)refreshViewDidLoading:(id)view
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        KS_DISPATCH_MAIN_QUEUE(^{
            [self reloadDataWithPage:self.pageNumber + 1];
            [self.tableView.footer setState:RefreshViewStateDefault];
        });
    });
}

@end

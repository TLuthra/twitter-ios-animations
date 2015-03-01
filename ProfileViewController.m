//
//  ProfileViewController.m
//  twitter
//
//  Created by Tanooj Luthra on 2/28/15.
//  Copyright (c) 2015 Tanooj Luthra. All rights reserved.
//

#import "ProfileViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "TweetViewController.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *tweetCount;
@property (strong, nonatomic) IBOutlet UILabel *followingCount;
@property (strong, nonatomic) IBOutlet UILabel *followersCount;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *screennameLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIColor *globalTint = [[[UIApplication sharedApplication] delegate] window].tintColor;

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UINib *tweetCellNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:tweetCellNib forCellReuseIdentifier:@"TweetCell"];
    
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 125.0; // set to whatever your "average" cell height is
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl setTintColor:globalTint];
    [self.tableView addSubview:self.refreshControl];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    
    self.tweetCount.text = [numberFormatter stringFromNumber:self.user.tweetsCount];
    self.followersCount.text = [numberFormatter stringFromNumber:self.user.followersCount];
    self.followingCount.text = [numberFormatter stringFromNumber:self.user.followingCount];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
    __weak UIImageView *weakProfileImageView = self.profileImageView;
    __weak UILabel *weakNameLabel = self.nameLabel;
    __weak UILabel *weakScreenNameLabel = self.screennameLabel;
    
    self.nameLabel.textColor = [UIColor blackColor];
    self.screennameLabel.textColor = [UIColor blackColor];
    
    self.screennameLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenname];
    self.nameLabel.text = self.user.name;

    
    [self.profileImageView setImageWithURLRequest:req placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakProfileImageView.alpha = 0.0;
        weakProfileImageView.image = image;
        
        CALayer * l = [weakProfileImageView layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:5.0];
        
        // You can even add a border
        [l setBorderWidth:3.0];
        [l setBorderColor:[[UIColor whiteColor] CGColor]];

        
        [UIView animateWithDuration:0.25 animations:^{
            weakProfileImageView.alpha = 1.0;
        }];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"error %@", error);
    }];

    [[TwitterClient sharedInstance] userBannerWithParams:@{@"user_id":self.user.userId} completion:^(NSDictionary *bannerUrls, NSError *error) {
        NSString *profileBackgroundImageUrl = bannerUrls[@"sizes"][@"ipad_retina"][@"url"];
        
        NSURLRequest *backgroundImageReq = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:profileBackgroundImageUrl]];
        __weak UIImageView *weakBackgroundImageView = self.backgroundImageView;
        
        [self.backgroundImageView setImageWithURLRequest:backgroundImageReq placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            UIGraphicsBeginImageContext(weakBackgroundImageView.bounds.size);
            [weakBackgroundImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *viewImage = image;
            UIGraphicsEndImageContext();
            
            //Blur the UIImage with a CIFilter
            CIImage *imageToBlur = [CIImage imageWithCGImage:viewImage.CGImage];
            CIFilter *gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
            [gaussianBlurFilter setValue:imageToBlur forKey: @"inputImage"];
            [gaussianBlurFilter setValue:[NSNumber numberWithFloat: 5] forKey: @"inputRadius"];
            CIImage *resultImage = [gaussianBlurFilter valueForKey: @"outputImage"];
            UIImage *endImage = [[UIImage alloc] initWithCIImage:resultImage];
            
            //Place the UIImage in a UIImageView
            weakBackgroundImageView.image = endImage;
            weakBackgroundImageView.alpha = 0.0;
            [UIView animateWithDuration:0.25 animations:^{
                weakBackgroundImageView.alpha = 1.0;
                weakNameLabel.textColor = [UIColor whiteColor];
                weakScreenNameLabel.textColor = [UIColor whiteColor];
            }];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"error %@", error);
        }];
    }];
    
    [self reload];
}

- (void)reload {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"user_id"] = self.user.userId;
    [[TwitterClient sharedInstance] userTimelineWithParams:params completion:^(NSArray *tweets, NSError *error) {
        self.tweets = [NSMutableArray arrayWithArray:tweets];
        [self.refreshControl endRefreshing];
        
        [self.tableView reloadData];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    
    [cell setTweet:self.tweets[indexPath.row]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Tweet *tweet = self.tweets[indexPath.row];
    
    TweetViewController *tvc = [[TweetViewController alloc] init];
    tvc.tweet = tweet;
    [self.navigationController pushViewController:tvc animated:YES];
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

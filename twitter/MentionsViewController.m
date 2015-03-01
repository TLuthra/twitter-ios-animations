//
//  MentionsViewController.m
//  twitter
//
//  Created by Tanooj Luthra on 3/1/15.
//  Copyright (c) 2015 Tanooj Luthra. All rights reserved.
//

#import "MentionsViewController.h"
#import "TweetsViewController.h"
#import "TweetViewController.h"
#import "User.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "HamburgerViewController.h"

@interface MentionsViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation MentionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIColor *globalTint = [[[UIApplication sharedApplication] delegate] window].tintColor;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tweets = [[NSMutableArray alloc] init];
    
    UINib *tweetCellNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:tweetCellNib forCellReuseIdentifier:@"TweetCell"];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 125.0; // set to whatever your "average" cell height is
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl setTintColor:globalTint];
    [self.tableView addSubview:self.refreshControl];
    
    self.title = @"Mentions";
    
    UIBarButtonItem *leftBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"lines"] style:UIBarButtonItemStylePlain target:self.hamburgerViewController action:@selector(onHamburger)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;

    [self reload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reload {
    [[TwitterClient sharedInstance] mentionsTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        self.tweets = [NSMutableArray arrayWithArray:tweets];
        [self.refreshControl endRefreshing];
        
        [self.tableView reloadData];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    NSLog(@"stuff: %ld, %@", (long)indexPath.row, self.tweets[indexPath.row]);
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
    
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [((HamburgerViewController *)((UINavigationController *)del.window.rootViewController)).tweetsNavigationViewController pushViewController:tvc animated:YES];
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

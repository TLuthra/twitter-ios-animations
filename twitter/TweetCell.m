//
//  TweetCell.m
//  Twitter
//
//  Created by Tanooj Luthra on 2/22/15.
//  Copyright (c) 2015 Tanooj Luthra. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"
#import "NSDate+TimeAgo.h"
#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "HamburgerViewController.h"

@implementation TweetCell

- (void)awakeFromNib {
    // Initialization code
}

- (void) setTweet: (Tweet *) tweet {
   
    User *author = tweet.author;
    self.user = author;
    
    UITapGestureRecognizer *tapProfile = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProfileTap:)];
    [tapProfile setNumberOfTapsRequired:1];
    [tapProfile setCancelsTouchesInView:YES];
    [self.profileImageView addGestureRecognizer:tapProfile];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:author.profileImageUrl]];
    __weak UIImageView *weakProfileImageView = self.profileImageView;
    
    [self.profileImageView setImageWithURLRequest:req placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakProfileImageView.alpha = 0.0;
        weakProfileImageView.image = image;
        [UIView animateWithDuration:0.25 animations:^{
            weakProfileImageView.alpha = 1.0;
        }];

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", author.screenname];
    self.createdAtLabel.text = [tweet.createdAt timeAgo];
    self.tweetLabel.text = tweet.text;
    [self.tweetLabel sizeToFit];
    self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.width;

}

- (void)onProfileTap:(UITapGestureRecognizer *)sender {
    NSLog(@"profile tapped %@", self.user.userId);
    
    ProfileViewController *pvc = [[ProfileViewController alloc] init];
    pvc.user = self.user;
    
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [((HamburgerViewController *)((UINavigationController *)del.window.rootViewController)).tweetsNavigationViewController pushViewController:pvc animated:YES];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

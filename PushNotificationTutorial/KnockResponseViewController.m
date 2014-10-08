//
//  KnockResponseViewController.m
//  PushNotificationTutorial
//
//  Created by Nathan Lambson on 10/7/14.
//
//

#import "KnockResponseViewController.h"




@interface KnockResponseViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, weak) IBOutlet UILabel *userNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, weak) IBOutlet UIView *userColorView;

@end

@implementation KnockResponseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.avatarImageView.layer.cornerRadius = CGRectGetHeight(self.avatarImageView.frame)/2;
    self.avatarImageView.layer.borderColor = [[UIColor blueColor] CGColor];
    self.avatarImageView.layer.borderWidth = 2.0f;
    self.avatarImageView.backgroundColor = [UIColor darkGrayColor];
    self.avatarImageView.clipsToBounds = YES;

    self.messageLabel.text = @"Is at your door";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.userName) {
        self.userNameLabel.text = self.userName;
    }
    
    self.userColorView.backgroundColor = [UIColor colorWithHue:self.hue/360.0f saturation:1.0f brightness:1.0f alpha:1.0f];
    
    if (self.avatarURL) {
        self.avatarImageView.image = nil;
        [self.activityIndicator startAnimating];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *url = [NSURL URLWithString:[self.avatarURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.activityIndicator stopAnimating];
                self.avatarImageView.image = [UIImage imageWithData:data];
            });
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

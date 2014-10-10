//
//  KnockResponseViewController.m
//  PushNotificationTutorial
//
//  Created by Nathan Lambson on 10/7/14.
//
//

#import "KnockResponseViewController.h"

#import "User.h"


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
    self.avatarImageView.backgroundColor = [UIColor whiteColor];
    self.avatarImageView.clipsToBounds = YES;

    self.messageLabel.text = @"Is at your door";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.userColorView.backgroundColor = [UIColor colorWithHue:[self.hue doubleValue]/360.0f saturation:1.0f brightness:1.0f alpha:1.0f];
    
    if (self.userName) {
        self.userNameLabel.text = self.userName;
    
        [self.activityIndicator startAnimating];
        PFQuery *query = [PFQuery queryWithClassName:[User className] predicate:[NSPredicate predicateWithFormat:@"name == %@", self.userName]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
                [self.activityIndicator stopAnimating];
            } else {
                // The find succeeded. The first 100 objects are available in objects
                NSLog(@"objects: %@", objects);
                
                User *user = nil;
                for (PFObject *object in objects) {
                    NSArray *knockTimings = object[@"knockTimings"];
                    user = [[User alloc] initWithName:object[@"name"] color:object[@"color"] knockTimings:knockTimings keycode:object[@"keycode"]];
                    user.avatar = [object valueForKey:@"avatar"];
                    break;
                }
                
                [user.avatar getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    self.avatarImageView.image = [UIImage imageWithData:data];
                    [self.activityIndicator stopAnimating];
                }];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

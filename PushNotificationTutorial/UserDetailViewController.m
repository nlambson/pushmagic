//
//  UserDetailViewController.m
//  PushNotificationTutorial
//
//  Created by Rick Roberts on 10/7/14.
//
//

#import "UserDetailViewController.h"

@interface UserDetailViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *knockViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *knockStartStopButton;
@property (nonatomic) BOOL isRecordingKnock;
@property (nonatomic, strong) NSMutableArray *knocksArray;
@property (nonatomic, strong) NSDate *lastKnockTime;
@end

@implementation UserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveUser)];
    
    self.navigationItem.rightBarButtonItem = saveItem;
    self.knockViewHeightConstraint.constant = 0;
    self.knocksArray = [NSMutableArray new];
    self.isRecordingKnock = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveUser {
    NSLog(@"INTO SAVE USER");
    
    PFObject *user = [[PFObject alloc] init];
    [user setValue:@"Rick" forKey:@"name"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"GOOD");
        } else {
            NSLog(@"BAD: %@", error.description);
        }
    }];
}

- (IBAction)knockTouched:(id)sender {
    self.isRecordingKnock = !self.isRecordingKnock;
    
    if (self.isRecordingKnock) {
        [self.knockStartStopButton setTitle:@"Stop Recording" forState:UIControlStateNormal];
        self.knockViewHeightConstraint.constant = 150;
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }];
        self.lastKnockTime = nil;
    } else {
        [self.knockStartStopButton setTitle:@"Start Recording" forState:UIControlStateNormal];
        self.knockViewHeightConstraint.constant = 0;
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
    
}

- (IBAction)actualKnockTouched:(id)sender {
    if (self.isRecordingKnock) {
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.lastKnockTime];
        if (self.lastKnockTime) {
            [self.knocksArray addObject:@(interval)];
        }
        self.lastKnockTime = [NSDate date];
    }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"TIMES: %@", self.knocksArray);
    }
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

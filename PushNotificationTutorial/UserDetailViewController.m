//
//  UserDetailViewController.m
//  PushNotificationTutorial
//
//  Created by Rick Roberts on 10/7/14.
//
//

#import "UserDetailViewController.h"

@interface UserDetailViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *knockViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *knockStartStopButton;
@property (nonatomic) BOOL isRecordingKnock;
@property (nonatomic, strong) NSMutableArray *knocksArray;
@property (nonatomic, strong) NSDate *lastKnockTime;
@property (weak, nonatomic) IBOutlet UITextField *keyCodeField;
@property (weak, nonatomic) IBOutlet UIView *colorPreviewView;
@property (weak, nonatomic) IBOutlet UISlider *colorSlider;
@property (nonatomic) double colorValue;
@end

@implementation UserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Creating a new user
    if (!self.user) {
        UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveUser)];
        self.navigationItem.rightBarButtonItem = saveItem;
    }
    // Viewing user data selected from table on previous view
    else {
        self.keyCodeField.text = self.user.keycode;
    }
    
    self.knockViewHeightConstraint.constant = 0;
    self.knocksArray = [NSMutableArray new];
    self.isRecordingKnock = NO;
    self.keyCodeField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)colorValueChanged:(UISlider *)sender {
    UIColor *color = [UIColor colorWithHue:(sender.value / 360) saturation:1.0 brightness:1.0 alpha:1.0];
    self.colorPreviewView.backgroundColor = color;
    self.colorValue = sender.value;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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

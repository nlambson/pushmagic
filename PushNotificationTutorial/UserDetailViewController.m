//
//  UserDetailViewController.m
//  PushNotificationTutorial
//
//  Created by Rick Roberts on 10/7/14.
//
//

#import "UserDetailViewController.h"

@interface UserDetailViewController () <UITextFieldDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *knockViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *knockStartStopButton;
@property (nonatomic) BOOL isRecordingKnock;
@property (nonatomic, strong) NSMutableArray *knocksArray;
@property (nonatomic, strong) NSDate *lastKnockTime;
@property (weak, nonatomic) IBOutlet UITextField *keyCodeField;
@property (weak, nonatomic) IBOutlet UIView *colorPreviewView;
@property (weak, nonatomic) IBOutlet UISlider *colorSlider;
@property (nonatomic) double colorValue;
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@end

@implementation UserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Creating a new user
    if (!self.user) {
        UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveUser)];
        self.navigationItem.rightBarButtonItem = saveItem;
        self.title = @"New User";
    }
    // Viewing user data selected from table on previous view
    else {
        self.userNameField.text = self.user.name;
        self.keyCodeField.text = self.user.keycode;
        self.colorSlider.value = self.user.color.floatValue;
        self.colorPreviewView.backgroundColor = [UIColor colorWithHue:(self.user.color.floatValue/360.0) saturation:1.0 brightness:1.0 alpha:1.0];
        
        // TODO: Change knock text
        //       Replay knock or something cool like that
        
        
        [self.knockStartStopButton setTitle:@"Play Knock" forState:UIControlStateNormal];
        [self.knockStartStopButton removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
        [self.knockStartStopButton addTarget:self action:@selector(playKnock:) forControlEvents:UIControlEventTouchUpInside];
        self.title = @"User Details";
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
    
    NSString *name = self.userNameField.text;
    NSNumber *color = [NSNumber numberWithDouble:self.colorValue];
    NSString *keycode = self.keyCodeField.text;

    User *user = [[User alloc] initWithName:name color:color knockTimings:self.knocksArray keycode:keycode];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"error: %@", error.localizedDescription);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh...." message:@"Not sure how this happened but the save didn't work. You should try again." delegate:self cancelButtonTitle:@"Fine" otherButtonTitles:nil];
            alert.tag = 100;
            [alert show];
        }
        else {
            NSLog(@"succeeded");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Panda Happy!" message:@"Your user was successfully created." delegate:self cancelButtonTitle:@"I love it!" otherButtonTitles:nil];
            [alert show];
        }
    }];
    
//    
//    PFObject *user = [[PFObject alloc] init];
//    [user setValue:@"Rick" forKey:@"name"];
//    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            NSLog(@"GOOD");
//        } else {
//            NSLog(@"BAD: %@", error.description);
//        }
//    }];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        // Error
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)playKnock:(id)sender {
    NSLog(@"Play knock");
    
    NSArray *knocks;
    
    if (self.user) {
        knocks = self.user.knockTimings;
    } else {
        knocks = self.knocksArray;
    }
    
    [NSArray arrayWithObjects:self.user.knockTimings, nil];
    __block double nextDelay = 0.5;
    [self performSelector:@selector(playSound) withObject:nil afterDelay:nextDelay];
    [knocks enumerateObjectsUsingBlock:^(NSNumber *number, NSUInteger idx, BOOL *stop) {
        nextDelay += number.doubleValue;
        [self performSelector:@selector(playSound) withObject:nil afterDelay:nextDelay];
    }];
    
}

- (void)playSound {
    AudioServicesPlaySystemSound(1104);
    [UIView animateWithDuration:0.1 animations:^{
        self.knockStartStopButton.backgroundColor = [UIColor darkGrayColor];
    } completion:^(BOOL finished) {
        self.knockStartStopButton.backgroundColor = [UIColor lightGrayColor];
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
        [self.knockStartStopButton setTitle:@"Replay Knock" forState:UIControlStateNormal];
        [self.knockStartStopButton removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
        [self.knockStartStopButton addTarget:self action:@selector(playKnock:) forControlEvents:UIControlEventTouchUpInside];
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

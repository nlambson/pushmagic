//
//  UserDetailViewController.m
//  PushNotificationTutorial
//
//  Created by Rick Roberts on 10/7/14.
//
//

#import "UserDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface UserDetailViewController () <UITextFieldDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
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
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIButton *knockHereButton;
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;
@property (nonatomic, strong) UIImagePickerController *controller;
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
        self.userNameField.userInteractionEnabled = NO;
        self.title = @"User Details";
        
        [self.user.avatar getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            UIImage *image = [UIImage imageWithData:data];
            self.profileImageView.image = image;
        }];
        
        [self.addImageButton setTitle:@"" forState:UIControlStateNormal];
    }
    
    self.knockViewHeightConstraint.constant = 0;
    self.knocksArray = [NSMutableArray new];
    self.isRecordingKnock = NO;
    self.keyCodeField.delegate = self;
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height * 0.5;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.layer.borderWidth = 1.0f;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.allowsEdgeAntialiasing = YES;
    self.userNameField.delegate = self;
    self.knockHereButton.backgroundColor = [UIColor clearColor];
    self.knockHereButton.clipsToBounds = YES;
    self.knockHereButton.layer.cornerRadius = 10.0f;
    self.knockHereButton.layer.borderWidth = 1.0f;
    self.knockHereButton.layer.borderColor = self.colorPreviewView.backgroundColor.CGColor;
}

- (IBAction)newImage:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Choose Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Library", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"0");
        [self showImagePickerForCamera:nil];
    } else {
        NSLog(@"Other");
        [self showImagePickerForPhotoPicker:nil];
    }
}

- (IBAction)showImagePickerForCamera:(id)sender
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
}


- (IBAction)showImagePickerForPhotoPicker:(id)sender
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    self.profileImageView.image = image;
    [self.addImageButton setTitle:@"" forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadImage:(NSData *)imageData {
    
    
    
//    PFObject *user = self.user;
//    [user setObject:imageFile forKey:@"avatar"];
//    [user saveInBackground];
    
    
//    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
//    
//    //HUD creation here (see example for code)
//    
//    // Save PFFile
//    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!error) {
//            // Hide old HUD, show completed HUD (see example for code)
//            
//            // Create a PFObject around a PFFile and associate it with the current user
//            PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
//            [userPhoto setObject:imageFile forKey:@"imageFile"];
//            
//            // Set the access control list to current user for security purposes
//            PFACL *acl = [[PFACL alloc] init];
//            [acl setPublicReadAccess:YES];
//            userPhoto.ACL = acl;
//        
////            PFUser *user = self.user;
////            [userPhoto setObject:userPhoto forKey:@"avatar"];
//            [userPhoto setObject:self.user forKey:@"user"];
//            
//            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                if (!error) {
////                    [self refresh:nil];
//                    NSLog(@"NO ERROR");
//                }
//                else{
//                    // Log details of the failure
//                    NSLog(@"Error: %@ %@", error, [error userInfo]);
//                }
//            }];
//        }
//        else{
////            [HUD hide:YES];
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    } progressBlock:^(int percentDone) {
//        // Update your progress spinner here. percentDone will be between 0 and 100.
////        HUD.progress = (float)percentDone/100;
//    }];
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        /*
         The user wants to use the camera interface. Set up our custom overlay view for the camera.
         */
        imagePickerController.showsCameraControls = YES;
        
        /*
         Load the overlay view from the OverlayView nib file. Self is the File's Owner for the nib file, so the overlayView outlet is set to the main view in the nib. Pass that view to the image picker controller to use as its overlay view, and set self's reference to the view to nil.
         */
//        [[NSBundle mainBundle] loadNibNamed:@"OverlayView" owner:self options:nil];
//        self.overlayView.frame = imagePickerController.cameraOverlayView.frame;
//        imagePickerController.cameraOverlayView = self.overlayView;
//        self.overlayView = nil;
    }
    
    self.controller = imagePickerController;
    [self presentViewController:self.controller animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)colorValueChanged:(UISlider *)sender {
    UIColor *color = [UIColor colorWithHue:(sender.value / 360) saturation:1.0 brightness:1.0 alpha:1.0];
    self.colorPreviewView.backgroundColor = color;
    self.colorValue = sender.value;
    sender.tintColor = color;
}

- (void)saveUser {
    NSLog(@"INTO SAVE USER");
    
    NSString *name = self.userNameField.text;
    NSNumber *color = [NSNumber numberWithDouble:self.colorValue];
    NSString *keycode = self.keyCodeField.text;
    
    NSData *imageData = UIImagePNGRepresentation(self.profileImageView.image);
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
    [imageFile saveInBackground];

    User *user = [[User alloc] initWithName:name color:color knockTimings:self.knocksArray keycode:keycode];
    [user setObject:imageFile forKey:@"avatar"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"error: %@", error.localizedDescription);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uh...." message:@"Not sure how this happened but the save didn't work. You should try again." delegate:self cancelButtonTitle:@"Fine" otherButtonTitles:nil];
            alert.tag = 100;
            [alert show];
        }
        else {
            
            // Upload image
//            [self uploadImage:imageData];
            
            
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
        self.knockStartStopButton.backgroundColor = self.colorPreviewView.backgroundColor;
    } completion:^(BOOL finished) {
        self.knockStartStopButton.backgroundColor = [UIColor clearColor];
    }];
}

- (IBAction)knockTouched:(id)sender {
    [self.knockHereButton setBackgroundImage:[self imageWithColor:self.colorPreviewView.backgroundColor] forState:UIControlStateHighlighted];

    self.isRecordingKnock = !self.isRecordingKnock;
    [self.userNameField resignFirstResponder];
    
    if (self.isRecordingKnock) {
        [self.knockStartStopButton setTitle:@"Stop Recording" forState:UIControlStateNormal];
        [self.knockStartStopButton setTintColor:[UIColor redColor]];
        self.knockViewHeightConstraint.constant = 150;
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }];
        self.lastKnockTime = nil;
    } else {
        [self.knockStartStopButton setTintColor:((UIWindow *)[[UIApplication sharedApplication] windows][0]).tintColor];
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

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
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

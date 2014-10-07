//
//  UserDetailViewController.m
//  PushNotificationTutorial
//
//  Created by Rick Roberts on 10/7/14.
//
//

#import "UserDetailViewController.h"

@interface UserDetailViewController ()
@end

@implementation UserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveUser)];
    
    self.navigationItem.rightBarButtonItem = saveItem;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

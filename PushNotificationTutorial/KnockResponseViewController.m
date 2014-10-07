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
@property (nonatomic, weak) IBOutlet UILabel *userNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, weak) IBOutlet UIButton *acceptButton;
@property (nonatomic, weak) IBOutlet UIButton *rejectButton;

@end

@implementation KnockResponseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.acceptButton.layer.borderColor = [[UIColor greenColor] CGColor];
    self.acceptButton.layer.borderWidth = 2.0f;
    
    self.rejectButton.layer.borderColor = [[UIColor redColor] CGColor];
    self.rejectButton.layer.borderWidth = 2.0f;
    
    
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

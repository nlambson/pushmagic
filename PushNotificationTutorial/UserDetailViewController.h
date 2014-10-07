//
//  UserDetailViewController.h
//  PushNotificationTutorial
//
//  Created by Rick Roberts on 10/7/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface UserDetailViewController : UIViewController
@property (nonatomic, strong) PFObject *user;

@end

//

#import "AppDelegate.h"
#import "ViewController.h"
#import "PMDoorController.h"
#import <Parse/Parse.h>

@implementation AppDelegate

#pragma mark - UIApplicationDelegate

- (void)setupInteractiveNotifications {
    
    //CREATE THE ACTION
    
    //instantiate the action
    UIMutableUserNotificationAction *openDoorAction = [UIMutableUserNotificationAction new];
    
    // set an identifier for the action, this is used to differentiate actions from eachother when the notifiaction action handler method is called
    openDoorAction.identifier = @"OPEN_DOOR_IDENTIFIER";
    
    // Set the Title.. here we find the unicode value of the "thumbs up" emoji that the will appear inside the button corresponding to this action inside the push notification
    openDoorAction.title = @"\U0001F44D";
    
    // If this is set to destructive, the background color of the button corresponding to this action will be red, otherwise it will be blue
    openDoorAction.destructive = NO;
    
    // UIUserActivationMode is used to tell the system whether it should bring your app into the foregroudn, or leave it in the background, in this case, the app can complete the request to update our backed in the background, so we don't have to open the app
    openDoorAction.activationMode = UIUserNotificationActivationModeBackground;
    
    
    // CREATE THE CATEGORY
    
    // instantiate the category
    UIMutableUserNotificationCategory *postCategory = [UIMutableUserNotificationCategory new];
    
    // set its identifier. The APS dictionary you send for your push notifications must have a key named 'category' whose object is set to a string that matches this identifier in order for you actions to appear.
    postCategory.identifier = @"POST_CATEGORY";
    
    // set the actions that are associated with this type of push notification category
    // you can use the UIUserNotificationActionContext to determine which actions will show up in different
    // push notification presentation contexts, for example, on the lock screen, as a banner notification, or as an alert view notification
    [postCategory setActions:@[openDoorAction]
                  forContext:UIUserNotificationActionContextDefault];
    
    
    // REGISTER THE CATEGORY
    NSSet *categorySet = [NSSet setWithObjects:postCategory, nil];
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:categorySet];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}


// In your app delegate, override this method
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    
    if ([identifier isEqualToString:@"OPEN_DOOR_IDENTIFIER"]){
        
        PMDoorController *knocker = [PMDoorController new];
        
        [knocker openDoorWithSuccess:^() {
            NSLog(@"Door opened");
            completionHandler();
        }failure:^(NSError *error) {
            NSLog(@"ERROR: Could not open door");
            completionHandler();
        }];
        
    }
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // ****************************************************************************
    // Uncomment and fill in with your Parse credentials:
    // [Parse setApplicationId:@"your_application_id" clientKey:@"your_client_key"];
    // ****************************************************************************

    [Parse setApplicationId:@"J2cgRNSfyNzCaTiT72V5YakWSnw0tIJOYtdiIeYc"
                  clientKey:@"LKl8rgOEsVDOXXIu6gb25MY4TBffyCgKxoabPFOz"];
    
    // Register for Push Notitications, if running iOS 8
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [self setupInteractiveNotifications];
    } else {
        // Register for Push Notifications before iOS 8
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeAlert |
                                                         UIRemoteNotificationTypeSound)];
    }
    
    // Override point for customization after application launch.
    // [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[@"global"];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}


@end

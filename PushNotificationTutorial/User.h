//
//  User.h
//  PushNotificationTutorial
//
//  Created by Miles Wright on 10/7/14.
//
//

#import <Parse/Parse.h>

@interface User : PFObject

// Full user name
@property NSString *name;

// Hue value 0 - 360 degrees
@property NSInteger *color;

// Array containing timings for custom knock
@property NSArray *knockTimings;

// Users access keycode
@property NSString *keycode;

- (User *)initWithName:(NSString *)name color:(NSInteger)color knockTimings:(NSArray *)knockTimings keycode:(NSString *)keycode;
+ (NSString *)className;
+ (void)insertDummyUser;

@end

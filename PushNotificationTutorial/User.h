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
@property NSNumber *color;

// Array containing timings for custom knock
@property NSArray *knockTimings;

// Users access keycode
@property NSString *keycode;

@property (nonatomic, strong) PFFile *avatar;

- (User *)initWithName:(NSString *)name color:(NSNumber *)color knockTimings:(NSArray *)knockTimings keycode:(NSString *)keycode;

+ (NSString *)className;
+ (void)insertDummyUser;

@end

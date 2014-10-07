//
//  User.m
//  PushNotificationTutorial
//
//  Created by Miles Wright on 10/7/14.
//
//

#import "User.h"

@implementation User

- (User *)initWithName:(NSString *)name color:(NSInteger)color knockTimings:(NSArray *)knockTimings keycode:(NSString *)keycode {
    self = [super init];
    
    if (self) {
        self.name = name;
        self.color = color;
        self.knockTimings = knockTimings;
        self.keycode = keycode;
    }
    return self;
}

+ (NSString *)className {
    return @"user";
}

+ (void)insertDummyUser {
    NSString *name = @"Johnny Appleseed";
    
    NSInteger color = (NSInteger)230;
    
    NSTimeInterval interval1 = .120;
    NSTimeInterval interval2 = .120;
    NSTimeInterval interval3 = .120;
    NSTimeInterval interval4 = .120;
    NSTimeInterval interval5 = .120;
    NSArray *knockTimings = @[[NSNumber numberWithDouble:interval1], [NSNumber numberWithDouble:interval2], [NSNumber numberWithDouble:interval3], [NSNumber numberWithDouble:interval4], [NSNumber numberWithDouble:interval5]];
    
    NSString *keycode = @"1234";
    
    User *dummyUser = [[User alloc] initWithName:name color:color knockTimings:knockTimings keycode:keycode];
    [dummyUser saveInBackground];  
}

@end

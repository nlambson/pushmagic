//
//  User.m
//  PushNotificationTutorial
//
//  Created by Miles Wright on 10/7/14.
//
//

#import "User.h"

@implementation User

@synthesize name = _name;
@synthesize color = _color;
@synthesize knockTimings = _knockTimings;
@synthesize keycode = _keycode;

#pragma mark - Custom Initializer

- (User *)initWithName:(NSString *)name color:(NSNumber *)color knockTimings:(NSArray *)knockTimings keycode:(NSString *)keycode {
    self = [super initWithClassName:[User className]];
    
    if (self) {
        self.name = name;
        self.color = color;
        self.knockTimings = knockTimings;
        self.keycode = @"1234";
    }
    return self;
}

#pragma mark - Properties

- (NSString *)name {
    return _name;
}

- (void)setName:(NSString *)name {
    _name = name;
    self[@"name"] = name;
}

- (NSNumber *)color {
    return _color;
}

- (void)setColor:(NSNumber *)color {
    _color = color;
    self[@"color"] = color;
}

- (NSArray *)knockTimings {
    return _knockTimings;
}

- (void)setKnockTimings:(NSArray *)knockTimings {
    _knockTimings = knockTimings;
    self[@"knockTimings"] = knockTimings;
}

- (NSString *)keycode {
    return _keycode;
}

- (void)setKeycode:(NSString *)keycode {
    _keycode = keycode;
    self[@"keycode"] = keycode;
}

#pragma mark - className

+ (NSString *)className {
    return @"user";
}

#pragma mark - Helper Methods

+ (void)insertDummyUser {
    NSString *name = @"Johnny Appleseed";
    
    NSNumber *color = [NSNumber numberWithInt:230];
    
    NSTimeInterval interval1 = .120;
    NSTimeInterval interval2 = .120;
    NSTimeInterval interval3 = .120;
    NSTimeInterval interval4 = .120;
    NSTimeInterval interval5 = .120;
    NSArray *knockTimings = @[[NSNumber numberWithDouble:interval1], [NSNumber numberWithDouble:interval2], [NSNumber numberWithDouble:interval3], [NSNumber numberWithDouble:interval4], [NSNumber numberWithDouble:interval5]];
    
    NSString *keycode = @"1234";
    
    User *dummyUser = [[User alloc] initWithName:name color:color knockTimings:knockTimings keycode:keycode];
    [dummyUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"succeeded");
        }
        else {
            NSLog(@"error: %@", error.localizedDescription);
        }

    }];
}

@end

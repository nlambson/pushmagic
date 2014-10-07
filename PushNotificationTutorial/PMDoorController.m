//
//  PMDoorController.m
//  PushNotificationTutorial
//
//  Created by Nathan Lambson on 10/7/14.
//
//

#import "PMDoorController.h"

@implementation PMDoorController

- (void) openDoorWithSuccess:(void(^)(void))success failure:(void(^)(NSError *error))failure {
    
    NSLog(@"Open the door");
    
    if (YES) {
        success();
    } else {
        failure(nil);
    }
    
}

@end

//
//  PMDoorController.h
//  PushNotificationTutorial
//
//  Created by Nathan Lambson on 10/7/14.
//
//

#import <Foundation/Foundation.h>

@interface PMDoorController : NSObject

- (void) openDoorWithSuccess:(void(^)(void))success failure:(void(^)(NSError *error))failure;

@end

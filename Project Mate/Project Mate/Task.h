//
//  Task.h
//  Project Mate
//
//  Created by Alex Xia on 5/18/13.
//  Copyright (c) 2013 Cloud Computing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Task : NSObject
@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSString *desc;
@property(strong, nonatomic) NSDate *deadline;
@property(strong, nonatomic) NSString *taskid;
@property(strong, nonatomic) NSString *status;
@property(strong, nonatomic) NSString *owner;
@property(strong, nonatomic) NSString *parentProj;
@property(strong, nonatomic) NSMutableArray *users;
@property(strong, nonatomic) User *ownerinfo;
@end

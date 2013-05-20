//
//  MyProject.h
//  Project Mate
//
//  Created by Zongheng Wang on 5/19/13.
//  Copyright (c) 2013 Cloud Computing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyProject : NSObject

@property (nonatomic, strong) NSString *title, *description, *owner;
@property (nonatomic, strong) NSDate *starttime, *deadline;
@property (nonatomic, strong) NSMutableArray *members, *tasks;
@property NSInteger state;
@property NSInteger proid;

@end

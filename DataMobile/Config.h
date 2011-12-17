//
//  Config.h
//  DataMobile
//
//  Created by Kim Sawchuk on 11-12-16.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject

@property (strong, nonatomic) NSDictionary* configs;

+(Config*)loadForFileName:(NSString*)name;
+(Config*)instance;

-(id)valueForKey:(NSString*)key;

@end

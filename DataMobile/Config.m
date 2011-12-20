//
//  Config.m
//  DataMobile
//
//  Created by Kim Sawchuk on 11-12-16.
//  Copyright (c) 2011 MML-Concordia. All rights reserved.
//

#import "Config.h"

@implementation Config

@synthesize configs;

static Config* instance;
static BOOL initialized = NO;

/**
 * Singleton implementation
 */
+ (void)initialize
{
    if(!initialized)
    {
        initialized = YES;
        instance = [[Config alloc] init];
    }
}

+(Config*)loadForFileName:(NSString*)name
{
    initialized = NO;    
    [Config initialize];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:name
                                                     ofType:@"plist"];
    instance.configs = [NSDictionary dictionaryWithContentsOfFile:path];    
    return instance;
}

+(Config*)instance
{
    return instance;
}

-(id)valueForKey:(NSString*)key
{
    return [self.configs valueForKey:key];
}

-(NSString*)stringValueForKey:(NSString*)key
{
    return (NSString*)[self valueForKey:key];
}

-(int)integerValueForKey:(NSString*)key
{
    NSString *value = (NSString*)[self stringValueForKey:key];
    return [value intValue];
}

@end

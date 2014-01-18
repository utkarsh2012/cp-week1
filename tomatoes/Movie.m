//
//  Movie.m
//  tomatoes
//
//  Created by Utkarsh Sengar on 1/18/14.
//  Copyright (c) 2014 area42. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self){
        self.title = dict[@"title"];
        self.synopsis = dict[@"synopsis"];
        self.cast =[dict[@"cast"] componentsJoinedByString:@","];
        self.image = dict[@"image"];
    }
    
    return self;
}

//- (NSString *)cast{
//    //Print this
//    return @"Test";
//}

@end

//
//  Movie.h
//  tomatoes
//
//  Created by Utkarsh Sengar on 1/18/14.
//  Copyright (c) 2014 area42. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSString  *synopsis;
@property (nonatomic, strong) NSString  *cast;
@property (nonatomic, strong) NSString  *image;
- (id)initWithDictionary:(NSDictionary *)dict;

@end

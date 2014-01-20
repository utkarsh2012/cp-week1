//
//  MovieCell.h
//  tomatoes
//
//  Created by Utkarsh Sengar on 1/17/14.
//  Copyright (c) 2014 area42. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *movieTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *movieSynopsisLabel;
@property (nonatomic, weak) IBOutlet UILabel *movieCastLabel;
@property (nonatomic, weak) IBOutlet UIImageView *movieImage;

@end

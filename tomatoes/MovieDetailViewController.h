//
//  MovieDetailViewController.h
//  tomatoes
//
//  Created by Utkarsh Sengar on 1/20/14.
//  Copyright (c) 2014 area42. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "movie.h"

@interface MovieDetailViewController : UIViewController
@property (nonatomic, strong) Movie *movie;

@property (nonatomic, weak) IBOutlet UILabel *movieTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *movieSynopsisLabel;
@property (nonatomic, weak) IBOutlet UILabel *movieCastLabel;
@property (nonatomic, weak) IBOutlet UIImageView *movieImage;

- (IBAction)closeButtonPressed:(id)sender;

@end

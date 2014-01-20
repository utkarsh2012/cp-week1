//
//  MovieDetailViewController.m
//  tomatoes
//
//  Created by Utkarsh Sengar on 1/20/14.
//  Copyright (c) 2014 area42. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "Movie.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetailViewController ()

@end

@implementation MovieDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self){
        
    }
    return self;
}

- (IBAction)closeButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.movie.title;
    self.movieCastLabel.text = self.movie.cast;
    self.movieSynopsisLabel.text = self.movie.synopsis;
    NSURL *url = [[NSURL alloc] initWithString:self.movie.image];
    [self.movieImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

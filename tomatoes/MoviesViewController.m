//
//  MoviesViewController.m
//  tomatoes
//
//  Created by Utkarsh Sengar on 1/17/14.
//  Copyright (c) 2014 area42. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieDetailViewController.h"
#import "MovieCell.h"
#import "Movie.h"
#import "UIImageView+AFNetworking.h"

@interface MoviesViewController ()
@property (nonatomic, strong) NSMutableArray *movies;
- (void) reload;
@end

@implementation MoviesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self reload];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self){
        [self reload];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Movies";
	// Do any additional setup after loading the view.
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.movies.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieCell *cell = (MovieCell *)[tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    Movie *movie = self.movies[indexPath.row];
    cell.movieTitleLabel.text = movie.title;
    cell.movieSynopsisLabel.text = movie.synopsis;
    cell.movieCastLabel.text = movie.cast;
    
    NSURL *url = [[NSURL alloc] initWithString:movie.image];
    [cell.movieImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];

    return cell;
}


- (void) reload{
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@", object);
        
        NSMutableArray *movies = [[NSMutableArray alloc] init];
        for(NSDictionary *movie in [object objectForKey:@"movies"]){
            NSMutableDictionary *movie_holder = [[NSMutableDictionary alloc] init];
            for(NSDictionary *c in movie[@"abridged_cast"]){
                if([movie_holder objectForKey:@"cast"]){
                    NSMutableArray *cast = [movie_holder objectForKey:@"cast"];
                    [cast addObject:c[@"name"]];
                    [movie_holder setObject:cast forKey:@"cast"];
                } else {
                    NSMutableArray *cast = [[NSMutableArray alloc] init];
                    [cast addObject:c[@"name"]];
                    [movie_holder setObject:cast forKey:@"cast"];
                }

            }
            [movie_holder setObject:movie[@"title"] forKey:@"title"];
            [movie_holder setObject:movie[@"synopsis"] forKey:@"synopsis"];
            [movie_holder setObject:movie[@"posters"][@"original"] forKey:@"image"];
            //[movie_holder setObject:@"http://www.williamhadams.com/wp-content/uploads/2013/06/Superman-Poster.jpg" forKey:@"image"];
            Movie *movie_obj = [[Movie alloc] initWithDictionary:movie_holder];
            [movies addObject:movie_obj];
        }
        
        self.movies = movies;
        [self.tableView reloadData];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *selectedCell = (UITableViewCell *)sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:selectedCell];
    Movie *movie = self.movies[indexPath.row];
    
    MovieDetailViewController *movieDetailViewController = (MovieDetailViewController *)segue.destinationViewController;
    movieDetailViewController.movie = movie;
}

@end

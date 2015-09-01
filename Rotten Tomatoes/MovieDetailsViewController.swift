//
//  MovieDetailsViewController.swift
//  Rotten Tomatoes
//
//  Created by Andrew Wilkes on 8/26/15.
//  Copyright (c) 2015 Andrew Wilkes. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var criticRatingLabel: UILabel!
    @IBOutlet weak var audienceRatingLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var detailsView: UIView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize.height = 800

        titleLabel.text = movie["title"] as? String
        titleLabel.sizeToFit()
        
        synopsisLabel.text = movie["synopsis"] as? String
        synopsisLabel.sizeToFit()
        
        movieRatingLabel.text = movie["mpaa_rating"] as? String
        movieRatingLabel.sizeToFit()
    
        criticRatingLabel.text = String(movie.valueForKeyPath("ratings.critics_score") as! Int) + "%"
        criticRatingLabel.sizeToFit()
        
        audienceRatingLabel.text = String(movie.valueForKeyPath("ratings.audience_score") as! Int) + "%"
        audienceRatingLabel.sizeToFit()
        
        var urlString = movie.valueForKeyPath("posters.thumbnail") as! String
        
        let thumbnail = UIImageView()
        thumbnail.setImageWithURL(NSURL(string: urlString)!)
        
        var range = urlString.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        if let range = range {
            urlString = urlString.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
        
        let url = NSURL(string: urlString)!
        
        imageView.setImageWithURL(url)
        
        let request = NSURLRequest(URL: url)
        
        imageView.setImageWithURLRequest(request,
            placeholderImage: thumbnail.image,
            success: {
                (req, resp, image) -> Void in
                    self.imageView.image = image
            },
            failure: {
                (a, b, c) -> Void in
            }
        );
        
        self.navigationItem.title = movie["title"] as? String
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.cyanColor()]
        navigationController!.navigationBar.tintColor = UIColor.cyanColor()
        
        let height = CGRectGetMaxY(detailsView.frame)
        
        detailsView.frame = CGRectMake(0, 0, detailsView.frame.width, synopsisLabel.frame.height + 75)
        
        scrollView.contentSize = CGSizeMake(self.scrollView.bounds.width, detailsView.frame.height + 350)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

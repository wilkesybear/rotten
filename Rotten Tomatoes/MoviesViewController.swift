//
//  MoviesViewController.swift
//  
//
//  Created by Andrew Wilkes on 8/26/15.
//
//

import UIKit
import SwiftLoader

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?
    
    var url: NSURL?
    
    var navTitle: String?
    
    var refreshControl: UIRefreshControl!

    @IBOutlet weak var movieNavigationItem: UINavigationItem!
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet weak var networkErrorView: NetworkErrorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkErrorView.hidden = true
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = UIColor.cyanColor()
        
        var config = SwiftLoader.Config()
        config.size = 200
        config.backgroundColor = UIColor.blackColor()
        config.spinnerColor = UIColor.cyanColor()
        SwiftLoader.setConfig(config)
        
        self.navigationItem.title = navTitle!
        
        navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.cyanColor()]
        
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        
        cell.titleLabel?.text = movie["title"] as? String
        cell.synopsisLabel?.text = movie["synopsis"] as? String
        
        let url = NSURL(string: movie.valueForKeyPath("posters.thumbnail") as! String)!
        
        cell.posterView.setImageWithURL(url)
        
        return cell
    }
    
    func loadData() {
        SwiftLoader.show(animated: true)
        let request = NSURLRequest(URL: self.url!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data:NSData!, error: NSError!) -> Void
            in
            let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
            if let json = json {
                self.movies = json["movies"] as? [NSDictionary]
                self.tableView.reloadData()
            } else {
                self.networkErrorView.alpha = 0
                self.networkErrorView.hidden = false
                UIView.animateWithDuration(0.7, delay: 1.0, options: .CurveEaseOut, animations:
                    {
                        self.networkErrorView.alpha = 1
                    },
                    completion :
                    {
                        finished in
                        println("Done animating")
                    }
                )
            }
            SwiftLoader.hide()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)!
        
        let movie = movies![indexPath.row]
        
        let movieDetailsController = segue.destinationViewController as! MovieDetailsViewController
        
        movieDetailsController.movie = movie;
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        self.loadData()
        self.refreshControl.endRefreshing()
//        delay(2, closure: {
//            self.loadData()
//            self.refreshControl.endRefreshing()
//        })
    }
    
    
}

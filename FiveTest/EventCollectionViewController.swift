//
//  EventCollectionViewController.swift
//  FiveTest
//
//  Created by Ethan Hess on 9/3/15.
//  Copyright (c) 2015 Ethan Hess. All rights reserved.
//

import UIKit

class EventCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var events : [String]? = []
    var testImages : [String]? = []
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        events = ["Homer","Marge","Bart","Lisa","Maggie"]
        testImages = ["", "", "", "", ""]
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.events!.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell : EventCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! EventCell
        
        cell.eventTitleLabel.text = self.events![indexPath.row]
        cell.eventBackgroundImage.image = UIImage(named: testImages![indexPath.row])
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
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

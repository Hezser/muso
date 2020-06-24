//
//  PagesController.swift
//  Muso
//
//  Created by Sergio Hernandez on 20/07/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import Foundation

class PagesController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pages = [UIViewController]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        Model.pagesController = self
        
        let musicPage = storyboard?.instantiateViewController(withIdentifier: "MusicTabController") as! MusicTabController
        let searchPage = storyboard?.instantiateViewController(withIdentifier: "SearchNavigator") as! Navigator
        
        pages.append(musicPage)
        pages.append(searchPage)
        
        setViewControllers([musicPage], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        var previousIndex = abs((currentIndex - 1) % pages.count)
        if (currentIndex == 0)
        {
            // Adjust accordingly to number of pages (for three pages, the last index would be 2)
            previousIndex = 1
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        let nextIndex = abs((currentIndex + 1) % pages.count)
        return pages[nextIndex]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 1
    }

}

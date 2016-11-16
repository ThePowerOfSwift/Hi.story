//
//  HomeViewController.swift
//  Hi.story
//
//  Created by bl4ckra1sond3tre on 5/20/16.
//  Copyright © 2016 bl4ckra1sond3tre. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIPageViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl! {
        didSet {
            segmentedControl.removeAllSegments()
            (0..<Channel.count).forEach({
                let channel = Channel(rawValue: $0)
                segmentedControl.insertSegment(withTitle: channel?.title, at: $0, animated: false)
            })
        }
    }
    
    fileprivate enum Channel: Int {
        case today = 0
        case history
        
        var index: Int {
            return rawValue
        }
        
        var title: String? {
            switch self {
            case .today: return "Today"
            case .history: return "History"
            }
        }
        
        static var count: Int {
            return Channel.history.rawValue + 1
        }
    }
    
    fileprivate lazy var historyViewController: HistoryViewController = {
        
        let vc = UIStoryboard.hi.storyboard(.home).instantiateViewController(withIdentifier: HistoryViewController.identifier) as! HistoryViewController
        
        return vc
    }()
    
    fileprivate lazy var todayViewController: TodayViewController = {
        
        let vc = UIStoryboard.hi.storyboard(.home).instantiateViewController(withIdentifier: TodayViewController.identifier) as! TodayViewController
        
        return vc
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectingChannel(.today)

        segmentedControl.rx.value
            .subscribe(onNext: { [weak self] index in
                self?.selecting(at: index)
            })
            .addDisposableTo(disposeBag)
        
        self.dataSource = self
        self.delegate = self
    }
    
    private func selecting(at index: Int) {
        guard let channel = Channel(rawValue: index) else { return }
        
        selectingChannel(channel)
    }
    
    fileprivate func selectingChannel(_ channel: Channel) {
        
        switch channel {
            
        case .history:
            setViewControllers([historyViewController], direction: .forward, animated: true, completion: nil)
            
        case .today:
            setViewControllers([todayViewController], direction: .reverse, animated: true, completion: nil)
        }
        
        segmentedControl.selectedSegmentIndex = channel.index
    }
}

// MARK: - UIViewControllerPreviewingDelegate

extension HomeViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if viewController == historyViewController {
            return todayViewController
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if viewController == todayViewController {
            return historyViewController
        }
        
        return nil
    }
}

// MARK: - UIPageViewControllerDelegate

extension HomeViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard completed else {
            return
        }
        
        if previousViewControllers.first == historyViewController {
            selectingChannel(.today)
        } else if previousViewControllers.first == todayViewController {
            selectingChannel(.history)
        }
    }
}



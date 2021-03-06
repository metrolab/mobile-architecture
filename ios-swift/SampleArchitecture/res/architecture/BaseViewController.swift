//
//  BaseViewController.swift
//  SampleArchitecture
//
//  Created by Eli Kohen on 02/02/2018.
//  Copyright © 2018 Metropolis Lab. All rights reserved.
//

import UIKit

class BaseViewController<V>: UIViewController, ViewControllerExtended where V: ViewModel {
    
    // VM & active
    private(set) var viewModel: V
    private var subviews: [SubView]
    private var vcLifeCycle = ViewControllerLifeCycle()
    
    var active: Bool = false {
        didSet {
            subviews.forEach { $0.active = active }
        }
    }
    
    
    // MARK: Lifecycle
    
    init(viewModel: V, nibName: String? = nil) {
        self.viewModel = viewModel
        self.subviews = []
        super.init(nibName: nibName, bundle: nil)
        vcLifeCycle.viewController = self
        vcLifeCycle.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vcLifeCycle.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        vcLifeCycle.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        vcLifeCycle.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        vcLifeCycle.viewDidLayoutSubviews()
    }
    
    func viewWillFirstAppear(_ animated: Bool) {
        // implement in subclasses
    }
    
    func viewDidFirstAppear(_ animated: Bool) {
        // implement in subclasses
    }
    
    func viewDidFirstLayoutSubviews() {
        // implement in subclasses
    }
    
    func viewWillAppear(fromBackground: Bool) {
        // implement in subclasses
    }
    
    func viewWillDisappear(toBackground: Bool) {
        // implement in subclasses
    }

    
    // MARK: > Subview handling
    
    func add<T>(subview: T) where T: UIView, T: SubView {
        //Adding visually
        if !view.subviews.contains(subview) {
            view.addSubview(subview)
        }
        
        //Adding to managed subviews
        if !subviews.contains(where: { $0 === subview }) {
            subviews.append(subview)
            
            //Set current state to subview
            subview.active = self.active
        }
    }
    
    func remove<T>(subview: T) where T: UIView, T: SubView {
        // Removing visually
        if view.subviews.contains(subview) {
            subview.removeFromSuperview()
        }
        
        if subviews.contains(where: { $0 === subview }) {
            subviews = subviews.filter { return $0 !== subview }
            
            //Set inactive state to subview
            subview.active = false
        }
    }
}

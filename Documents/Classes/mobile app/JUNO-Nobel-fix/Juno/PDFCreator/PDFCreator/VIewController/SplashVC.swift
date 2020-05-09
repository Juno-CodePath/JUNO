//
//  SplashVC.swift
//  PDFCreator
//
//  Created by Lahiru Chathuranga on 12/28/19.
//  Copyright © 2019 Lahiru Chathuranga. All rights reserved.
//

import UIKit
import Lottie

class SplashVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var titleLabel: GradientLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    func setupUI() {
        titleLabel.gradientColors = [UIColor(red:0.73, green:0.47, blue:0.16, alpha:1).cgColor, UIColor(red:0.96, green:0.82, blue:0.44, alpha:1).cgColor]
        let path = Bundle.main.path(forResource: "logo",
                                    ofType: "json") ?? ""
        animationView.animation = Animation.filepath(path)
        animationView.loopMode = .loop
        animationView.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            let story = UIStoryboard(name: "Main", bundle:nil)
            let nc = story.instantiateViewController(withIdentifier: "MainNC")
            UIApplication.shared.windows.first?.rootViewController = nc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            
        })
    }
}

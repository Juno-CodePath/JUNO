//
//  SignatureVC.swift
//  PDFCreator
//
//  Created by Lahiru Chathuranga on 2/22/20.
//  Copyright © 2020 Lahiru Chathuranga. All rights reserved.
//

import UIKit
import TouchDraw
import RxCocoa
import RxSwift

protocol SignatureVCDelegate {
    func didSetSignature(signature: UIImage)
}

class SignatureVC: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var touchDrawView: TouchDrawView!
    @IBOutlet weak var attachIdButton: UIButton!
    @IBOutlet weak var trashButton: UIBarButtonItem!
    
    
    // MARK: Variables
    var signatureExport: UIImage?
    let bag = DisposeBag()
    var delegate: SignatureVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        touchDrawView.setWidth(3)
        touchDrawView.setColor(.green)
        addObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        touchDrawView.clearDrawing()
        signatureExport = nil
    }
    
    func addObservers() {
        trashButton.rx.tap
            .subscribe() {[weak self] event in
                self?.pressedTrashButton()
        }
        .disposed(by: bag)
        
        attachIdButton.rx.tap
            .subscribe() {[weak self] event in
                self?.pressedAddSignastureButton()
        }
        .disposed(by: bag)
    }
    
    func pressedTrashButton() {
        touchDrawView.clearDrawing()
        signatureExport = nil
    }
    
    func pressedAddSignastureButton() {
        if touchDrawView.exportStack().count > 0 {
            self.signatureExport = touchDrawView.exportDrawing()
            self.delegate?.didSetSignature(signature: self.signatureExport!)
            navigationController?.popViewController(animated: true)
        }
    }
}


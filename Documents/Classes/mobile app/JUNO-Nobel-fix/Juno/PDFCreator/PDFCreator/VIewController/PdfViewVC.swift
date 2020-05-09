//
//  PdfViewVC.swift
//  PDFCreator
//
//  Created by Lahiru Chathuranga on 2/19/20.
//  Copyright © 2020 Lahiru Chathuranga. All rights reserved.
//

import UIKit
import PDFKit
import VisionKit
import RxSwift
import RxCocoa

class PdfViewVC: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var addSignatureButton: UIBarButtonItem!
    
    // MARK: Variables
    var pdfDocument = PDFDocument()
    var pdfView = PDFView()
    var localPDF: _LocalPDF?
    let bag = DisposeBag()
    var signatureImage: UIImage?
    var currentlySelectedAnnotation: PDFAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signatureImage  = UIImage(named: "scanner")
        setupUI()
        addObservers()
        showPdfData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showPdfData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let signatureImage = signatureImage, let page = pdfView.currentPage else { return }
        
        let pageBounds = page.bounds(for: .artBox)
        
        // lets just add the image to the center of the pdf page with a width of 200px and a height of 100 px
        let imageBounds = CGRect(x: pageBounds.midX, y: pageBounds.midY,  width: 200, height: 100)
        
        // Now we can add our stamp as a annotation of the current pdf page
        let imageStamp = ImageStampAnnotation(with: signatureImage,  forBounds: imageBounds, withProperties: nil)
        
        page.addAnnotation(imageStamp)
    }
    
    
    func setupUI() {
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
        
        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    func addObservers() {
        addSignatureButton.rx.tap
            .subscribe() {[weak self] event in
                self?.pressedAddSignatureButton()
        }
        .disposed(by: bag)
    }
    
    func showPdfData() {
        if let _pdfFile = localPDF {
            
            let url: URL = URL(string: _pdfFile.fileUrl)!
            pdfView.displayMode = .singlePageContinuous
            pdfView.autoScales = true
            pdfView.displayDirection = .vertical
            pdfView.document = PDFDocument(url: url)
            
            let panAnnotationGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanAnnotation(sender:)))
            pdfView.addGestureRecognizer(panAnnotationGesture)
            
        }
    }
    
    func pressedAddSignatureButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignatureVC") as! SignatureVC
        vc.delegate  = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didPanAnnotation(sender: UIPanGestureRecognizer) {
        let touchLocation = sender.location(in: pdfView)
        
        guard let page = pdfView.page(for: touchLocation, nearest: true) else {return}
        
        let locationOnPage = pdfView.convert(touchLocation, to:  page)
        
        switch sender.state {
        case .began:
            guard let annotation = page.annotation(at: locationOnPage) else {   return }
            if annotation.isKind(of: ImageStampAnnotation.self) {
                currentlySelectedAnnotation = annotation
            }
            
        case .changed:
            guard let annotation = currentlySelectedAnnotation else {return }
            let initialBounds = annotation.bounds
            // Set the center of the annotation to the spot of our finger
            annotation.bounds = CGRect(x: locationOnPage.x - (initialBounds.width / 2), y: locationOnPage.y - (initialBounds.height / 2), width: initialBounds.width, height: initialBounds.height)
            
        case .ended, .cancelled, .failed:
            currentlySelectedAnnotation = nil
            
        default:
            break
        }
    }
}

extension PdfViewVC: SignatureVCDelegate {
    func didSetSignature(signature: UIImage) {
        self.signatureImage  = signature
    }
}

//
//  MainVC.swift
//  PDFCreator
//
//  Created by Lahiru Chathuranga on 12/27/19.
//  Copyright © 2019 Lahiru Chathuranga. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import VisionKit
import PDFKit
import Lottie

class MainVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var scannerImageView: UIImageView!
    @IBOutlet weak var scannerButton: UIButton!
    @IBOutlet weak var ViewPdfButton: UIButton!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var titleLabel: GradientLabel!
    
    // MARK: - Variable
    let bag = DisposeBag()
    var pdfDocument = PDFDocument()
    var pdfView : PDFView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        navigationController?.navigationBar.isHidden = true
    }
    
    func setupUI() {
        scannerImageView.layer.cornerRadius = 25.0
        scannerImageView.clipsToBounds = true
        titleLabel.gradientColors = [UIColor(red:0.73, green:0.47, blue:0.16, alpha:1).cgColor, UIColor(red:0.96, green:0.82, blue:0.44, alpha:1).cgColor]
        
        let path = Bundle.main.path(forResource: "animation",
                                    ofType: "json") ?? ""
        animationView.animation = Animation.filepath(path)
        animationView.loopMode = .loop
        animationView.play()
    }
    
    func addObservers() {
        scannerButton.rx.tap
            .subscribe() {[weak self] event in
                self?.pressedScannerButton()
        }
        .disposed(by: bag)
        
        ViewPdfButton.rx.tap
            .subscribe() {[weak self] event in
                self?.pressedViewPdfButton()
        }
        .disposed(by: bag)
    }
    
    func pressedScannerButton() {
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        present(documentCameraViewController, animated: true)
    }
    
    func pressedViewPdfButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PDFListVC")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func getSingleFileFromDisk() -> String {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let docURL = documentDirectory.appendingPathComponent("Scanned-Docs.pdf").absoluteString
        
        return docURL
    }
    
    func savePDFWithDetails() {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Enter PDF name", message: "Enter a name for this PDF file", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "name"
            textField.keyboardType = .alphabet
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            let fileUrl = self.getSingleFileFromDisk()
            let _pdfData = LocalPDF(name: textField?.text, date: formatter.string(from: Date()), url: fileUrl)
            _LocalPDF.savePdfFile(file: _pdfData)
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension MainVC: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        
        guard scan.pageCount >= 1 else {
            controller.dismiss(animated: true)
            return
        }
        
        DispatchQueue.main.async {
            
            let pdfDocument = PDFDocument()
            
            for i in 0 ..< scan.pageCount {
                if let image = scan.imageOfPage(at: i).resize(toWidth: 720){
                    print("image size is \(image.size.width), \(image.size.height)")
                    // Create a PDF page instance from your image
                    let pdfPage = PDFPage(image: image)
                    // Insert the PDF page into your document
                    pdfDocument.insert(pdfPage!, at: i)
                }
            }
            
            // Get the raw data of your PDF document
            let data = pdfDocument.dataRepresentation()
            
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let docURL = documentDirectory.appendingPathComponent("Scanned-Docs.pdf")
            do{
                try data?.write(to: docURL)
            }catch(let error)
            {
                print("error is \(error.localizedDescription)")
            }
            
        }
        controller.dismiss(animated: true, completion: {
            self.savePDFWithDetails()
        })
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print(error)
            controller.dismiss(animated: true)
        }
        
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true)
        }
    }
}

struct LocalPDF {
    var name: String?
    var date: String?
    var url: String?
    
    init(name: String?, date: String?, url: String?) {
        self.name = name
        self.date = date
        self.url = url
    }
}

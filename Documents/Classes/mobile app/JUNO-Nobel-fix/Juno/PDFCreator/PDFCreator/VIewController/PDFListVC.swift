//
//  PDFListVC.swift
//  PDFCreator
//
//  Created by Lahiru Chathuranga on 12/28/19.
//  Copyright © 2019 Lahiru Chathuranga. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PDFListVC: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView! {didSet {
        tableView.rx.setDelegate(self).disposed(by: bag)
        }}
    
    
    @IBOutlet weak var searchBar: UISearchBar! {didSet {
        searchBar.delegate = self
        }}
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    
    
    
    // MARK: - Variables
    let vm: PDFListVM = PDFListVM()
    let bag = DisposeBag()
    let cellIdentifire = "pdfListCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        addObservers()
        getPDFList()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.isHidden = false
    }
    
    func setupUI() {
        pressedNameButton()
    }
    
    func addObservers() {
        vm.pdfFilteredList.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifire, cellType: PDFListTVCell.self)) { row, model, cell in
                cell.configureCell(with: model)
        }
        .disposed(by: bag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                if let item = self?.vm.pdfDocList.value[indexPath.row] {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "PDFView") as! PdfViewVC
                    vc.localPDF = item
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            })
            .disposed(by: bag)
        
        dateButton.rx.tap
            .subscribe() {[weak self] event in
                self?.pressedDateButton()
        }
        .disposed(by: bag)
        
        nameButton.rx.tap
            .subscribe() {[weak self] event in
                self?.pressedNameButton()
        }
        .disposed(by: bag)
    }
    
    func getPDFList() {
        vm.getLocalPDFRequest { (success, message) in
            if !success {
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "Dismiss", style: .default) { (action) in
                    self.dismiss(animated: true, completion: nil)
                    
                }
                alert.addAction(action)
                self.present(alert, animated: true)
                
            }
        }
    }
    
    func pressedDateButton() {
        changeButtonColor(active: .date, inactive: .name)
        vm.pdfFilteredList.value = vm.pdfDocList.value.sorted { $0.date < $1.date }
    }
    
    func pressedNameButton() {
        changeButtonColor(active: .name, inactive: .date)
        vm.pdfFilteredList.value = vm.pdfDocList.value.sorted { $0.name < $1.name }
    }
    
    func changeButtonColor(active: Button, inactive: Button) {
        if active == .date {
            dateButton.isUserInteractionEnabled = false
            dateButton.addLayerEffects(cornerRadius: 6.0)
            dateButton.applyGradient(isTopBottom: false, colorArray: [UIColor(red:0.73, green:0.47, blue:0.16, alpha:1), UIColor(red:0.96, green:0.82, blue:0.44, alpha:1)])
            dateButton.setTitleColor(.black, for: .normal)
            
            if nameButton.layer.sublayers?.count != 0 {
                nameButton.layer.sublayers?.remove(at: 0)
            }
            nameButton.isUserInteractionEnabled = true
            nameButton.setTitleColor(.buttonBackgroundColor, for: .normal)
            nameButton.addLayerEffects(with: UIColor(red:0.82, green:0.61, blue:0.2, alpha:1), borderWidth: 1.0, cornerRadius: 6.0)
            
        } else {
            nameButton.isUserInteractionEnabled = false
            nameButton.addLayerEffects(cornerRadius: 6.0)
            nameButton.applyGradient(isTopBottom: false, colorArray: [UIColor(red:0.73, green:0.47, blue:0.16, alpha:1), UIColor(red:0.96, green:0.82, blue:0.44, alpha:1)])
            nameButton.setTitleColor(.black, for: .normal)
            
            
            if dateButton.layer.sublayers?.count != 0 {
                dateButton.layer.sublayers?.remove(at: 0)
            }
            dateButton.isUserInteractionEnabled = true
            dateButton.setTitleColor(.buttonBackgroundColor, for: .normal)
            dateButton.addLayerEffects(with: UIColor(red:0.82, green:0.61, blue:0.2, alpha:1), borderWidth: 1.0, cornerRadius: 6.0)
            
        }
    }
    
}
extension PDFListVC: UITableViewDelegate, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 163.0
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        vm.pdfFilteredList.value = searchText.isEmpty ? vm.pdfDocList.value : vm.pdfFilteredList.value.filter {$0.name.contains(searchText.lowercased())}
        print(vm.pdfFilteredList.value.count)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

class PDFListVM: NSObject {
    
    var pdfDocList = Variable<[_LocalPDF]>([])
    var pdfFilteredList = Variable<[_LocalPDF]>([])
    
    func getLocalPDFRequest(completion: @escaping actionHandler) {
        if let realmPDFFiles = RealmService.shared.read(object: _LocalPDF.self) {
            var _pdfArr: [_LocalPDF] = []
            
            for realmPDFFile in realmPDFFiles {
                _pdfArr.append(realmPDFFile)
            }
            pdfDocList.value = _pdfArr
            pdfFilteredList.value = _pdfArr
            
            completion(true, "Success")
            
        } else {
            completion(false, "No data available")
        }
    }}

enum Button {
    case date, name
}

//
//  OrdersVC.swift
//  Liquorder
//
//  Created by 李建霖 on 2020/3/15.
//  Copyright © 2020 creationspace. All rights reserved.
//

import UIKit

class OrdersVC: BaseVC, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var labStartDate: UILabel!
    @IBOutlet weak var btnStartDate: UIButton!
    @IBOutlet weak var labEndDate: UILabel!
    @IBOutlet weak var btnEndDate: UIButton!
    @IBOutlet weak var tvOrders: UITableView!
    @IBOutlet weak var cvCellarers: UICollectionView!
    
    @IBAction func btnStartDateOnClick(_ sender: Any) {
        setDatePickerValue(sender: sender)
        hideDatePicker(isHidden: false)
    }
    
    @IBAction func btnEndDateOnClick(_ sender: Any) {
        setDatePickerValue(sender: sender)
        hideDatePicker(isHidden: false)
    }
    
    static let UNLIMITED = "不限"
    
    let CELL = "cell"
    let DATE_FORMATE = "yyyy-MM-dd"
    let SEGUE_TO_DETAIL = "segue2Detail"
    let CELLARER_FONT_SIZE = 17
    let DEFAULT_RANGE_DAYS = 30
    let dateFormatter = DateFormatter()
    var toolBar = UIToolbar()
    var datePicker  = UIDatePicker()
    var dicOrders: [Int: [Order]] = [:]
    var currentBtnDate: UIButton?
    
    var cellarers: [Cellarer] = [Cellarer(id: 0, name: OrdersVC.UNLIMITED, liaison: OrdersVC.UNLIMITED, mobile: "")] {
        didSet {
            DispatchQueue.main.async {
                self.cvCellarers.reloadData()
                self.cvCellarers.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: UICollectionView.ScrollPosition.left)
            }
        }
    }
    
    var allOrders: [Order]? {
        didSet {
            if allOrders != nil {
                setDicOrders(orders: allOrders!)
                orders = allOrders
                DispatchQueue.main.async {
                    self.cvCellarers.reloadData()
                    self.cvCellarers.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: UICollectionView.ScrollPosition.left)
                }
            }
        }
    }
    
    var orders: [Order]? {
        didSet {
            DispatchQueue.main.async {
                self.tvOrders.reloadData()
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getCellarers()
        initComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //initComponents()
    }
    
    func initComponents() {
        dateFormatter.dateFormat = DATE_FORMATE
        initSearchRange()
        initDatePicker()
        initToolBar()
    }
    
    func initSearchRange() {
        var date = Date()
        
        labEndDate.text = dateFormatter.string(from: date)
        date = Calendar.current.date(byAdding: .day, value: -DEFAULT_RANGE_DAYS, to: date)!
        labStartDate.text = dateFormatter.string(from: date)
        getOrders()
    }
    
    func initDatePicker() {
        datePicker = UIDatePicker.init()
        datePicker.backgroundColor = UIColor.white
        datePicker.autoresizingMask = .flexibleWidth
        datePicker.datePickerMode = .date
        //datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
        datePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        datePicker.isHidden = true
        self.view.addSubview(datePicker)
    }
    
    func initToolBar() {
        toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.onDoneButtonClick))]
        toolBar.sizeToFit()
        toolBar.isHidden = true
        self.view.addSubview(toolBar)
    }
    
    func hideDatePicker(isHidden: Bool) {
        datePicker.isHidden = isHidden
        toolBar.isHidden = isHidden
    }
    
    func setDatePickerValue(sender: Any) {
        if let btn = sender as? UIButton {
            var date = Date()
            
            if btn === btnStartDate {
                date = dateFormatter.date(from: labStartDate.text!) ?? date
            } else {
                date = dateFormatter.date(from: labEndDate.text!) ?? date
            }
            datePicker.setDate(date, animated: false)
            currentBtnDate = btn
        }
    }

    @objc func onDoneButtonClick() {
        if currentBtnDate == btnStartDate {
            labStartDate.text = dateFormatter.string(from: datePicker.date)
        } else {
            labEndDate.text = dateFormatter.string(from: datePicker.date)
        }
        hideDatePicker(isHidden: true)
        getOrders()
    }
    
    private func getCellarers() {
        let apiHandler = getBasicApiHandler()
        
        apiHandler.handler = { data in
            if let cellarers = data as? [Cellarer] {
                self.cellarers.append(contentsOf: cellarers)
            }
        }
        CellarerRepo.cellarerRepo.getCellarers(apiHandler: apiHandler)
    }
    
    private func setDicOrders(orders: [Order]) {
        dicOrders = [:]
        orders.forEach({ order in
            let index = order.merchantId
            
            if dicOrders[index] != nil {
                dicOrders[index]!.append(order)
            } else {
                dicOrders[index] = [ order ]
            }
        })
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellarers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL, for: indexPath) as! CellarerEasyCell
        let cellarer = cellarers[indexPath.row]

        cell.setCellarer(cellarer: cellarer)
        if cell.isSelected {
            cell.labName.font = UIFont.systemFont(ofSize: CGFloat(CELLARER_FONT_SIZE), weight: UIFont.Weight.bold)
        } else {
            cell.labName.font = UIFont.systemFont(ofSize: CGFloat(CELLARER_FONT_SIZE))
        }

        return cell
    }
     
    // MARK: - UICollectionViewDelegate

     
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
     
    // Uncomment this method to specify if the specified item should be selected
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
     
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CellarerEasyCell {
            cell.labName.font = UIFont.systemFont(ofSize: CGFloat(CELLARER_FONT_SIZE), weight: UIFont.Weight.bold)
            orders = (indexPath.row == 0) ? allOrders : dicOrders[cellarers[indexPath.row].id]
        }
    }
     
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CellarerEasyCell {
            cell.labName.font = UIFont.systemFont(ofSize: CGFloat(CELLARER_FONT_SIZE))
        }
     }
     
     //MARK: - UITableViewDataSource
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders?.count ?? 0
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tvOrders.dequeueReusableCell(withIdentifier: CELL, for: indexPath) as! OrderCell

        cell.setOrder(order: orders![indexPath.row])

        return cell
    }
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tvOrders.deselectRow(at: indexPath, animated: false)
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE_TO_DETAIL {
            let detailVC = segue.destination as! DetailVC
            let index = tvOrders.indexPathForSelectedRow!.row
            
            detailVC.order = orders![index]
            detailVC.reloadOrders = { () in self.getOrders() }
        }
    }

    //MARK: - call api
    
    private func getOrders() {
        let url = String(format: Api.Url.GET_ORDERS, labStartDate.text!, labEndDate.text!)
        
        AlamofireUtil.callApi(of: [Order].self, url: url, redirect2Login: redirect2Login) { data in
            if let orders = data.value {
                self.allOrders = orders
            } else {
                Util.printError(message: String(describing: data.error?.failureReason))
            }
        }
    }
}

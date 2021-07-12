//
//  CalculatorTableViewController.swift
//  StockEye
//
//  Created by Ankit Saxena on 12/07/21.
//

import UIKit

class CalculatorTableViewController: UITableViewController {
    
    @IBOutlet private weak var symbolLbl: UILabel!
    @IBOutlet private weak var nameLbl: UILabel!
    
    var asset: Asset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        symbolLbl.text = asset?.searchResult.symbol
        nameLbl.text = asset?.searchResult.name
    }
    
    
    
}

//
//  SearchTableViewCell.swift
//  StockEye
//
//  Created by Ankit Saxena on 07/07/21.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var assetNameLabel: UILabel!
    @IBOutlet private weak var assetSymbolLabel: UILabel!
    @IBOutlet private weak var assetTypeLabel: UILabel!
    
    func confureCell(with model: SearchResult) {
        assetNameLabel.text = model.name
        assetSymbolLabel.text = model.symbol
        assetTypeLabel.text = model.type.appending(" ").appending(model.currency)
    }
    
}

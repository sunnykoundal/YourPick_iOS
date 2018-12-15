
import Foundation
import UIKit

class PricesCell: UITableViewCell {
    
    @IBOutlet var pricesNameLbl: UILabel?
    @IBOutlet var pricesValueLbl: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configureCell(pricesName: String!, pricesValue: String!) {
        
        pricesNameLbl?.text = String(pricesName)
        pricesValueLbl?.text = String(pricesValue)
    }
}



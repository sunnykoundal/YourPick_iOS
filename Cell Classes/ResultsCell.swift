
import Foundation
import UIKit

class ResultsCell: UITableViewCell {
    
    @IBOutlet weak var draftView: UIView!
    @IBOutlet var draftNameLbl: UILabel?
    @IBOutlet var draftTypeLbl: UILabel?
    @IBOutlet var winningLbl: UILabel?
    @IBOutlet var gameTypeImage: UIImageView!
    @IBOutlet weak var draftTypeValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configureCell(entered: String ,draft: String, won: String, draftName: String, type: String) {
        
        draftTypeValue?.text = draft
        winningLbl?.text = won
        
        if type == "SOCCER" {
            draftTypeValue?.backgroundColor = UIColor(red: 254.0/255.0, green: 106.0/255.0, blue: 31.0/255.0, alpha: 1.0)
//            winningLbl?.textColor = UIColor(red: 254.0/255.0, green: 106.0/255.0, blue: 31.0/255.0, alpha: 1.0)
//            draftTypeValue?.textColor = UIColor(red: 254.0/255.0, green: 106.0/255.0, blue: 31.0/255.0, alpha: 1.0)
            draftNameLbl?.text = draftName + ", " + "Soccer Draft"
            gameTypeImage.image = #imageLiteral(resourceName: "Football_Logo")
        }else if type == "NFL" {
            draftTypeValue?.backgroundColor = UIColor(red: 0.0/255.0, green: 112.0/255.0, blue: 185.0/255.0, alpha: 1.0)
//            winningLbl?.textColor = UIColor(red: 0.0/255.0, green: 112.0/255.0, blue: 185.0/255.0, alpha: 1.0)
//            draftCountLbl?.textColor = UIColor(red: 0.0/255.0, green: 112.0/255.0, blue: 185.0/255.0, alpha: 1.0)
            draftNameLbl?.text = draftName + ", " + "NFL Draft"
            gameTypeImage.image = #imageLiteral(resourceName: "American_Football_Logo")
        }else if type == "NBA" {
            draftTypeValue?.backgroundColor = UIColor(red: 101.0/255.0, green: 72.0/255.0, blue: 160.0/255.0, alpha: 1.0)
//            winningLbl?.textColor = UIColor(red: 101.0/255.0, green: 72.0/255.0, blue: 160.0/255.0, alpha: 1.0)
//            draftCountLbl?.textColor = UIColor(red: 101.0/255.0, green: 72.0/255.0, blue: 160.0/255.0, alpha: 1.0)
            draftNameLbl?.text = draftName + ", " + "NBA Draft"
            gameTypeImage.image = #imageLiteral(resourceName: "Basketball_Logo")
        }
        
        draftTypeLbl?.text = draft  + "/" + draft
        
        draftView?.layer.cornerRadius = 0
        draftView?.layer.borderWidth = 1
        draftView?.layer.borderColor = UIColor(red: 147.0/255.0, green: 149.0/255.0, blue: 152.0/255.0, alpha: 0.4).cgColor
    }
}



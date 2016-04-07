
import UIKit
import Foundation

class NearbyFoodTableCell: UITableViewCell {
    
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var restaurantName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

import UIKit
import SDWebImage

class MyCardTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    fileprivate var myCards: [PrimoCard] = []
    fileprivate var tableType: PrimoCardType = .unknown
    var isOnEditing = false

    func Setup(tableType: PrimoCardType) {
        self.dataSource = self
        self.delegate = self
        
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = 58.0
        
        self.tableType = tableType
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCardCell", for: indexPath) as! MyCardTableCell
        
        cell.nameThLabel?.text = myCards[indexPath.row].nameTH
        
        cell.nameEnLabel?.text = myCards[indexPath.row].nameEN
        
        cell.cardImage?.sd_setImage(with: URL(string: myCards[indexPath.row].imgUrl),
                                    placeholderImage: UIImage(named: "card_error"))
        cell.cardImage.sd_setIndicatorStyle(.gray)
        
        if (isOnEditing) {
            cell.editButton.setImage(#imageLiteral(resourceName: "icon_false"), for: .normal)
            cell.editButton.removeTarget(nil, action: nil, for: .allEvents)
            cell.editButton.addTarget(self, action: #selector(DeleteCard(_:)), for: .touchUpInside)
        } else {
            cell.editButton.setImage(#imageLiteral(resourceName: "icon_true"), for: .normal)
        }
        cell.editButton.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - Edit Mode
    func ToggleEditMode() {
        isOnEditing = !isOnEditing
        reloadData()
    }
    
    func DeleteCard(_ sender: UIButton) {
        let card = myCards[sender.tag]
        if (CardDB.instance.deleteCard(cId: card.cardId)) {
            UpdateMyCards()
            print("Delete CardId:\(card.cardId)  Name:\(card.nameTH)")
        }
    }
    
    // MARK: - Update data
    func UpdateMyCards() {
        FilterCard()
        self.reloadData()
    }
    
    func FilterCard() {
        let allCards = CardDB.instance.getCards()
        myCards = allCards.filter({ card in
            var result = false
            if (tableType == .creditCard || tableType == .debitCard) {
                if (card.type == .creditCard || card.type == .debitCard) {
                    result = true
                }
            } else if (card.type == tableType) {
                result = true
            }
            return result
        })
        print("Found \(tableType) card count: \(myCards.count)")
    }
}

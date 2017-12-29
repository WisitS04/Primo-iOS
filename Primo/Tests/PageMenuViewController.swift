
import UIKit
import Alamofire
import SwiftyJSON
import Segmentio

struct CardNetword {
    var id: Int!
    var nameEN: String!
    var nameTH: String!
    var imgUrl: String!
    
    init(json: JSON) {
        id = json["id"].intValue
        nameEN = json["nameEng"].stringValue
        nameTH = json["name"].stringValue
        imgUrl = json["imgUrl"].stringValue
    }
}

class PageMenuViewController: UIViewController
{
    var segmentioView: Segmentio!
    @IBOutlet weak var bankCollection: BankCollectionView!
    var pagerView: FSPagerView!
    var pageControl: FSPageControl!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var cardResultTable: CardResultTableView!
    
    var cardNetworkList: [CardNetword] = []
    
    var cardType: Int = PrimoCardType.creditCard.rawValue
    var bankID: Int = -1
    var networkID: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        AddSegmentioView()
        SetUpSegmentioView()
        
        AddFSPage()
        
        pagerView.isHidden = true
        pageControl.isHidden = true
        resultLabel.isHidden = true
        cardResultTable.isHidden = true
        
        bankCollection.SetUp(viewController: self)
        cardResultTable.SetUp(viewController: self)
        
        bankCollection.LoadBankList(cardType: cardType)
    }
}

extension PageMenuViewController
{
    //
    // MARK: - SegmentView
    //
    func AddSegmentioView() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navigationBarHeight = self.navigationController?.navigationBar.bounds.height ?? 0
        let segmentioViewRect = CGRect(
            x: 0, y: statusBarHeight + navigationBarHeight,
            width: UIScreen.main.bounds.width,
            height: 50)
        //print("segmentioViewRect = \(segmentioViewRect)")
        segmentioView = Segmentio(frame: segmentioViewRect)
        self.view.addSubview(segmentioView)
    }
    
    func SetUpSegmentioView() {
        func Content() -> [SegmentioItem] {
            return [
                SegmentioItem(title: "บัตรเครดิต", image: nil),
                SegmentioItem(title: "บัตรเดบิต", image: nil)
            ]
        }
        
        func Option() -> SegmentioOptions {
            let segmentioIndicatorOptions = SegmentioIndicatorOptions(
                type: .bottom,
                ratio: 1,
                height: 5,
                color: .white
            )
            let segmentioHorizontalSeparatorOptions = SegmentioHorizontalSeparatorOptions(
                type: .topAndBottom, // Top, Bottom, TopAndBottom
                height: 0,
                color: .clear
            )
            let segmentioVerticalSeparatorOptions = SegmentioVerticalSeparatorOptions(
                ratio: 0.1, // from 0.1 to 1
                color: .clear
            )
            let segmentioStates = SegmentioStates(
                defaultState: SegmentioState(
                    backgroundColor: .clear,
                    titleFont: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                    titleTextColor: .white
                ),
                selectedState: SegmentioState(
                    backgroundColor: .clear,
                    titleFont: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                    titleTextColor: .white
                ),
                highlightedState: SegmentioState(
                    backgroundColor: .clear,
                    titleFont: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                    titleTextColor: .white
                )
            )
            return SegmentioOptions(
                backgroundColor: PrimoColor.Green.UIColor,
                maxVisibleItems: 2,
                scrollEnabled: false,
                indicatorOptions: segmentioIndicatorOptions,
                horizontalSeparatorOptions: segmentioHorizontalSeparatorOptions,
                verticalSeparatorOptions: segmentioVerticalSeparatorOptions,
                imageContentMode: .scaleAspectFit,
                labelTextAlignment: .center,
                labelTextNumberOfLines: 1,
                segmentStates: segmentioStates,
                animationDuration: 0.1
            )
        }
        // MARK: Setup
        segmentioView.setup(
            content: Content(),
            style: SegmentioStyle.onlyLabel,
            options: Option()
        )
        segmentioView.selectedSegmentioIndex = 0
        segmentioView.valueDidChange = OnSegmentValueDidChange
    }
    
    func OnSegmentValueDidChange(segmentio: Segmentio, segmentIndex: Int) {
        //print("Selected item: ", segmentIndex)
        if (segmentIndex == 0) {
            BankSelectIndex =  IndexPath(item: -1, section: -1)
            cardType = PrimoCardType.creditCard.rawValue // Select Credit
        } else {
             BankSelectIndex =  IndexPath(item: -1, section: -1)
            cardType = PrimoCardType.debitCard.rawValue // Select Debit
        }
        bankID = -1
        networkID = -1
        
        pagerView.isHidden = true
        pageControl.isHidden = true
        resultLabel.isHidden = true
        cardResultTable.isHidden = true
        bankCollection.LoadBankList(cardType: cardType)
    }
    
    //
    // MARK: - FSPager
    //
    func AddFSPage() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navigationBarHeight = self.navigationController?.navigationBar.bounds.height ?? 0.0
        let segmentHeight = segmentioView.bounds.height
        let segmentAndBankCollectionSpace: CGFloat = 2.0
        let bankCollectionHeight = bankCollection.bounds.height
        
        let pagerHeight: CGFloat = 90.0
        let pageControlHeight: CGFloat = 30.0
        
        func AddFSPager() {
            let pagerFrame = CGRect(
                x: 0,
                y: statusBarHeight + navigationBarHeight + segmentHeight + segmentAndBankCollectionSpace + bankCollectionHeight,
                width: UIScreen.main.bounds.width,
                height: pagerHeight)
            self.pagerView = FSPagerView(frame: pagerFrame)
            self.view.addSubview(self.pagerView)
            self.pagerView.dataSource = self
            self.pagerView.delegate = self
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.itemSize = CGSize(width: 100, height: 55)
            self.pagerView.interitemSpacing = 60
        }
        func AddFSPageControl() {
            let pageControlFrame = CGRect(
                x: 0,
                y: statusBarHeight + navigationBarHeight + segmentHeight + segmentAndBankCollectionSpace + bankCollectionHeight + pagerHeight,
                width: UIScreen.main.bounds.width,
                height: pageControlHeight)
            self.pageControl = FSPageControl(frame: pageControlFrame)
            self.view.addSubview(self.pageControl)
            self.pageControl.numberOfPages = cardNetworkList.count
            self.pageControl.contentHorizontalAlignment = .center
            self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            self.pageControl.setStrokeColor(.gray, for: .normal)
            self.pageControl.setStrokeColor(.gray, for: .selected)
            self.pageControl.setFillColor(.gray, for: .selected)
        }
        AddFSPager()
        AddFSPageControl()
    }
    
    //
    // MARK: - Call Service
    //
    func CallCardNetworkService() {
        LoadingOverlay.shared.showOverlay(view: self.view)
        Alamofire.request(Service.CardNetwork.url)
            .authenticate(user: Service_User, password: Service_Password)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.cardNetworkList.removeAll()
                    for (_, subJson):(String, JSON) in json["data"]
                    {
                        let cardNetwork = CardNetword(json: subJson)
                        self.cardNetworkList.append(cardNetwork)
                    }
                    self.OnGotCardNetwork(count: self.cardNetworkList.count)
                    self.cardResultTable.LoadData(bankId: self.bankID,
                                                  cardType: self.cardType,
                                                  cardNetwork: self.networkID)
                    self.pagerView.reloadData()
                    print("Call CardNetwork service success")
                    LoadingOverlay.shared.hideOverlayView()
                case .failure(let error):
                    print(error)
                    LoadingOverlay.shared.hideOverlayView()
                }
        }
    }
    
    //
    // MARK: - Call back
    //
    func OnBankSelected(id: Int) {
        bankID = id
        CallCardNetworkService()
        pagerView.isHidden = false
        pageControl.isHidden = false
    }
    
    func OnGotCardNetwork(count: Int) {
        networkID = cardNetworkList[pagerView.currentIndex].id
        pageControl.numberOfPages = count
        resultLabel.isHidden = false
        cardResultTable.isHidden = false
    }
    
    func OnGotCardResult(count: Int) {
        resultLabel.text = "\(count) RESULT FOUND"
    }
}

//
// MARK: - Pager DataSource & Delegate
//
extension PageMenuViewController: FSPagerViewDelegate, FSPagerViewDataSource
{
    // MARK: DataSource
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.cardNetworkList.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 5
        
        cell.imageView?.sd_setImage(with: URL(string: cardNetworkList[index].imgUrl))
        cell.imageView?.contentMode = .scaleAspectFit
        
        cell.contentView.layer.shadowOpacity = 0.0
        
        return cell
    }
    
    // MARK: Delegate
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        guard self.pageControl.currentPage != targetIndex else {
            return
        }
        print("pagerViewWillEndDragging -> pagerView.currentIndex = \(pagerView.currentIndex) | targetIndex = \(targetIndex)")
        self.pageControl.currentPage = targetIndex // Or Use KVO with property "currentIndex"
        self.networkID = cardNetworkList[targetIndex].id
        self.cardResultTable.LoadData(bankId: self.bankID,
                                      cardType: self.cardType,
                                      cardNetwork: self.networkID)
    }
}

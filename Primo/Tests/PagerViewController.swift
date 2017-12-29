
import UIKit

class PagerViewController: UIViewController
{
    fileprivate let imageNames = [
        "mock_card_2.png", "mock_card_3.png",
        "mock_card_2.png", "mock_card_3.png",
        "mock_card_2.png", "mock_card_3.png"
    ]
    
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.itemSize = .zero
        }
    }
    
    @IBOutlet weak var pageControl: FSPageControl! {
        didSet {
            self.pageControl.numberOfPages = self.imageNames.count
            self.pageControl.contentHorizontalAlignment = .right
            self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newScale = 0.5 + CGFloat(0.5) * 0.5 // [0.5 - 1.0]
        self.pagerView.itemSize = self.pagerView.frame.size.applying(CGAffineTransform(scaleX: newScale, y: newScale))
        self.pagerView.interitemSpacing = CGFloat(20) * 20 // [0 - 20]
    }

}

extension PagerViewController: FSPagerViewDataSource, FSPagerViewDelegate
{
    //
    // MARK:- FSPagerView DataSource
    //
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 6
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = UIImage(named: self.imageNames[index])
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.textLabel?.text = index.description + index.description
        return cell
    }
    
    //
    // MARK:- FSPagerView Delegate
    //
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        self.pageControl.currentPage = index
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard self.pageControl.currentPage != pagerView.currentIndex else {
            return
        }
        self.pageControl.currentPage = pagerView.currentIndex // Or Use KVO with property "currentIndex"
        
        print("pagerViewDidScroll -> currentPage = \(self.pageControl.currentPage)")
    }
}

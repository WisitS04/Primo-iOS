
import UIKit
import Segmentio

class SegmentedControllViewController: UIViewController {
    
    var segmentioView: Segmentio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navigationBarHeight = self.navigationController?.navigationBar.bounds.height ?? 0
        let segmentioViewRect = CGRect(
            x: 0, y: statusBarHeight + navigationBarHeight,
            width: UIScreen.main.bounds.width,
            height: 50)
        print("segmentioViewRect = \(segmentioViewRect)")
        segmentioView = Segmentio(frame: segmentioViewRect)
        self.view.addSubview(segmentioView)
        
        SetUpSegmentioView()
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
        print("Selected item: ", segmentIndex)
    }
}

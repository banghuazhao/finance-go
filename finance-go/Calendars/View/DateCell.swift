import JTAppleCalendar
import UIKit
import Then

class DateCell: JTACDayCell {
    
    var isDateSelected: Bool? {
        didSet {
            guard let isDateSelected = isDateSelected else { return }
            if isDateSelected {
                dateLabel.layer.borderWidth = 1
            } else {
                dateLabel.layer.borderWidth = 0
            }
        }
    }
    
    var hasCalendar: Bool? {
        didSet {
            guard let hasCalendar = hasCalendar else { return }
            if hasCalendar {
                dotView.isHidden = false
            } else {
                dotView.isHidden = true
            }
        }
    }
    
    lazy var dateLabel = UILabel().then { label in
        label.textColor = .white1
        label.font = .title
        label.textAlignment = .center
        label.layer.cornerRadius = 22
        label.layer.borderColor = UIColor.white.cgColor
    }
    
    lazy var dotView = UIView().then { view in
        view.backgroundColor = .white2
        view.layer.cornerRadius = 3
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear

        addSubview(dateLabel)
        addSubview(dotView)
        dateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(44)
        }
        dotView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(14)
            make.centerX.equalToSuperview()
            make.size.equalTo(6)
        }
        dotView.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

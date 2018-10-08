//
//  TickerTableViewCell.swift
//  GithubTickersSerfing
//
//  Created by Денис Ефимов on 02.10.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//

import UIKit
import SnapKit

final class TickerTableViewCell: UITableViewCell {
    
    var viewModel: TickerItemViewModel?
    
    lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.contentMode = .scaleToFill
        
        stackView.addArrangedSubview(tickerTitleLaber)
        stackView.addArrangedSubview(highestBidLabel)
        contentView.addSubview(stackView)
        return stackView
    }()
    
    lazy var subtitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.contentMode = .scaleToFill
        
        stackView.addArrangedSubview(tickerSubitleLaber)
        stackView.addArrangedSubview(percentChangeLabel)
        contentView.addSubview(stackView)
        
        return stackView
    }()
    
    lazy var tickerTitleLaber: UILabel = {
        let tickerTitleLaber = UILabel()
        tickerTitleLaber.textColor = UIColor.black
        tickerTitleLaber.font = .boldSystemFont(ofSize: 16.0)
        tickerTitleLaber.textAlignment = .left
        return tickerTitleLaber
    }()
    
    lazy var tickerSubitleLaber: UILabel = {
        let tickerSubitleLaber = UILabel()
        tickerSubitleLaber.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        tickerSubitleLaber.font = .systemFont(ofSize: 16)
        tickerSubitleLaber.textAlignment = .left
        return tickerSubitleLaber
    }()
    
    lazy var percentChangeLabel: UILabel = {
        let percentChangeLabel = UILabel()
        percentChangeLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        percentChangeLabel.font = .systemFont(ofSize: 16.0)
        percentChangeLabel.textAlignment = .right
        percentChangeLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 749), for: NSLayoutConstraint.Axis.horizontal)
        return percentChangeLabel
    }()
    
    lazy var highestBidLabel: UILabel = {
        let highestBid = UILabel()
        highestBid.textColor = .black
        highestBid.font = .boldSystemFont(ofSize: 16.0)
        highestBid.textAlignment = .right
        highestBid.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 749), for: NSLayoutConstraint.Axis.horizontal)
        return highestBid
    }()
    
    var justCreated: Bool = true
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        justCreated = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeConstraints() {
    
        titleStackView.snp.makeConstraints { maker in
            maker.top.equalTo(6)
            maker.left.equalTo(20)
            maker.right.equalTo(-20)
            maker.height.equalTo(21)
        }
        
        subtitleStackView.snp.makeConstraints { maker in
            maker.top.equalTo(32)
            maker.left.equalTo(20)
            maker.right.equalTo(-20)
            maker.height.equalTo(21)
        }
        
    }
    
    func setupUI() {
        
        makeConstraints()
    
    }
    
//    override func prepareForReuse() {
//        self.tickerTitleLaber.text = ""
//        self.tickerSubitleLaber.text = ""
//        self.percentChangeLabel.text = ""
//        self.highestBidLabel.text = ""
//    }
    
    func bind(_ viewModel: TickerItemViewModel) {
        
        self.viewModel = viewModel
        
        // Clean befor reuse or change
//        self.tickerTitleLaber.text = ""
//        self.tickerSubitleLaber.text = ""
//        self.percentChangeLabel.text = ""
//        self.highestBidLabel.text = ""
        
        //
        self.tickerTitleLaber.text = viewModel.title.replacingOccurrences(of: "_", with: "/")
        self.tickerSubitleLaber.text = "Poloniex"
        
        let endpointHighestBid = viewModel.highestBid ?? "--"
        let endpointPercentChange = viewModel.percentChange ?? "--"
        
        if let percentChange = Double(endpointPercentChange) {
            let labelColor = percentChange > 0 ? #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1) : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            percentChangeLabel.textColor = labelColor
        }
        
        let basictHighestBid = self.highestBidLabel.text ?? ""
        let basicPercentChange = self.percentChangeLabel.text ?? ""
        
        if endpointHighestBid != basictHighestBid
            || endpointPercentChange != basicPercentChange {
            if justCreated {
                setIndicators(highestBid: endpointHighestBid, percentChange: endpointPercentChange)
                justCreated = false
            } else {
                animateLabels(highestBid: endpointHighestBid, percentChange: endpointPercentChange)
            }
        }
    }
    
    private func setAlpha(value: CGFloat) {
        self.highestBidLabel.alpha = value
        self.percentChangeLabel.alpha = value
    }
    
    private func setIndicators(highestBid: String?, percentChange: String?) {
        self.highestBidLabel.text = highestBid
        self.percentChangeLabel.text = percentChange
    }
    
    private func animateLabels(highestBid: String?, percentChange: String?) {
        setAlpha(value: 0.0)
        UIView.animate(withDuration: 0.3) {
            self.highestBidLabel.text = highestBid
            self.percentChangeLabel.text = percentChange
            self.highestBidLabel.alpha = 1
            self.percentChangeLabel.alpha = 1
        }
    }
}



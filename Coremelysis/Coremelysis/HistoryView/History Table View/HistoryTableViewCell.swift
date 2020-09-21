//
//  HistoryTableViewCell.swift
//  Coremelysis
//
//  Created by Artur Carneiro on 20/09/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import UIKit

final class HistoryTableViewCell: UITableViewCell {

    @AutoLayout private var creationDateLabel: UILabel
    @AutoLayout private var contentLabel: UILabel
    @AutoLayout private var sentimentLabel: UILabel

    static var identifier: String {
        return String(describing: self)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutConstraints()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(withCreationDate date: String, content: String, sentiment: Sentiment) {
        creationDateLabel.text = date
        creationDateLabel.font = .preferredFont(forTextStyle: .body)
        creationDateLabel.textColor = .coremelysisAccent

        contentLabel.text = content
        contentLabel.font = .preferredFont(forTextStyle: .headline)
        contentLabel.textColor = .coremelysisAccent
        contentLabel.numberOfLines = 2

        sentimentLabel.text = sentiment.rawValue
        sentimentLabel.textColor = .coremelysisBackground
        sentimentLabel.font = .preferredFont(forTextStyle: .headline)
        sentimentLabel.numberOfLines = 2
        sentimentLabel.textAlignment = .center

        switch sentiment {
        case .awful, .bad:
            sentimentLabel.backgroundColor = .coremelysisNegative
        case .neutral, .notFound:
            sentimentLabel.backgroundColor = .coremelysisNeutral
        case .good, .great:
            sentimentLabel.backgroundColor = .coremelysisPositive
        }
    }

    private func layoutConstraints() {
        contentView.addSubview(creationDateLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(sentimentLabel)

        let layoutGuides = contentView.layoutMarginsGuide

        NSLayoutConstraint.activate([
            sentimentLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            sentimentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            sentimentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            sentimentLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.35),
            sentimentLabel.leadingAnchor.constraint(lessThanOrEqualTo: contentLabel.trailingAnchor),

            contentLabel.topAnchor.constraint(equalTo: layoutGuides.topAnchor),
            contentLabel.leadingAnchor.constraint(equalTo: layoutGuides.leadingAnchor),
            contentLabel.trailingAnchor.constraint(lessThanOrEqualTo: sentimentLabel.leadingAnchor),

            creationDateLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor,
                                                   constant: DesignSystem.TableView.Rows.internalSpacing),
            creationDateLabel.bottomAnchor.constraint(equalTo: layoutGuides.bottomAnchor),
            creationDateLabel.leadingAnchor.constraint(equalTo: contentLabel.leadingAnchor),
            creationDateLabel.trailingAnchor.constraint(lessThanOrEqualTo: sentimentLabel.leadingAnchor)
        ])
    }
}

//
//  ReviewHeaderTableViewCell.swift
//  febys
//
//  Created by Faisal Shahzad on 23/12/2021.
//

import UIKit

class ReviewHeaderTableViewCell: UITableViewCell {

    //MARK: IBOutlet
    @IBOutlet weak var totalAvgRating: FebysLabel!
    @IBOutlet weak var avgPriceRating: FebysLabel!
    @IBOutlet weak var avgValueRating: FebysLabel!
    @IBOutlet weak var avgQualityRating: FebysLabel!
    
    @IBOutlet weak var fiveStarPriceRating: UIProgressView!
    @IBOutlet weak var fourStarPriceRating: UIProgressView!
    @IBOutlet weak var threeStarPriceRating: UIProgressView!
    @IBOutlet weak var twoStarPriceRating: UIProgressView!
    @IBOutlet weak var oneStarPriceRating: UIProgressView!
    
    @IBOutlet weak var fiveStarValueRating: UIProgressView!
    @IBOutlet weak var fourStarValueRating: UIProgressView!
    @IBOutlet weak var threeStarValueRating: UIProgressView!
    @IBOutlet weak var twoStarValueRating: UIProgressView!
    @IBOutlet weak var oneStarValueRating: UIProgressView!
    
    @IBOutlet weak var fiveStarQualityRating: UIProgressView!
    @IBOutlet weak var fourStarQualityRating: UIProgressView!
    @IBOutlet weak var threeStarQualityRating: UIProgressView!
    @IBOutlet weak var twoStarQualityRating: UIProgressView!
    @IBOutlet weak var oneStarQualityRating: UIProgressView!
    
    func calculateAvgRating(_ scores: [Score]) -> Double {
        var totalRating: Double = 0
        var totalScore: Double = 0
        _ = scores.compactMap { score in
            totalRating += ((score.score ?? 0)*Double((score.count ?? 0)))
            totalScore += Double(score.count ?? 0)
        }
        return (totalRating / totalScore)
    }
    
    func setRating(_ progressView: UIProgressView, score: Score, total: Int) {
        let count = Float(score.count ?? 0)
        let progress = count / Float(total)
        progressView.progress = progress
    }
    
    func configureRatingBars(scores: [Score], progressBars: [UIProgressView]) {
        var totalScore = 0
        _ = scores.compactMap { score in
            totalScore += (score.count ?? 0)
        }
        
        for score in scores {
            switch score.score {
            case 1:
                self.setRating(progressBars[0], score: score, total: totalScore)
            case 2:
                self.setRating(progressBars[1], score: score, total: totalScore)
            case 3:
                self.setRating(progressBars[2], score: score, total: totalScore)
            case 4:
                self.setRating(progressBars[3], score: score, total: totalScore)
            case 5:
                self.setRating(progressBars[4], score: score, total: totalScore)
            default:
                break
            }
        }
    }
    
    //MARK: Configure
    func configure(_ vendorDetails: Vendor?) {
        let priceAvgRating = calculateAvgRating(vendorDetails?.pricingScore ?? [])
        let valueAvgRating = calculateAvgRating(vendorDetails?.valueScore ?? [])
        let qualityAvgRating = calculateAvgRating(vendorDetails?.qualityScore ?? [])
        
        totalAvgRating.text = "\(vendorDetails?.stats?.rating?.score ?? 0.0)"
        avgPriceRating.text = "\(priceAvgRating.round(to: 1))"
        avgValueRating.text = "\(valueAvgRating.round(to: 1))"
        avgQualityRating.text = "\(qualityAvgRating.round(to: 1))"

        configureRatingBars(scores: vendorDetails?.pricingScore ?? [], progressBars: [oneStarPriceRating, twoStarPriceRating, threeStarPriceRating, fourStarPriceRating, fiveStarPriceRating])
        configureRatingBars(scores: vendorDetails?.valueScore ?? [], progressBars: [oneStarValueRating, twoStarValueRating, threeStarValueRating, fourStarValueRating, fiveStarValueRating])
        configureRatingBars(scores: vendorDetails?.qualityScore ?? [], progressBars: [oneStarQualityRating, twoStarQualityRating, threeStarQualityRating, fourStarQualityRating, fiveStarQualityRating])
    }
    
}

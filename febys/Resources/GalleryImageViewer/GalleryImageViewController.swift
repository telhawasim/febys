//
//  GalleryImageViewController.swift
//  febys
//
//  Created by Faisal Shahzad on 23/02/2022.
//

import UIKit
import ImageViewer

struct GalleryDataItem {
    let imageView: UIImageView
    let galleryItem: GalleryItem
}

class GalleryImageViewController {
    
    private var viewController: UIViewController!
    var items = [GalleryDataItem]()

    init(_ viewController: UIViewController, imagesURL: [String]) {
        self.viewController = viewController
        self.items = prepareGalleryData(imagesURL)
    }
    
    //MARK: PREPARE DATA
    func prepareGalleryData(_ images: [String]?) -> [GalleryDataItem] {
        var galleryData = [GalleryDataItem]()
        images?.forEach({ imageUrl in
            let imageView = UIImageView()
            imageView.setImage(url: imageUrl)
            
            let image = imageView.image ?? UIImage(named: "no-image")!
            let galleryItem = GalleryItem.image { $0(image) }
            
            galleryData.append(GalleryDataItem(imageView: imageView, galleryItem: galleryItem))
        })
        return galleryData
    }
    
    //MARK: PRESENT VIEWER
    func showGalleryImageViewer(_ index: Int) {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 24)
        let headerView = CounterView(frame: frame, currentIndex: index, count: items.count)
        let footerView = CounterView(frame: frame, currentIndex: index, count: items.count)

        let galleryViewController = GalleryViewController(startIndex: index, itemsDataSource: self, itemsDelegate: self, displacedViewsDataSource: self, configuration: galleryConfiguration())
//        galleryViewController.headerView = headerView
        galleryViewController.footerView = footerView

        galleryViewController.launchedCompletion = {  }
        galleryViewController.closedCompletion = {  }
        galleryViewController.swipedToDismissCompletion = {  }

        galleryViewController.landedPageAtIndexCompletion = { index in
            headerView.count = self.items.count
            headerView.currentIndex = index
            footerView.count = self.items.count
            footerView.currentIndex = index
        }

        viewController.presentImageGallery(galleryViewController)
    }

    
    //MARK: CONFIGURATION
    func galleryConfiguration() -> GalleryConfiguration {
        return [
            GalleryConfigurationItem.deleteButtonMode(.none),
            GalleryConfigurationItem.thumbnailsButtonMode(.none),
            GalleryConfigurationItem.closeButtonMode(.builtIn),

            GalleryConfigurationItem.pagingMode(.standard),
            GalleryConfigurationItem.presentationStyle(.displacement),
            GalleryConfigurationItem.hideDecorationViewsOnLaunch(false),

            GalleryConfigurationItem.swipeToDismissMode(.vertical),
            GalleryConfigurationItem.toggleDecorationViewsBySingleTap(false),
            GalleryConfigurationItem.activityViewByLongPress(false),

            GalleryConfigurationItem.overlayColor(UIColor(white: 0.035, alpha: 1)),
            GalleryConfigurationItem.overlayColorOpacity(1),
            GalleryConfigurationItem.overlayBlurOpacity(1),
            GalleryConfigurationItem.overlayBlurStyle(UIBlurEffect.Style.light),
            
            GalleryConfigurationItem.videoControlsColor(.white),

            GalleryConfigurationItem.maximumZoomScale(8),
            GalleryConfigurationItem.swipeToDismissThresholdVelocity(500),

            GalleryConfigurationItem.doubleTapToZoomDuration(0.15),

            GalleryConfigurationItem.blurPresentDuration(0.5),
            GalleryConfigurationItem.blurPresentDelay(0),
            GalleryConfigurationItem.colorPresentDuration(0.25),
            GalleryConfigurationItem.colorPresentDelay(0),

            GalleryConfigurationItem.blurDismissDuration(0.1),
            GalleryConfigurationItem.blurDismissDelay(0.4),
            GalleryConfigurationItem.colorDismissDuration(0.45),
            GalleryConfigurationItem.colorDismissDelay(0),

            GalleryConfigurationItem.itemFadeDuration(0.3),
            GalleryConfigurationItem.decorationViewsFadeDuration(0.15),
            GalleryConfigurationItem.rotationDuration(0.15),

            GalleryConfigurationItem.displacementDuration(0.55),
            GalleryConfigurationItem.reverseDisplacementDuration(0.25),
            GalleryConfigurationItem.displacementTransitionStyle(.springBounce(0.7)),
            GalleryConfigurationItem.displacementTimingCurve(.linear),

            GalleryConfigurationItem.statusBarHidden(true),
            GalleryConfigurationItem.displacementKeepOriginalInPlace(false),
            GalleryConfigurationItem.displacementInsetMargin(50)
        ]
    }
}

extension GalleryImageViewController: GalleryItemsDataSource {
    func itemCount() -> Int {
        return items.count
    }

    func provideGalleryItem(_ index: Int) -> GalleryItem {
        return items[index].galleryItem
    }
}

extension GalleryImageViewController: GalleryItemsDelegate {
    func removeGalleryItem(at index: Int) {
        
    }
}

extension GalleryImageViewController: GalleryDisplacedViewsDataSource {
    func provideDisplacementItem(atIndex index: Int) -> DisplaceableView? {
        if index < items.count {
            return items[index].imageView as? DisplaceableView
        }
        return nil
    }
}

// Some external custom UIImageView we want to show in the gallery
class FLSomeAnimatedImage: UIImageView {
}

// Extend ImageBaseController so we get all the functionality for free
class AnimatedViewController: ItemBaseController<FLSomeAnimatedImage> {
}

//
//  BSPreviewVC.swift
//  Bbang
//
//  Created by bart Shin on 26/05/2021.
//

import SwiftUI
import SDWebImage

class BSPreviewVC: UIViewController, ObservableObject, BSPreviewDataSouce {
	
	var server: ServerDataOperator!
	
	@Published var feeds = [BSFeed]() {
		didSet {
			fetchImages()
		}
	}
	
	private var hostingVC: UIHostingController<HomeBSPreview<BSPreviewVC>>!
	var feedImages = [BSFeed: UIImage]()
	
	private func fetchImages() {
		var countToFetch = feeds.count
		feeds.forEach { feed in
			guard let url = feed.imageUrls.first else { return }
			SDWebImageDownloader.shared.downloadImage(with: url) { [weak self = self] image, data, error, _ in
				guard let strongSelf = self else { return }
				if image != nil {
					strongSelf.feedImages[feed] = image!
				}
				else {
					print("Fail to fetch image from: \(url) \n \(error?.localizedDescription ?? "")")
				}
				countToFetch -= 1
				if countToFetch < strongSelf.feeds.count / 2 {
					DispatchQueue.main.async {
						strongSelf.objectWillChange.send()
					}
				}
			}
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		let rootView = HomeBSPreview<BSPreviewVC> (dataSource: self){ feed in
			print("tap feed \(feed.id)")
		}
		hostingVC = UIHostingController<HomeBSPreview>(rootView: rootView)
		view.addSubview(hostingVC.view)
		hostingVC.view.snp.makeConstraints {
			$0.edges.equalToSuperview()
		}
    }
	
}

//
//  CampaignsViewController.swift
//  CristianINGAssignment
//
//  Created by Cristian Serea on 16.10.2023.
//

import UIKit
import RxSwift
import RxCocoa
import ProgressHUD

protocol CampaignsViewControllerDelegate {
    func didSelect(campaign: Campaign)
    func goBackAndResetChannel()
}

class CampaignsViewController: UIViewController {
    private lazy var collectionView: UICollectionView = getCollectionView()
    private lazy var pageControl: UIPageControl = setupPageControl()
    
    var campaignsViewControllerDelegate: CampaignsViewControllerDelegate?
    
    private var campaignsViewModel: CampaignsViewModel?
    private var channel: Channel?    
    private let disposeBag = DisposeBag()
    
    init(channel: Channel) {
        self.channel = channel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNavigationItem()
        setupConstraints()
        
        fetchData()
    }
}

extension CampaignsViewController {
    private func setupView() {
        view.backgroundColor = .systemBackground
    }    
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(reset))
    }
    
    private func getCollectionView() -> UICollectionView {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        let nib = UINib(nibName: "CampaignCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "campaignCell")
        
        return collectionView
    }
    
    private func setupPageControl() -> UIPageControl {
        let pageControl = UIPageControl()
        pageControl.addTarget(self, action: #selector(pageControlValueChange), for: .valueChanged)
        pageControl.currentPageIndicatorTintColor = .systemBlue
        pageControl.pageIndicatorTintColor = .lightGray
        view.addSubview(pageControl)
        
        return pageControl
    }
}

extension CampaignsViewController {
    private func setupConstraints() {
        setupConstraintsForCollectionView()
        setupConstraintsForPageControl()
    }
    
    private func setupConstraintsForCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    private func setupConstraintsForPageControl() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: GlobalConstants.marginOffset / 4).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -GlobalConstants.marginOffset).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

extension CampaignsViewController {
    private func fetchData() {
        guard let channel = channel else {
            return
        }
        
        campaignsViewModel = CampaignsViewModel()
        
        campaignsViewModel?.campaigns.asObservable()
            .skip(1)
            .bind { campaigns in
                DispatchQueue.main.async { [weak self] in
                    ProgressHUD.dismiss()
                    self?.collectionView.reloadData()
                    self?.pageControl.numberOfPages = campaigns.count
                }
            }
            .disposed(by: disposeBag)
        
        campaignsViewModel?.error.asObserver()
            .bind { error in
                print("111", error)
                ProgressHUD.dismiss()
            }
            .disposed(by: disposeBag)
        
        ProgressHUD.animate("Fetching campaigns data")
        
        campaignsViewModel?.fetchData(channel: channel)
    }
}

extension CampaignsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return campaignsViewModel?.campaigns.value.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "campaignCell", for: indexPath) as! CampaignCollectionViewCell
        cell.setupContent(campaign: campaignsViewModel?.campaigns.value[indexPath.item])
        
        return cell
    }
}

extension CampaignsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.bounds.width > .zero else {
            return
        }
        
        let index = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        
        pageControl.currentPage = index
    }
}

extension CampaignsViewController {
    @objc func reset() {
        campaignsViewControllerDelegate?.goBackAndResetChannel()
    }
    
    @objc func pageControlValueChange() {
        let contentOffsetX = CGFloat(pageControl.currentPage) * collectionView.frame.size.width
        let point = CGPoint(x: contentOffsetX, y: .zero)
        
        collectionView.setContentOffset(point, animated: true)
    }
}

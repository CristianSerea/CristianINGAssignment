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
    func goBackAndResetChannel()
    func didSelectCampaign(channel: Channel)
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
        setupViewModel()
    }
}

extension CampaignsViewController {
    private func setupView() {
        view.backgroundColor = .systemBackground
    }    
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: LocalizableConstants.resetButtonTitle,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(reset))
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
        
        let nib = UINib(nibName: GlobalConstants.Identifier.campaignCollectionViewCell, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: GlobalConstants.Identifier.campaignCell)
        
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
        pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: GlobalConstants.Layout.marginOffset / 4).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -GlobalConstants.Layout.marginOffset).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

extension CampaignsViewController {
    private func setupViewModel() {
        campaignsViewModel = CampaignsViewModel()
        
        campaignsViewModel?.campaigns.asObservable()
            .skip(1)
            .bind { campaigns in
                DispatchQueue.main.async { [weak self] in
                    ProgressHUD.dismiss()
                    self?.channel?.campaigns = campaigns
                    self?.collectionView.reloadData()
                    self?.pageControl.numberOfPages = campaigns.count
                }
            }
            .disposed(by: disposeBag)
        
        campaignsViewModel?.error.asObserver()
            .bind { error in
                ProgressHUD.dismiss()             
                DispatchQueue.main.async { [weak self] in
                    self?.showAlertController(error: error, completion: { [weak self] in
                        self?.fetchData()
                    })
                }
            }
            .disposed(by: disposeBag)
        
        fetchData()
    }
    
    private func fetchData() {
        guard let channel = channel else {
            return
        }
        
        ProgressHUD.animate(LocalizableConstants.fetchingCampaignsDataTitle)        
        campaignsViewModel?.fetchData(channel: channel)
    }
}

extension CampaignsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return campaignsViewModel?.campaigns.value.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GlobalConstants.Identifier.campaignCell, for: indexPath) as! CampaignCollectionViewCell
        cell.setupContent(campaign: campaignsViewModel?.campaigns.value[indexPath.item])
        cell.campaignView.selectCampaignButtonDidTap = { [weak self] selectedCampaign in
            guard var channel = self?.channel,
                  var campaigns = channel.campaigns else {
                return
            }
            
            for index in campaigns.indices {
                campaigns[index].isSelected = campaigns[index].price == selectedCampaign?.price
            }
            
            channel.campaigns = campaigns
            
            self?.campaignsViewControllerDelegate?.didSelectCampaign(channel: channel)
        }
        
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

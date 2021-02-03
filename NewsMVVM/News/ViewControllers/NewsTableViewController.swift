//
//  NewsTableViewController.swift
//  News
//
//  Created by Luís Felipe Polo on 24/01/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class NewsTableViewController : UITableViewController {
    
    let disposeBag = DisposeBag()
    private var articleListVM = ArticleListViewModel(articles: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        populateNews()
    }
    
    private func populateNews() {
        
        URLRequest.load(url: ArticleResponse.url)
            .catchAndReturn(ArticleResponse.empty)
            .subscribe(onNext: { [weak self] articleResponse in
                self?.articleListVM = ArticleListViewModel(articles: articleResponse.articles)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }).disposed(by: disposeBag)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.articleListVM.articlesVM.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as? ArticleTableViewCell else {
            return UITableViewCell()
        }
        
        let articleVM = self.articleListVM.article(at: indexPath.row)
        
        articleVM.title.asDriver(onErrorJustReturn: "")
            .drive(cell.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        articleVM.description.asDriver(onErrorJustReturn: "")
            .drive(cell.descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        return cell
    }
}

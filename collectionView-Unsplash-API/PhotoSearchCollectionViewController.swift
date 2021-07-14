//
//  PhotoSearchCollectionViewController.swift
//  collectionView-Unsplash-API
//
//  Created by Ike Chukz on 7/13/21.
//

import UIKit

struct APIResponse: Codable {
    let total: Int
    let total_pages: Int
    let results: [Result]
}


struct Result: Codable {
    let id: String
    let urls: URLS
}

struct URLS: Codable {
    //let regular: String
    let regular: String
}


private let reuseIdentifier = "cell"

class PhotoSearchCollectionViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate{
    
    @IBOutlet var collectionViewPhoto: UICollectionView!
    
    let url = "https://api.unsplash.com/search/photos?page=1&per_page=50&query=office&client_id=GlUv0ULAiVxudLTp1PPNos4VHZ_TDXb8wVHiZMlkatI"
       
       var results: [Result] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.frame.size.width/2, height: view.frame.size.width/2)
        let collectionViewPhoto = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionViewPhoto)
        collectionViewPhoto.backgroundColor = .systemBackground
        self.collectionViewPhoto = collectionViewPhoto
        
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionViewPhoto!.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        collectionViewPhoto.dataSource = self

        fetchPhoto()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //searchbar.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.frame.size.width-20, height: 50)
        collectionViewPhoto?.frame = CGRect(x: 0, y: view.safeAreaInsets.top+55, width: view.frame.size.width, height: view.frame.size.height-55)
        //collectionView?.frame = view.bounds
    }
    
    func fetchPhoto(){
           guard let url = URL(string: url)else{
               return
           }
           let task = URLSession.shared.dataTask(with:url){[weak self]
               data, _, error in
               guard let data = data, error == nil else{
                   return
               }
               //print("Got data")
               
               do{
                   let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data) //from json in postman
                   
                   
                   print(jsonResult.results.count)//See the print of the number (30) in the output. This number should be same in the unsplash for the photo
                   DispatchQueue.main.async {
                       self?.results = jsonResult.results
                       self?.collectionViewPhoto?.reloadData()
                   }
               
               }catch{
                   print(error)
               }
           }
           task.resume()
       }
    
    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return results.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        //let imageURLString = results[indexPath.row].urls.full
        let imageURLString = results[indexPath.row].urls.regular
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"ImageCollectionViewCell", for: indexPath
        )as? PhotoCollectionViewCell
        else{
            return UICollectionViewCell()
        }
        cell.configure(with: imageURLString)
        //cell.backgroundColor = .blue
        return cell
    }

    

}

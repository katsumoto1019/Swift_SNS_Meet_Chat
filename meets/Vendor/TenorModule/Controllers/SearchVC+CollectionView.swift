import UIKit

extension SearchVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? PreviewCell
        
        /*if let url = resultsArray[indexPath.row].media?.first?.mp4?.preview {
            
            cell?.thumbImageView.af_setImage(withURL: url,
                                             placeholderImage: #imageLiteral(resourceName: "placeholder"),
                                             imageTransition: .crossDissolve(0.1))
            
        }*/
        cell?.entity = resultsArray[indexPath.row]
        
        return cell ?? UICollectionViewCell()
    }
}

extension SearchVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /*guard let url = resultsArray[indexPath.row].media?.first?.mp4?.url else { return }
        
        print("this is url======>",url)
        
        let _ = VideoPlayer.playVideo(with: url)*/
        /*if let gifurl = resultsArray[indexPath.row].media?.first?.gif?.url,let thumbURL = resultsArray[indexPath.row].media?.first?.mp4?.preview {
           selectedGifURL = "\(gifurl)" + "*" + "\(thumbURL)"
        }*/
        
        if num == -1{
            num += 1
            if let gifurl = resultsArray[indexPath.row].media?.first?.gif?.url{
                //selectedGifURL = "\(gifurl)"
                let gifDataDict: [String: Any] = ["selected_gif_url":"\(gifurl)"]
                NotificationCenter.default.post(name:.gifSend, object: nil, userInfo: gifDataDict)
            }
            self.closeMenu(.gifSearch)
        }
    }
}

extension SearchVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch UIDevice.current.userInterfaceIdiom {
        case .carPlay, .tv, .unspecified:
            fallthrough
        case .phone:
            return CGSize(width: collectionView.frame.width / 3.1, height: collectionView.frame.width / 3.1)
        case .pad:
            return CGSize(width: collectionView.frame.width/2, height: cellHeight)
        case .mac:
            return CGSize(width: collectionView.frame.width / 3.1, height: collectionView.frame.width / 3.1)
        @unknown default:
            return CGSize(width: collectionView.frame.width / 3.1, height: collectionView.frame.width / 3.1)
        }
    }
}

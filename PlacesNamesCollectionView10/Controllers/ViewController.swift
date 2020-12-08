//
//  ViewController.swift
//  PlacesNamesCollectionView10
//
//  Created by Mahmoud Nasser on 08/12/2020.
//

import UIKit

class ViewController: UICollectionViewController {

    //MARK: Properties
    
    var places = [Place]()
    
    //MARK: app life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage))
        
    }

    //MARK: Objective C Functions
    
    @objc func addImage(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    //MARK: Collection View Functions
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return places.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceCell", for: indexPath) as? CollectionViewCell {
            let place = places[indexPath.item]
            
            let path = getDocumentDirectory().appendingPathComponent(place.image)
            print("image name 2 \(path)")
            cell.image.image = UIImage(contentsOfFile: path.path)
            cell.label.text = place.name
            cell.image.layer.borderWidth = 2
            cell.image.layer.borderColor = UIColor.black.cgColor
            cell.image.layer.cornerRadius = 5
            cell.image.contentMode = .scaleToFill
            cell.layer.cornerRadius = 7
    
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension ViewController : UIImagePickerControllerDelegate {
     
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard  let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentDirectory().appendingPathComponent(imageName)
        
        if let jpeg = image.jpegData(compressionQuality: 0.8){
            do{
                try jpeg.write(to: imagePath)
                print("image name 1 \(imagePath.absoluteString)")
                places.append(Place(name: "Unknown", image: imageName))
                collectionView.reloadData()
                print("write image to disk successed")
            } catch {
                print("couldnt write image to disk")
            }
        }
        
        dismiss(animated: true)
    }
    
    func getDocumentDirectory()->URL{
        let pathes = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return pathes[0]
    }
}

extension ViewController : UINavigationControllerDelegate {
    
}

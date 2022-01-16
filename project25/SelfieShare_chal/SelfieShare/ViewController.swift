//
//  ViewController.swift
//  SelfieShare
//
//  Created by Arvin Shen on 1/11/22.
//

import MultipeerConnectivity
import UIKit

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate, MCNearbyServiceAdvertiserDelegate {
    
    var images = [UIImage]()
    
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession?
    var advertiser: MCNearbyServiceAdvertiser?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Selfie Share"
        let sessionBtn = UIBarButtonItem(image: UIImage(systemName: "dot.radiowaves.left.and.right"), style: .plain, target: self, action: #selector(showConnectionPrompt))
        let connectedPeersBtn = UIBarButtonItem(image: UIImage(systemName: "network"), style: .plain, target: self, action: #selector(updateAndShowConnectedPeers))
        navigationItem.leftBarButtonItems = [sessionBtn, connectedPeersBtn]
        
        let messageBtn = UIBarButtonItem(image: UIImage(systemName: "message"), style: .plain, target: self, action: #selector(sendMessage))
        let importPictureBtn = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        navigationItem.rightBarButtonItems = [importPictureBtn, messageBtn]
        
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        images.insert(image, at: 0)
        collectionView.reloadData()
        
        sendData(with: image)
    }
    
    // MARK: - Selectors
    
    @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func updateAndShowConnectedPeers() {
        DispatchQueue.main.async {
            [weak self] in
            var connectedDevices = [UIAction]()
            self?.mcSession?.connectedPeers.forEach { device in
                let action = UIAction(title: device.displayName, image: UIImage(systemName: "iphone")) { (_) in }
                connectedDevices.append(action)
                
                let networkMenu = UIMenu(title: "Connected Devices", image: nil, identifier: nil, options: [], children: connectedDevices)
                
                let updatedConnectedPeersBtn = UIBarButtonItem(title: "Connected Devices", image: UIImage(systemName: "network"), primaryAction: nil, menu: networkMenu)
                
                self?.navigationItem.leftBarButtonItems?.removeLast()
                self?.navigationItem.leftBarButtonItems?.append(updatedConnectedPeersBtn)
            }
        }
    }
    
    @objc func sendMessage() {
        textMessage(isReply: false)
    }
    
    func sendReply(data: String) {
        textMessage(isReply: true, data: data)
    }
    
    func sendData(with image: UIImage) {
        // 1. Check if we have an active session we can use.
        guard let mcSession = mcSession else { return }
        
        // 2. Check if there are any peers to send to.
        if !mcSession.connectedPeers.isEmpty {
            // 3. Convert the new image to a Data object.
            if let imageData = image.pngData() {
                // 4. Send it to all peers, ensuring it gets delivered.
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    // 5. Show an error message if there's a problem.
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }
    
    func sendData(with text: String) {
        // 1. Check if we have an active session we can use.
        guard let mcSession = mcSession else { return }
        
        // 2. Check if there are any peers to send to.
        if !mcSession.connectedPeers.isEmpty {
            let textData = Data(text.utf8)
            // 4. Send it to all peers, ensuring it gets delivered.
            do {
                try mcSession.send(textData, toPeers: mcSession.connectedPeers, with: .reliable)
            } catch {
                // 5. Show an error message if there's a problem.
                self.presentAlertOnMainThread(title: "Send Error", message: error.localizedDescription, buttonTitle: "OK")
            }
        }
    }
    
    func textMessage(isReply: Bool, data: String? = nil) {
        var text: String? = nil
        if isReply && data != nil {
            text = data
        } else if isReply && data == nil {
            return
        }
        let ac: UIAlertController
        if isReply {
            ac = UIAlertController(title: peerID.displayName, message: text, preferredStyle: .alert)
        } else {
            ac = UIAlertController(title: "Send Text Message", message: nil, preferredStyle: .alert)
        }
        ac.addTextField()
        
        let sendAction = UIAlertAction(title: isReply ? "Reply": "Send", style: .default) {
            [weak self, weak ac] _ in
            guard let message = ac?.textFields?[0].text else { return }
            
            // 1. Check if we have an active session we can use.
            guard let mcSession = self?.mcSession else { return }
            
            // 2. Check if there are any peers to send to.
            if !mcSession.connectedPeers.isEmpty {
                // 3. Convert the new image to a Data object.
                let textData = Data(message.utf8)
                // 4. Send it to all peers, ensuring it gets delivered.
                do {
                    try mcSession.send(textData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    // 5. Show an error message if there's a problem.
                    self?.presentAlertOnMainThread(title: "Send Error", message: error.localizedDescription, buttonTitle: "OK")
                }
            }
        }
        ac.addAction(sendAction)
        ac.addAction(UIAlertAction(title: isReply ? "OK": "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // MARK: - Handlers
    
    func startHosting(action: UIAlertAction) {
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "as-project25")
        advertiser?.delegate = self
        advertiser?.startAdvertisingPeer()
    }
    
    func joinSession(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: "as-project25", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    // MARK: - Collection View
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        
        return cell
    }
    
    // MARK: - MCSessionDelegate
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
            updateAndShowConnectedPeers()
            
        case .connecting:
            print("Connecting: \(peerID.displayName)")
            updateAndShowConnectedPeers()
            
        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
            self.presentAlertOnMainThread(title: "\(peerID.displayName) has disconnected", message: nil, buttonTitle: "OK")
            updateAndShowConnectedPeers()
            
        @unknown default:
            print("Unknown state received: \(peerID.displayName)")
            updateAndShowConnectedPeers()
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
                return
            }
            let text = String(decoding: data, as: UTF8.self)
            self?.sendReply(data: text)
        }
    }
    
    // MARK: - MCBrowserViewControllerDelegate
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    // MARK: - MCNearbyServiceAdvertiserDelegate
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        let ac = UIAlertController(title: "Project 25", message: "'\(peerID.displayName)' wants to connect", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Accept", style: .default) { [weak self] _ in
            invitationHandler(true, self?.mcSession)
        })
        ac.addAction(UIAlertAction(title: "Decline", style: .cancel) { _ in
            invitationHandler(false, nil)
        })
        present(ac, animated: true)
    }
}

extension UIViewController {
    
    func presentAlertOnMainThread(title: String?, message: String?, buttonTitle: String?, actions: [UIAlertAction]? = nil) {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: buttonTitle, style: .default))
            
            if actions != nil {
                actions?.forEach { ac.addAction($0) }
            }
            self.present(ac, animated: true)
        }
    }
}

/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */

import UIKit

enum State {
    case connecting
    case readyToConnect
    case error
}

class ConnectViewController: UIViewController {

    @IBOutlet var connectButton: UIButton!
    var state: State = .readyToConnect
    
    let authentication: Authentication = Authentication()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectPhoto" {
            let photoSelectorVC = segue.destination as! PhotoSelectorTableViewController
            photoSelectorVC.authentication = authentication
        }
    }
}


// Connect action & UI Helpers
extension ConnectViewController {
    
    @IBAction func connectToGraph(_ sender: AnyObject) {
        
        if state == .connecting {
            return
        }
        
        setConnectButton(.connecting)
        
        let clientId = ApplicationConstants.clientId
        let scopes = ApplicationConstants.scopes
        
        authentication.connectToGraph(withClientId: clientId, scopes: scopes) { (result) in
            switch result {
            case .success(_):
                MSGraphClient.setAuthenticationProvider(self.authentication.authenticationProvider)
                self.setConnectButton(.readyToConnect)
                self.performSegue(withIdentifier: "selectPhoto", sender: nil)
                break
            case .failure(let error):
                print("[Error]", error)
                self.setConnectButton(.error)
                break
            }
        }
    }
    
    func setConnectButton(_ state: State) {
        switch state {
        case .connecting:
            connectButton.isEnabled = false
            connectButton.setTitle("Connecting", for: UIControlState())
            break
        case .readyToConnect:
            connectButton.isEnabled = true
            connectButton.setTitle("Start by connecting to Microsoft Graph", for: UIControlState())
            break
        case .error:
            connectButton.isEnabled = true
            connectButton.setTitle("Connection failed. Retry.", for: UIControlState())
            break
        }
    }
}

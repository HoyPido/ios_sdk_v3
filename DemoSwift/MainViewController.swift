import UIKit

public var demoAppFirstCall: Bool = true
public var indianApplicationFirstCall: Bool = true
public var withoutDiscoveryFirstCall: Bool = true

class MainViewController : UIViewController {
    @IBOutlet weak var tableView : UITableView!
    
    let availablSections = ["Demo App", "Without discovery", "Indian Application"]
    
    let availableSegue = ["DemoApp", "ExampleApp", "IndianApp"]
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        super.viewWillAppear(animated)
    }
    
}

extension MainViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availablSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = availablSections[indexPath.row]
        cell.textLabel?.textAlignment = .center
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        demoAppFirstCall = true
        indianApplicationFirstCall = true
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: availableSegue[indexPath.row], sender: nil)
    }

}

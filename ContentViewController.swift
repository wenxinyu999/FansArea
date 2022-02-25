
import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var labelFooter: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelHeading: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBAction func doneBtnTap(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "guiderShow")
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var btnDone: UIButton!
    var index = 0
    var heading = ""
    var imageName = ""
    var footer = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.currentPage = index
        labelFooter.text = footer
        labelHeading.text = heading
        imageView.image = UIImage(named: imageName)
        btnDone.isHidden = (index != 2)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

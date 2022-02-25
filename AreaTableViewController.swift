
import UIKit
import CoreData

class AreaTableViewController: UITableViewController, NSFetchedResultsControllerDelegate,UISearchResultsUpdating{
    
    
    
    var areas: [AreaMO] = []
    var fc: NSFetchedResultsController<AreaMO>!
    
    var  sc : UISearchController!
    
    var searchResults : [AreaMO] = []
    
    func searchFilter(text: String)  {
        searchResults = areas.filter({ (area) -> Bool in
            return area.name!.localizedCaseInsensitiveContains(text) ||
            area.part!.localizedCaseInsensitiveContains(text) ||
            area.province!.localizedCaseInsensitiveContains(text)
            
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text {
//            text = text.trimmingCharacters(in: .whitespaces)
            searchFilter(text: text)
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        tableView.tableHeaderView = sc.searchBar
        sc.dimsBackgroundDuringPresentation = false
        sc.searchBar.placeholder = NSLocalizedString("Enter area name to search...", comment: "placeholder for search bar")
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        fetchAlldata2()
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      //  fetchAllData()
      //  tableView.reloadData()
        
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "guiderShow") {
            return
        }
       // let aboutSB = UIStoryboard(name: "about", bundle: Bundle.main)
        if let pageVC = storyboard?.instantiateViewController(withIdentifier: "GuideController") as? GuiderViewController{
            present(pageVC, animated: true, completion: nil)
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case . update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        default:
            tableView.reloadData()
        }
        
        if let object = controller.fetchedObjects {
            areas = object as! [AreaMO]
        }
    }
    
    func fetchAlldata2() {
        let request : NSFetchRequest<AreaMO> = AreaMO.fetchRequest()
        let sd = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sd]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        fc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fc.delegate = self
        
        do {
            try fc.performFetch()
            if let object = fc.fetchedObjects {
                areas = object
            }
        } catch  {
            print(error)
        }
    }
    
//    func fetchAllData()  {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        do {
//           areas = try appDelegate.persistentContainer.viewContext.fetch(AreaMO.fetchRequest())
//        } catch  {
//            print(error)
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:  - Table View delegate
    
    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menu = UIAlertController(title: "朋友你好", message: "您选择了第\(indexPath.row)行", preferredStyle: .actionSheet)
        
        let optionCacel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        let option3 = UIAlertAction(title: "我去过", style: .default) { (_) in
           let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark
            self.visited[indexPath.row] = true
        }
        
        let option4 = UIAlertAction(title: "我没去过", style: .default) { (_) in
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .none
            self.visited[indexPath.row] = false
        }
        menu.addAction(optionCacel)
        if self.visited[indexPath.row] == false {
            menu.addAction(option3)
        } else {
            menu.addAction(option4)
        }
        
        
        self.present(menu, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    */
    

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let actionShare = UITableViewRowAction(style: .normal, title: "分享") { (_, indexPath) in
            let actionSheet = UIAlertController(title: "分享", message: nil, preferredStyle: .actionSheet)
            let option1 = UIAlertAction(title: "QQ", style: .default, handler: nil)
            let option2 = UIAlertAction(title: "微信", style: .default, handler: nil)
            let optionCancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            actionSheet.addAction(option1)
            actionSheet.addAction(option2)
            actionSheet.addAction(optionCancel)
            
            self.present(actionSheet, animated: true, completion: nil)
        }
        actionShare.backgroundColor = UIColor.orange
        
        let actionDel = UITableViewRowAction(style: .destructive, title:
            NSLocalizedString("Delete", bundle: Bundle(for: UIButton.classForCoder()), comment: "title for delete action")) { (_, indexPath) in
         //   self.areas.remove(at: indexPath.row)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(self.fc.object(at: indexPath))
            appDelegate.saveContext()
            
        //    tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let actionTop = UITableViewRowAction(style: .default, title: "置顶") { (_, _) in
            
        }
        actionTop.backgroundColor = UIColor(red: 245/255, green: 199/255, blue: 221/255, alpha: 1)
        
        return [actionShare,actionDel,actionTop]
    }
    
    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  sc.isActive ? searchResults.count : areas.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let area = sc.isActive ? searchResults[indexPath.row] : areas[indexPath.row]

        cell.nameLabel.text = area.name
        cell.provinceLabel.text = area.province
        cell.partLabel.text = area.part
        cell.thumbImageView.image = UIImage(data: area.image!)
        cell.thumbImageView.layer.cornerRadius = 10
        
//        cell.accessoryType = areas[indexPath.row] ? .checkmark : .none

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return !sc.isActive
    }
 

   
    // Override to support editing the table view.
   /*
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
          
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
  */
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAreaDetail" {
            let dest = segue.destination as! DetailTableViewController
            dest.area = sc.isActive ?  searchResults[tableView.indexPathForSelectedRow!.row]   : areas[tableView.indexPathForSelectedRow!.row]
        }
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        
    }

}

extension String {
//    func isIncludeChinese() -> Bool {
//        for ch in self.unicodeScalars {
//            if (0x4e00 < ch.value && ch.value < 0x9fff) {
//                return true
//            }
//        }
//        return false
//    }
    
    func transformToPinYin() -> String {
        let stringRef = NSMutableString(string: self) as CFMutableString
        CFStringTransform(stringRef, nil, kCFStringTransformToLatin, false)
        CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false)
        let pinyin = stringRef as String
        return pinyin
    }
    
    func transformToPinyinWithoutBlank() -> String {
        var pinyin = self.transformToPinYin()
        pinyin = pinyin.replacingOccurrences(of: " ", with: "")
        return pinyin
    }
    
    func getPinyinHead() -> String {
        let pinyin = self.transformToPinYin().localizedCapitalized
        var headPinyinStr = ""
        
        for ch in pinyin.description {
            if ch <= "Z" && ch >= "A" {
                headPinyinStr.append(ch)
            }
        }
        return headPinyinStr
    }
    
}

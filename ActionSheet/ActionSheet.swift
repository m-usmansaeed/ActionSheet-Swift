/**
 * Copyright © 2017 MUS.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit


class ActionSheet: UIControl,UITableViewDelegate,UIGestureRecognizerDelegate,UITableViewDataSource {
    
    typealias DidTapAtIndexPath = ((IndexPath) -> Void)
    var selectedIndexPath : DidTapAtIndexPath?
    
    private var containerView : UIView!
    private var shadowView : UIView!
    private var lblTitle : UILabel!
    private var btnClose : UIButton!
    public var selectedIndex = IndexPath()

    private var tableView : UITableView!
    
    var items = [String]()
    var images = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        initialize()
    }
    
    func initialize() {
        
        self.shadowView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        self.containerView = UIView(frame: CGRect(x: 0, y: 1000, width: self.frame.size.width, height: self.frame.size.height))
        self.containerView.backgroundColor = .white
        self.shadowView.addSubview(self.containerView)
        self.lblTitle = UILabel(frame: CGRect(x: 8, y: 8, width: self.frame.size.width - 36, height: 21))
        self.containerView.addSubview(self.lblTitle)
        
        self.btnClose = UIButton(frame: CGRect(x: self.frame.size.width-28, y: 8, width: 20, height: 20))
        self.btnClose.setImage(UIImage(named:"close"), for: .normal)
        
        btnClose.addTarget(self, action: #selector(hide), for: .touchUpInside)
        
        self.containerView.addSubview(self.btnClose)
        
        let separator = UIView(frame: CGRect(x: 0, y: self.lblTitle.frame.size.height + self.lblTitle.frame.origin.y + 8, width: self.frame.size.width, height: 2))
        separator.backgroundColor = .darkGray
        self.containerView.addSubview(separator)
        
        self.tableView = UITableView(frame: CGRect(x:0 ,y: self.lblTitle.frame.size.height + self.lblTitle.frame.origin.y + 9,width: self.frame.size.width,height: self.frame.size.height), style: .plain)
        self.containerView.addSubview(self.tableView)
        
        self.tableView.register(UITableViewCell.classForCoder(),forCellReuseIdentifier: "cell")
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapFrom(recognizer:)))
        tapGestureRecognizer.cancelsTouchesInView = true
        tapGestureRecognizer.delegate = self
        
        self.shadowView.addGestureRecognizer(tapGestureRecognizer)
        self.shadowView.isUserInteractionEnabled = true
        self.shadowView.isExclusiveTouch = true
        self.shadowView.backgroundColor = UIColor(red: 0/225, green: 0/225, blue: 0/225, alpha: 0.5)
        
        self.lblTitle.addGestureRecognizer(tapGestureRecognizer)
        self.lblTitle.isUserInteractionEnabled = true
        self.lblTitle.isExclusiveTouch = true
        self.addSubview(self.shadowView)
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    
    func showActionSheetWithTitle(title : String, scrollEnable:Bool) {
        
        let top = UIApplication.shared.delegate?.window??.rootViewController
        
        if let topVc = top {
            
            self.lblTitle.text = title;
            self.tableView.isScrollEnabled = scrollEnable;
            topVc.view.addSubview(self)
            
            UIView.animate(withDuration: 0.25, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options:[.curveEaseInOut,.transitionCrossDissolve], animations: {
                
                var viewRect = CGRect(origin: self.containerView.frame.origin, size: self.containerView.frame.size)
                
                var Viewheight = CGFloat(self.items.count * 51) + 37.0;
                var ViewYPos = CGFloat(self.frame.size.height) - CGFloat((self.items.count) * 51) - 37.0;
                
                if  Viewheight > CGFloat(topVc.view.frame.size.height) - 65.0 {
                    Viewheight = topVc.view.frame.size.height - 65.0;
                    ViewYPos = 65;
                    self.tableView.isScrollEnabled = true;
                    
                }else{}
                
                viewRect.origin.y = ViewYPos;
                viewRect.size.height = Viewheight;
                self.containerView.frame = viewRect;
                
                var rect = CGRect(origin: self.tableView.frame.origin, size: self.tableView.frame.size)
                
                rect.size.height = viewRect.size.height - 37;
                self.tableView.frame = rect;
                
            }, completion: { (isFinished:Bool) in
                
            })            
        }
    }
    
    
    func handleTapFrom(recognizer : UITapGestureRecognizer) {
        self.hide()
    }
    
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        configureCell(cell: cell, forRowAt: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let itemLabel = UILabel(frame: CGRect(x:51,y: 13,width: self.frame.size.width - 12,height:21))
        cell.addSubview(itemLabel)
        let itemImageView = UIImageView(frame: CGRect(x:8,y: 6,width: 35,height:35))
        itemImageView.contentMode = .scaleAspectFit
        cell.addSubview(itemImageView)
        itemLabel.text = self.items[indexPath.row]
        if self.items.count == self.images.count {
            itemImageView.image =  UIImage(named: self.images[indexPath.row])
        }else{
              assertionFailure("Image count should be equal to items")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath!(indexPath)
        
        self.selectedIndex = indexPath
        sendActions(for: .valueChanged)
        
        self.hide()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51
    }
    
    func hide(){
        
        UIView.animate(withDuration: 0.25, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options:[.curveEaseInOut,.transitionCrossDissolve], animations: {
            
            var viewRect = CGRect(origin: self.containerView.frame.origin, size: self.containerView.frame.size)
            viewRect.origin.y = 1000;
            self.containerView.frame = viewRect;
            
            
        }, completion: { (isFinished:Bool) in
            UIView.animate(withDuration: 0.25, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options:[.curveEaseInOut,.transitionCrossDissolve], animations: {
                self.shadowView.layer.opacity = 0.0
            }, completion: { (isFinished:Bool) in
                self.removeFromSuperview()
            })
        })
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if (touch.view?.superview?.isKind(of: UITableViewCell.classForCoder()))! {
            return false
        }
        return true
        
    }
    
}

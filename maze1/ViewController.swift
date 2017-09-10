//
//  ViewController.swift
//  maze1
//
//  Created by 斧田洋人 on 2017/05/21.
//  Copyright © 2017年 斧田洋人. All rights reserved.
//

import UIKit
import CoreMotion



class ViewController: UIViewController {
    
    var playerView: UIView!
    var playerMotionManager: CMMotionManager!
    var speedX: Double = 0.0
    var speedY: Double = 0.0
    var score: Int = 10000
    
    let screenSize = UIScreen.main.bounds.size
    
    var startView: UIView!
    var goalView: UIView!
    //  var wallView: UIView!
    var maze: [[Int]] = []
    var checkArray: [Int] = []
    let weight = 9
    let height = 13
    var d: Int = 0
    var h: Int = 0
    var w: Int = 0
    
    var wallRectArray = [CGRect]()
    
    var timer: Timer!
    var textlabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        makeMaze()
        makeWall()
        
        //セルの表示
        //        let headerWidth = screenSize.width
        //        let headerHeight:CGFloat = 70
        //        let headerOffsetX = screenSize.width / 2
        //        let headerOffsetY:CGFloat = 25
        //        let headerView = createView(x: 0, y: 0, width: headerWidth, height: headerHeight, offsetX: headerOffsetX, offsetY: headerOffsetY)
        //        self.view.addSubview(headerView)
        //        let underBorder = CALayer()
        //        underBorder.frame = CGRect(x: 0, y: headerHeight, width: headerView.frame.width, height: 10)
        //        underBorder.backgroundColor = UIColor.black.cgColor
        //        headerView.layer.addSublayer(underBorder)
        //
        //        textlabel = UILabel(frame:CGRect(x: 0, y: 0, width: screenSize.width, height: 60))
        
        
        let smallCellWidth = screenSize.width  / (CGFloat((maze[0].count - 1) / 2 * 5 + 1))
        let smallCellHeight = screenSize.height  / (CGFloat((maze.count - 1) / 2 * 5 + 1))
        let bigCellWidth = smallCellWidth * 4
        let bigCellHeight = smallCellHeight * 4
        
//        let bigCellOffsetX = screenSize.width / CGFloat(maze[0].count * 2)
//        let bigCellOffsetY = (screenSize.height) / CGFloat(maze.count * 2) //  - headerHeight - underBorder.frame.height
//        let smallCellOffsetX = bigCellOffsetX / 4
//        let smallCellOffsetY = bigCellOffsetY / 4
//        let verticalCellOffsetX = bigCellOffsetX / 4
//        let verticalCellOffsetY = bigCellOffsetY
//        let horizontalCellOffsetX = bigCellOffsetX
//        let horizontalCellOffsetY = bigCellOffsetY / 4
        
        
        //セルの設定 1:壁 2:スタート 3:ゴール
        
        
        var startY: CGFloat = 0.0
        for y in 0 ..< maze.count {
            if y % 2 == 0 && y != 0{
                startY += bigCellHeight
            }else if y % 2 == 1{
                startY += smallCellHeight
            }
            //            switch y {
            //            case 0:
            //                startY = 0
            //            case 1:
            //                startY += smallCellHeight
            //            case 2:
            //                startY += bigCellHeight
            //            case 3:
            //                startY += smallCellHeight
            //
            //            default:
            //                fatalError()
            //            }
            var startX: CGFloat = 0.0
            for x in 0 ..< maze[y].count {
                if x % 2 == 0 && x != 0{
                    startX += bigCellWidth
                }else if x % 2 == 1{
                    startX += smallCellWidth
                }
                
                //                switch x {
                //                case 0:
                //                    startX = 0
                //                case 1:
                //                    startX += smallCellHeight
                //                case 2:
                //                    startX += bigCellHeight
                //                case 3:
                //                    startX += smallCellHeight
                //
                //                default:
                //                    fatalError()
                //                }
                
                if y % 2 == 0 && x % 2 == 0{ // 1番小さい壁
                    switch maze[y][x] {
                    case 1:
                        let wallView = UIView(frame: CGRect(x: startX, y: startY, width: smallCellWidth, height: smallCellHeight))
                        
                        //                        let wallView = createView(x: x , y: y  , width: smallCellWidth, height: smallCellHeight, offsetX: smallCellOffsetX, offsetY: smallCellOffsetY)
                        print("x: \(x), y: \(y), rect:\(wallView.frame)")
                        wallView.backgroundColor = UIColor.black
                        view.addSubview(wallView)
                        wallRectArray.append(wallView.frame)
                    case 2: // スタート
//                        startView = createView(x: x, y: y, width: smallCellWidth, height: smallCellHeight, offsetX: smallCellOffsetX, offsetY: smallCellOffsetY) //  + headerHeight
                        startView = UIView(frame: CGRect(x: startX, y: startY, width: bigCellWidth, height: bigCellHeight))
                        startView.backgroundColor = UIColor.green
                        view.addSubview(startView)
                    case 3: // ゴール
                         goalView = UIView(frame: CGRect(x: startX, y: startY, width: bigCellWidth, height: bigCellHeight))

//                        goalView = UIView(frame: CGRect(x: startX, y: startY, width: bigCellWidth, height: bigCellHeight))
                        goalView.backgroundColor = UIColor.red
                        view.addSubview(goalView)
                    default:
                        break
                    }
                }else if y % 2 == 1 && x % 2 == 1{ // 一番大きい壁
                    switch maze[y][x] {
                    case 1:
                        //                        let wallView = createView(x: x , y: y  , width: bigCellWidth, height: bigCellHeight, offsetX: bigCellOffsetX, offsetY: bigCellOffsetY)
                        
                        let wallView = UIView(frame: CGRect(x: startX, y: startY, width: bigCellWidth, height: bigCellHeight))
                        print("x: \(x), y: \(y), rect:\(wallView.frame)")
                        
                        wallView.backgroundColor = UIColor.black
                        view.addSubview(wallView)
                        wallRectArray.append(wallView.frame)
                    case 2:
                        startView = UIView(frame: CGRect(x: startX, y: startY, width: bigCellWidth, height: bigCellHeight))
                        startView.backgroundColor = UIColor.green
                        view.addSubview(startView)
                    case 3:
                        goalView = UIView(frame: CGRect(x: startX, y: startY, width: bigCellWidth, height: bigCellHeight))
                        goalView.backgroundColor = UIColor.red
                        view.addSubview(goalView)
                    default:
                        break
                    }
                }else if y % 2 == 0 && x % 2 == 1{ // 横長
                    switch maze[y][x] {
                    case 1:
                        //                        let wallView = createView(x: x , y: y  , width: horizontalCellWidth, height: horizontalCellHeight, offsetX: horizontalCellOffsetX, offsetY: horizontalCellOffsetY)
                        
                        let wallView = UIView(frame: CGRect(x: startX, y: startY, width: bigCellWidth, height: smallCellHeight))
                        print("x: \(x), y: \(y), rect:\(wallView.frame)")
                        wallView.backgroundColor = UIColor.black
                        view.addSubview(wallView)
                        wallRectArray.append(wallView.frame)
                    case 2:
                        startView = UIView(frame: CGRect(x: startX, y: startY, width: bigCellWidth, height: bigCellHeight))
                        startView.backgroundColor = UIColor.green
                        view.addSubview(startView)
                    case 3:
                        goalView = UIView(frame: CGRect(x: startX, y: startY, width: bigCellWidth, height: bigCellHeight))
                        goalView.backgroundColor = UIColor.red
                        view.addSubview(goalView)
                    default:
                        break
                    }
                }else{ // 縦長
                    switch maze[y][x] {
                    case 1:
                        //                        let wallView = createView(x: x , y: y  , width: verticalCellWidth, height: verticalCellHeight, offsetX: verticalCellOffsetX, offsetY: verticalCellOffsetY)
                        let wallView = UIView(frame: CGRect(x: startX, y: startY, width: smallCellWidth, height: bigCellHeight))
                        print("x: \(x), y: \(y), rect:\(wallView.frame)")
                        wallView.backgroundColor = UIColor.black
                        view.addSubview(wallView)
                        wallRectArray.append(wallView.frame)
                    case 2:
                        startView = UIView(frame: CGRect(x: startX, y: startY, width: bigCellWidth, height: bigCellHeight))
                        startView.backgroundColor = UIColor.green
                        view.addSubview(startView)
                    case 3:
                        goalView = UIView(frame: CGRect(x: startX, y: startY, width: bigCellWidth, height: bigCellHeight))
                        goalView.backgroundColor = UIColor.red
                        view.addSubview(goalView)
                    default:
                        break
                    }
                }
                
            }
        }
        //        self.view.addSubview(textlabel)
        //        textlabel.textAlignment = NSTextAlignment.center
        //        textlabel.textColor = UIColor.white
        //        textlabel.backgroundColor = UIColor(colorLiteralRed: 176/255, green: 196/255, blue: 222/255, alpha: 0.8)
        
        //        for y in 0 ..< height{
        //            for x in 0 ..< weight{
        //                if maze[y][x] == 0{
        //                    print("⬜️", separator: "", terminator: "")
        //                }else if maze[y][x] == 1 {
        //                    print("⬛️", separator: "", terminator: "")
        //                }
        //            }
        //            print("")
        //        }
        
        //プレイヤーの設定
        playerView = UIView(frame: CGRect(x: 0, y: 0, width: bigCellWidth / 6, height: bigCellHeight / 6))
        playerView.center = startView.center
        playerView.backgroundColor = UIColor.gray
        self.view.addSubview(playerView)
        
        
        //加速度の設定
        playerMotionManager = CMMotionManager()
        playerMotionManager.accelerometerUpdateInterval = 0.02
        self.startAccelerometer()
        //        timer = Timer(timeInterval: 0.1, target: self, selector: #selector(self.up), userInfo: nil, repeats: true)
        //        timer.fire()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.up), userInfo: nil, repeats: true)
        
    }
    
    func makeMaze(){
        //要素が0の配列を作る
        for y in 0 ..< height{            var tempArray:[Int] = []
            for x in 0 ..< weight{
                tempArray.append(0)
                
                if tempArray.count == weight{
                    maze.append(tempArray)
                }
            }
        }
        
        //外側を壁にする
        for h in 0 ..< height{
            maze[h][0] = 1
            maze[h][weight - 1] = 1
            
            if h == 0 || h == height - 1 {
                for w in 0 ..< weight{
                    maze[h][w] = 1
                }
                
            }
        }
        //奇数*奇数マスを壁にする
        for h in 0 ..< height{
            for w in 0 ..< weight{
                if h % 2 == 0 && w % 2 == 0{
                    maze[h][w] = 1
                }
            }
        }
        //スタートとゴール
        maze[1][1] = 2
        maze[11][7] = 3
        
    }
    
    //棒倒し法で壁を作る
    func makeWall(){
        for h in 2 ..< height - 2{
            for w in 2 ..< weight - 2{
                if h % 2 == 0 && w % 2 == 0{
                    
                    //上下左右に壁がないかチェック　上:0　右:1　下:2　左:3
                    //壁がなかったらcheckArrayに数値を追加
                    
                    if h == 2{
                        if maze[h - 1][w] == 0{
                            checkArray.append(0)
                        }
                    }
                    if maze[h][w + 1] == 0{
                        checkArray.append(1)
                    }
                    if maze[h + 1][w] == 0{
                        checkArray.append(2)
                    }
                    if w != 0{
                        if maze[h][w - 1] == 0{
                            checkArray.append(3)
                        }
                    }
                    
                    
                    //      print(checkArray)
                    
                    //棒を倒す
                    if checkArray.count != 0{
                        d = Int(arc4random_uniform(UInt32(checkArray.count)))
                        var i: Int = checkArray[d]
                        if i == 0{
                            maze[h - 1][w] = 1
                        }else if i == 1{
                            maze[h][w + 1] = 1
                        }else if i == 2{
                            maze[h + 1][w] = 1
                        }else if i == 3{
                            maze[h][w - 1] = 1
                        }
                    }
                    checkArray = []
                }
                
            }
        }
        //外側を削除する
        //        maze.removeFirst()
        //        maze.removeLast()
        //        for y in 0 ..< maze.count {
        //            maze[y].removeFirst()
        //            maze[y].removeLast()
        //        }
        
        
    }
    
    func startAccelerometer() {
        let handler: CMAccelerometerHandler = {(CMAccelerometerData:CMAccelerometerData?, error:Error?) -> Void in
            self.speedX += CMAccelerometerData!.acceleration.x
            self.speedY += CMAccelerometerData!.acceleration.y
            
            //プレイヤーの中心位置を設定
            var posX = self.playerView.center.x + (CGFloat(self.speedX) / 3)
            var posY = self.playerView.center.y - (CGFloat(self.speedY) / 3)
            print(posX)
            print(self.playerView.frame.width)
            
            //画面外に出たらゲームオーバー
            
            if posX <= self.playerView.frame.width / 2{
                self.stop()
                self.gameCheck(result: "GameOver", massege: "壁に当たりました")
                return
            }
            if posY <= self.playerView.frame.height / 2  {
                self.stop()
                self.gameCheck(result: "GameOver", massege: "壁に当たりました")
                return
            }
            if posX >= self.screenSize.width - (self.playerView.frame.width / 2){
                self.stop()
                self.gameCheck(result: "GameOver", massege: "壁に当たりました")
                return
            }
            if posY >= self.screenSize.height - (self.playerView.frame.height / 2){
                self.stop()
                self.gameCheck(result: "GameOver", massege: "壁に当たりました")
                return
            }
            
            //当たり判定
            for wallRect in self.wallRectArray {
                if (wallRect.intersects(self.playerView.frame)){
                    self.stop()
                    self.gameCheck(result: "GameOver", massege: "壁に当たりました")
                    return
                }
            }
            if (self.goalView.frame.intersects(self.playerView.frame)){
                self.stop()
                self.gameCheck(result: "Clear", massege: "クリアしました！")
                return
            }
            
            self.playerView.center = CGPoint(x: posX, y: posY)
            
            
        }
        //加速度を与える
        playerMotionManager.startAccelerometerUpdates(to: OperationQueue.main, withHandler: handler)
    }
    
    func up(){
        score = score - 1
        //        textlabel.text = String(score)
        //        textlabel.font = UIFont.systemFont(ofSize: 25.0)
    }
    
    func stop(){
        if timer.isValid == true{
            self.timer.invalidate()
        }
        //        score = 10000
        //        textlabel.text = ""
    }
    
    //終了後の動作
    func gameCheck(result: String, massege: String){
        if playerMotionManager.isAccelerometerActive{     //動いてたら
            playerMotionManager.stopAccelerometerUpdates()    //止める
        }
        
        //アラートの設定
        let gameCheckAlert: UIAlertController = UIAlertController(title: result, message: massege, preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "もう一度", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            self.retry()
        })
        let updateAction = UIAlertAction(title: "迷路を更新", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            self.update()
            self.retry()
        })
        let goHomeAction = UIAlertAction(title: "タイトルへ戻る", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
        gameCheckAlert.addAction(retryAction)
        gameCheckAlert.addAction(updateAction)
        gameCheckAlert.addAction(goHomeAction)
        
        self.present(gameCheckAlert, animated: true, completion: nil)
    }
    
    //プレイヤーの初期化
    func retry() {
        playerView.center = startView.center
        if !playerMotionManager.isAccelerometerActive{
            self.startAccelerometer()
        }
        
        speedX = 0.0
        speedY = 0.0
        timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(self.up), userInfo: nil, repeats: true)
    }
    
    //迷路の初期化
    func update() {
        loadView()
        viewDidLoad()
        maze = []  //迷路の初期化
        wallRectArray = []  //壁の初期化
        makeMaze()
        makeWall()
        
        let smallCellWidth = screenSize.width  / (CGFloat((maze[0].count - 1) / 2 * 5 + 1))
        let smallCellHeight = screenSize.height  / (CGFloat((maze.count - 1) / 2 * 5 + 1))
        let bigCellWidth = smallCellWidth * 4
        let bigCellHeight = smallCellHeight * 4
        
        //        let bigCellOffsetX = screenSize.width / CGFloat(maze[0].count * 2)
        //        let bigCellOffsetY = (screenSize.height) / CGFloat(maze.count * 2) //  - headerHeight - underBorder.frame.height
        //        let smallCellOffsetX = bigCellOffsetX / 4
        //        let smallCellOffsetY = bigCellOffsetY / 4
        //        let verticalCellOffsetX = bigCellOffsetX / 4
        //        let verticalCellOffsetY = bigCellOffsetY
        //        let horizontalCellOffsetX = bigCellOffsetX
        //        let horizontalCellOffsetY = bigCellOffsetY / 4
        
        
        //セルの設定 1:壁 2:スタート 3:ゴール
        
        
        var startY: CGFloat = 0.0
        for y in 0 ..< maze.count {
            if y % 2 == 0 && y != 0{
                startY += bigCellHeight
            }else if y % 2 == 1{
                startY += smallCellHeight
            }
            //            switch y {
            //            case 0:
            //                startY = 0
            //            case 1:
            //                startY += smallCellHeight
            //            case 2:
            //                startY += bigCellHeight
            //            case 3:
            //                startY += smallCellHeight
            //
            //            default:
            //                fatalError()
            //            }
            var startX: CGFloat = 0.0
            for x in 0 ..< maze[y].count {
                if x % 2 == 0 && x != 0{
                    startX += bigCellWidth
                }else if x % 2 == 1{
                    startX += smallCellWidth
                }
                
                //                switch x {
                //                case 0:
                //                    startX = 0
                //                case 1:
                //                    startX += smallCellHeight
                //                case 2:
                //                    startX += bigCellHeight
                //                case 3:
                //                    startX += smallCellHeight
                //
                //                default:
                //                    fatalError()
                //                }
                
                if y % 2 == 0 && x % 2 == 0{ // 1番小さい壁
                    switch maze[y][x] {
                    case 1:
                        let wallView = UIView(frame: CGRect(x: startX, y: startY, width: smallCellWidth, height: smallCellHeight))
                        
                        //                        let wallView = createView(x: x , y: y  , width: smallCellWidth, height: smallCellHeight, offsetX: smallCellOffsetX, offsetY: smallCellOffsetY)
                        print("x: \(x), y: \(y), rect:\(wallView.frame)")
                        wallView.backgroundColor = UIColor.black
                        view.addSubview(wallView)
                        wallRectArray.append(wallView.frame)
                    case 2: // スタート
                        //                        startView = createView(x: x, y: y, width: smallCellWidth, height: smallCellHeight, offsetX: smallCellOffsetX, offsetY: smallCellOffsetY) //  + headerHeight
                        startView = UIView(frame: CGRect(x: startX, y: startY, width: bigCellWidth, height: bigCellHeight))
                        startView.backgroundColor = UIColor.green
                        view.addSubview(startView)
                    case 3: // ゴール
                        goalView = UIView(frame: CGRect(x: startX, y: startY, width: bigCellWidth, height: bigCellHeight))
                        
                        //                        goalView = UIView(frame: CGRect(x: startX, y: startY, width: bigCellWidth, height: bigCellHeight))
                        goalView.backgroundColor = UIColor.red
                        view.addSubview(goalView)
                    default:
                        break
                    }
                }else if y % 2 == 1 && x % 2 == 1{ // 一番大きい壁
                    switch maze[y][x] {
                    case 1:
                        //                        let wallView = createView(x: x , y: y  , width: bigCellWidth, height: bigCellHeight, offsetX: bigCellOffsetX, offsetY: bigCellOffsetY)
                        
                        let wallView = UIView(frame: CGRect(x: startX, y: startY, width: bigCellWidth, height: bigCellHeight))
                        print("x: \(x), y: \(y), rect:\(wallView.frame)")
                        
                        wallView.backgroundColor = UIColor.black
                        view.addSubview(wallView)
                        wallRectArray.append(wallView.frame)
                    case 2:
                        startView = UIView(frame: CGRect(x: startX, y: startY, width: bigCellWidth, height: bigCellHeight))
                        startView.backgroundColor = UIColor.green
                        view.addSubview(startView)
                    case 3:
                        goalView = UIView(frame: CGRect(x: startX, y: startY, width: bigCellWidth, height: bigCellHeight))
                        goalView.backgroundColor = UIColor.red
                        view.addSubview(goalView)
                    default:
                        break
                    }
                }else if y % 2 == 0 && x % 2 == 1{ // 横長
                    switch maze[y][x] {
                    case 1:
                        //                        let wallView = createView(x: x , y: y  , width: horizontalCellWidth, height: horizontalCellHeight, offsetX: horizontalCellOffsetX, offsetY: horizontalCellOffsetY)
                        
                        let wallView = UIView(frame: CGRect(x: startX, y: startY, width: bigCellWidth, height: smallCellHeight))
                        print("x: \(x), y: \(y), rect:\(wallView.frame)")
                        wallView.backgroundColor = UIColor.black
                        view.addSubview(wallView)
                        wallRectArray.append(wallView.frame)
                    case 2:
                        startView = UIView(frame: CGRect(x: startX, y: startY, width: bigCellWidth, height: bigCellHeight))
                        startView.backgroundColor = UIColor.green
                        view.addSubview(startView)
                    case 3:
                        goalView = UIView(frame: CGRect(x: startX, y: startY, width: bigCellWidth, height: bigCellHeight))
                        goalView.backgroundColor = UIColor.red
                        view.addSubview(goalView)
                    default:
                        break
                    }
                }else{ // 縦長
                    switch maze[y][x] {
                    case 1:
                        //                        let wallView = createView(x: x , y: y  , width: verticalCellWidth, height: verticalCellHeight, offsetX: verticalCellOffsetX, offsetY: verticalCellOffsetY)
                        let wallView = UIView(frame: CGRect(x: startX, y: startY, width: smallCellWidth, height: bigCellHeight))
                        print("x: \(x), y: \(y), rect:\(wallView.frame)")
                        wallView.backgroundColor = UIColor.black
                        view.addSubview(wallView)
                        wallRectArray.append(wallView.frame)
                    case 2:
                        startView = UIView(frame: CGRect(x: startX, y: startY, width: bigCellWidth, height: bigCellHeight))
                        startView.backgroundColor = UIColor.green
                        view.addSubview(startView)
                    case 3:
                        goalView = UIView(frame: CGRect(x: startX, y: startY, width: bigCellWidth, height: bigCellHeight))
                        goalView.backgroundColor = UIColor.red
                        view.addSubview(goalView)
                    default:
                        break
                    }
                }
                
            }
        }

        
        //
        //        //        for y in 0 ..< height{
        //        //            for x in 0 ..< weight{
        //        //                if maze[y][x] == 0{
        //        //                    print("⬜️", separator: "", terminator: "")
        //        //                }else if maze[y][x] == 1 {
        //        //                    print("⬛️", separator: "", terminator: "")
        //        //                }
        //        //            }
        //        //            print("")
        //        //        }
        playerView = UIView(frame: CGRect(x: 0, y: 0, width: bigCellWidth / 6, height: bigCellHeight / 6))
        playerView.center = startView.center
        playerView.backgroundColor = UIColor.gray
        self.view.addSubview(playerView)
        
        playerMotionManager = CMMotionManager()
        playerMotionManager.accelerometerUpdateInterval = 0.02
        self.startAccelerometer()
        //
        //        
        //        self.view.addSubview(textlabel)
        //        textlabel.textColor = UIColor.white
        //        textlabel.backgroundColor = UIColor(colorLiteralRed: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
    }
    
    
    
    
    
}

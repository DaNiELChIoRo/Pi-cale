//
//  ViewController.swift
//  Pícale
//
//  Created by Daniel R Meneses on 09/09/17.
//  Copyright © 2017 Ironchorch. All rights reserved.
//

import UIKit
import AVFoundation
import Social


class ViewController: UIViewController {
    
    @IBOutlet weak var PicaleButton: UIButton!
    @IBOutlet weak var PicaleTiempo: UILabel!
    
    var picalecontador = 4
    var contador = 1
    var MejorPuntuacionPromedio:Float32 = 0
    var PuntuacionPromedio:Float32 = 0
    var HighScore:Float32 = 0
    var counter = 4
    var timer1 = Timer()
    var timer = Timer()
    var audioPlayer = AVAudioPlayer()
    @IBOutlet weak var TiempoPicale: UILabel!
    var audioPlayer1 = AVAudioPlayer()
    var audioPlayer2 = AVAudioPlayer()
    var audioPlayer3 = AVAudioPlayer()
    
//Botón para compartir
    @IBAction func BotonCompartir(_ sender: Any) {
        
        let link = NSURL(string: "link de la app en AppStore")
        //Fotocaptura
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, true, 0.0)
        self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let img = img, let link = link {
            let objectsToShare = [img,link] as [Any]
            let activityVC = UIActivityViewController(activityItems:/*Aquí va lo que se desea compartir*/ ["Te reto a superar mi marca en Pícale", objectsToShare], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            
            self.present(activityVC, animated: true, completion: nil)
            
        }
    }
    
    override func viewDidLoad() {
        
        SegundosPicale.keyboardType = UIKeyboardType.decimalPad
        
        
//Anuncios
     //Petición
        /* let request = GADRequest()
         request.testDevice = [kGADSimulatorID]*/
    //Configuración
        /*myBanner.adUnitID = "IDdelanuncio"
         myBanner.rootViewController = self
         myBanner.delegate = self   
         myBanner.load(request)*/
        
        
        let HighScoreDefault = UserDefaults.standard
        
        if (HighScoreDefault.value(forKey: "MejorPuntuación") != nil){
            HighScore = HighScoreDefault.value(forKey: "MejorPuntuación") as! Float32
            //mejorpuntuacionLabel.text = String(format: "0 : i%", HighScore)
             mejorpuntuacionLabel.text = "\(String(format:"%.2f",HighScore))"
            print("EL MEJOR PROMEDIO ALMACENADO ES= \(HighScore)")
        }
        super.viewDidLoad() 
        
        view.addBackground()
        
        view.addBackground(imageName: "Fondo Pícale")
        
        view.addBackground(contextMode: .scaleAspectFit)
        
        view.addBackground(imageName: "Fondo Pícale", contextMode: .scaleAspectFit)
    
        
        PicaleButton.isEnabled = false;
        
        do{
            let audioPath = Bundle.main.path(forResource: "SonidoConteo5ms", ofType: ".mp3")
            try audioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
        }catch{
            //ERROR
        }
        do{
            let audioPath1 = Bundle.main.path(forResource: "SonidoConteoFinal", ofType: ".mp3")
            try audioPlayer1 = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath1!))
        }catch{
            print("Problema audio de Conteo")}
        do{
            let audioPath2 = Bundle.main.path(forResource: "SonidoPícale", ofType: ".mp3")
            try audioPlayer2 = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath2!))
        } catch {
            print("Problema audio Picale")
        }
        do{
            let audioPath3 = Bundle.main.path(forResource: "SonidoPicaleFinal", ofType: ".mp3")
            try audioPlayer3 = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath3!))
        } catch {
            print("Problema audio Picale al Final")
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func KeyboardHide(_ sender: Any) {
       dismissKeyboard()
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    

    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Tiempo de Picadas
    @IBOutlet weak var SegundosPicale: UITextField!
    @IBAction func SegundosPicale(_ sender: UITextField) {
        
   
    }
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var mejorpuntuacionLabel: UILabel!
    @IBOutlet weak var PromedioPicale: UILabel!
    
    @IBAction func PicaleButton(_ sender: UIButton) {
        audioPlayer2.play()
        contador += 1
        label.text = "\(contador)"
        print(contador)

        
    }
    func PicaleTimer() {
        timer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction1), userInfo: nil, repeats: true)
        
    }
    
    func timerAction1() {
        
        
        picalecontador -= 1
        
        PicaleTiempo.text = "\(picalecontador-1)"
        
        if picalecontador == 1 {
            timer1.invalidate();
            Button1.isEnabled = true; PicaleButton.isEnabled = false ; audioPlayer3.play(); resetTimer (); ResetPicaleTimer(); mejorpuntuacionLabel.text = "\(String(format:"%.2f",HighScore))" ; PicaleTiempo.text = "0";
            let contadorDouble = Double(contador); let picalecontadorDouble = Double(picalecontador)
            PuntuacionPromedio = Float32(contadorDouble/picalecontadorDouble);
            //Mostramos el promedio de la puntación actual
            print("EL VALOR DE PICADAS ENTRE SEGUNDO ES = \(String(format:"%.2f",PuntuacionPromedio))");
            PromedioPicale.text = "\(String(format:"%.2f",PuntuacionPromedio))"
           
          //  Esto funciona bn: atte ironchorch
            if (PuntuacionPromedio > HighScore) {
                
                HighScore = 0
                
                HighScore = PuntuacionPromedio
                
                let HighScoreDefault = UserDefaults.standard
                HighScoreDefault.setValue(HighScore, forKey: "MejorPuntuación")
                HighScoreDefault.synchronize()
                mejorpuntuacionLabel.text = "\(String(format:"%.2f",HighScore))"
                print("El MEJOR PROMEDIO ES = \(HighScore)")
            }

        }
    }

    func ResetPicaleTimer () {
        let segundos = Double(SegundosPicale.text!)
        
        let outputValue = Double(segundos!)
        
        picalecontador = Int(Double(outputValue))
       
    }
    
    @IBOutlet weak var Button1: UIButton!
    
    @IBAction func Button1(_ sender: UIButton) {
        
        if SegundosPicale == nil { createAlert (); timer1.invalidate(); timer.invalidate()
        }
        
        let segundos = Double(SegundosPicale.text!)
        if SegundosPicale.text=="" {timer.invalidate();timer1.invalidate()}
        else {
        let outputValue = Double(segundos! + 1)
             picalecontador  = Int(Double(outputValue))
             print("EL VALOR ACOMULADO ES = \(outputValue)")
        }
     
        if SegundosPicale.text == "0" { createAlert (); timer.invalidate() ;timer1.invalidate()
        }
        
        
   //CONDICIONALES SEGUNDOS PICALE
        timer.invalidate()
        if let text = SegundosPicale.text, SegundosPicale.text != "0" && !text.isEmpty {
            startTimer() }
        else {timer .invalidate(); AlertaContadorCero()}
        contador = 0
           }
    
    func startTimer () {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
        func timerAction() {
            counter -= 1

            
                Button1.setTitle("\(counter)", for: .normal)
            
                if counter != 0 {
                audioPlayer.play()
                }
            if counter == 0 {
                timer.invalidate(); audioPlayer1.play();
                Button1.isEnabled = false; PicaleButton.isEnabled = true ; PicaleTimer (); 
            }
        }
    
    func resetTimer () {
//función para volver a empezar el contador
        timer.invalidate()
        counter = 3
        Button1.setTitle("Siguiente Jugador (O el mismo sí esta traumado) PÍCALE AQUÍ", for: .normal)
        Button1.isEnabled = true
    }
    
 //ALERTAS
    func createAlert () {
        
        let alertcontroller = UIAlertController(title: "Alerta del contador", message: "Introduce un número distinto de cero dentro del contador", preferredStyle: .actionSheet)
        
        let alertaction = UIAlertAction(title: "CERRAR", style: .destructive, handler: { Action in self.resetTimer()})
        
        alertcontroller.addAction(alertaction)
        
        resetTimer()
        
        self.present(alertcontroller, animated: true, completion: nil)
        
                }
    func createAlert1 () {
        let alert = UIAlertController(title: "Alerta del contador", message: "Introduce un número dentro del contador", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "CERRAR", style: .destructive, handler: { (action) in
            alert.dismiss(animated: true, completion: nil) }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func AlertaContadorCero () {
        let alert = UIAlertController(title: "Alerta del contador", message: "Introduce un número distinto de cero dentro del contador", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "CERRAR", style: .destructive, handler: { (action) in
            alert.dismiss(animated: true, completion: nil) }))
        
        self.present(alert, animated: true, completion: nil)
    }

    
   }

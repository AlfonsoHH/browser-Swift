//
//  ViewController.swift
//  ProyectoNavegador
//
//  Created by Alfonso Hernandez on 23/10/17.
//  Copyright © 2017 Alfonso Hernandez. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase

class ViewController: UIViewController, UIWebViewDelegate {

    
    //variables de los elementos gráficos
    @IBOutlet weak var btBack: UIButton!
    @IBOutlet weak var btForward: UIButton!
    @IBOutlet weak var btOk: UIButton!
    @IBOutlet weak var cajaTexto: UITextField!
    @IBOutlet weak var navegador: UIWebView!
    @IBOutlet weak var lbl_webActual: UILabel!
    
    var texto = ""
    var textoBuscador = ""
    

    //sobreescribimos que queremos que haga al cargar, en este caso iniciar google
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btBack.isEnabled=false
        btForward.isEnabled=false
        
        cajaTexto.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        cajaTexto.text = "https://www.google.es"
        lbl_webActual.text = "https://www.google.es"
        navegador.loadRequest(URLRequest(url: URL(string: "http://www.google.es")!))
        
    }
    
    //funcion q se ejecuta cnd el texto de la caja cambia y activa/desactiva los botones
    func textFieldDidChange(_ textField: UITextField) {

        
        if (cajaTexto.text?.characters.count)! > 0 {
            btOk.isEnabled=true
        }
        else {
            btOk.isEnabled=false
            
        }
        
    }
    
    //funcion cuando termine de cargar el navegador, cargue la url en el textfield de abajo y llamar al metodo guardar
    func webViewDidFinishLoad(_ webView: UIWebView) {
        lbl_webActual.text = navegador.request?.url?.absoluteString
        if navegador.canGoBack {
            btBack.isEnabled=true
            
        }
        else {
            btBack.isEnabled=false
        }
        
        if navegador.canGoForward {
            btForward.isEnabled=true
            
        }
        else {
            btForward.isEnabled=false
        }
        guardar()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        texto=cajaTexto.text!
        
        textoBuscador = "http://www.google.com/search?q=\(texto)"
        
        navegador.loadRequest(URLRequest(url: URL(string: textoBuscador)!))
        guardar()
    }

    
    //cuando se pulse enter->se carga la url en el navegador y se llama a la funcion de barraInferior
    @IBAction func enterCajaTexto(_ sender: Any) {
        
        texto=anadirHttp(textoFuncion: cajaTexto.text!)
        
        navegador.loadRequest(URLRequest(url: URL(string: texto)!))
        
        textoBarraInferior()
        
    }

    //volver
    @IBAction func back(_ sender: Any) {
        if (navegador.canGoBack){
            navegador.goBack()
        }
        textoBarraInferior()
    }
    //hacia delante
    @IBAction func forward(_ sender: Any) {
        if (navegador.canGoForward){
            navegador.goForward()
        }
        textoBarraInferior()
    }
    //ok
    @IBAction func navegarAccion(_ sender: Any) {
        navegador.loadRequest(URLRequest(url: URL(string: cajaTexto.text!)!))
        
        textoBarraInferior()
    }
    //cargar la url actual
    func textoBarraInferior(){
        
        lbl_webActual.text = navegador.request?.url?.absoluteString
        
    }
    //guardar en la base de datos
    func guardar(){
        
        let ref=Database.database().reference()
     
        ref.child("web").childByAutoId().setValue(lbl_webActual.text)
        
    }
    
    //funcion para añadir http
    func anadirHttp(textoFuncion: String) -> String{
        
        if textoFuncion.contains("http://www."){
            return textoFuncion
        }else if textoFuncion.contains("www."){
            return "http:\(textoFuncion)"
        }else{
            return "http://www.\(textoFuncion)"
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}


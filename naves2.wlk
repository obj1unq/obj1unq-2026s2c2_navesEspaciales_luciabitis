class Nave {
  var property velocidad
  
  method recibirAmenaza() 
  
  method propulsar() {
    velocidad = (velocidad + 20000).min(300000)
  }
  
  method preparseParaViajar() {
    velocidad = (velocidad + 15000).min(300000)
  }
  
  method encontrarseConEnemigo() {
    self.recibirAmenaza()
    self.propulsar()
  }
}

class NaveDeCarga inherits Nave {
  var property carga
  
  method sobrecargada() = carga > 100000
  
  method excedidaDeVelocidad() = velocidad > 100000
  
  override method recibirAmenaza() {
    carga = 0
  }
  
  method enFalta() = self.sobrecargada() and self.excedidaDeVelocidad()
  
  method acercamientoDeControl() {
    if (self.enFalta()) self.recibirAmenaza()
  }
}

class NaveDePasajeros inherits Nave {
  var alarma = false
  const cantidadDePasajeros
  
  method tripulacion() = cantidadDePasajeros + 4
  
  method velocidadMaximaPermitida() = (300000 / self.tripulacion()) - if (cantidadDePasajeros > 100)
                                                                        200
                                                                      else 0
  
  method estaEnPeligro() = (velocidad > self.velocidadMaximaPermitida()) or alarma
  
  override method recibirAmenaza() {
    alarma = true
  }
  
  method alarma() = alarma
}

class NaveDeCombate inherits Nave {
  var property modo = reposo
  const property mensajesEmitidos = []
  
  method emitirMensaje(mensaje) {
    mensajesEmitidos.add(mensaje)
  }
  
  method ultimoMensaje() = mensajesEmitidos.last()
  
  method estaInvisible() = (velocidad < 10000) and modo.invisible()
  
  override method recibirAmenaza() {
    modo.recibirAmenaza(self)
  }
  
  override method preparseParaViajar() {
    super()
    modo.preparseParaViajar(self)
  }
}

object reposo {
  method invisible() = false
  
  method recibirAmenaza(nave) {
    nave.emitirMensaje("¡RETIRADA!")
  }
  
  method preparseParaViajar(nave) {
    nave.emitirMensaje("Saliendo en misión")
  }
}

object ataque {
  method invisible() = true
  
  method recibirAmenaza(nave) {
    nave.emitirMensaje("Enemigo encontrado")
  }
  
  method preparseParaViajar(nave) {
    nave.emitirMensaje("Volviendo a la base")
  }
}

class NaveDeResiduosRadioactivos inherits NaveDeCarga {
  var property selladaAlVacio = false
  
  override method recibirAmenaza() {
    velocidad = 0
  }
  
  override method preparseParaViajar() {
    selladaAlVacio = true
    super()
  }
}
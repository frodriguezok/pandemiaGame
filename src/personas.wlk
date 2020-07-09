import manzanas.*
import simulacion.*

class Persona {
	var property estaAislada = false
	var property diaQueSeInfecto = null
	var property estaInfectada = false
	var property presentaSintomas = false
	
	method estaInfectada() {
		return estaInfectada
	}
	
	method infectarse() {
		self.diaQueSeInfecto(simulacion.diaActual()) 
		estaInfectada = true
	}
	
	method respetaCuarentena() {
		return self.estaAislada()
	}

}	
// Agregue atributos para registrar, si esta aislada, respeta la cuarentena
// dia que se infecto, si esta infectada, y presenta sientomas.
// A parte, hice el metodo estaInfectada, e infectarse()

//inicialice las variables


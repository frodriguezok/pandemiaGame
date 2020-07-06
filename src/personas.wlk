import manzanas.*
import simulacion.*

class Persona {
	var property estaAislada
	var property respetaCuarentena
	var property diaQueSeInfecto = null
	var estaInfectada = false
	var property presentaSintomas
	
	method estaInfectada() {
		return estaInfectada
	}
	
	method infectarse() {
		self.diaQueSeInfecto(simulacion.diaActual()) 
		estaInfectada = true
	}

}	
// Agregue atributos para registrar, si esta aislada, respeta la cuarentena
// dia que se infecto, si esta infectada, y presenta sientomas.
// A parte, hice el metodo estaInfectada, e infectarse()



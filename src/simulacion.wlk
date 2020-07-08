import personas.*
import manzanas.*
import wollok.game.*
object simulacion {
	
	var property diaActual = 0
	const property manzanas = []
	var property cantidadPersonas = 0
	//var property cantidadInfectados = 0
	
	// parametros del juego
	const property chanceDePresentarSintomas = 30
	const property chanceDeContagioSinCuarentena = 25
	const property chanceDeContagioConCuarentena = 2
	const property personasPorManzana = 10
	const property duracionInfeccion = 20

	/*
	 * este sirve para generar un azar
	 * p.ej. si quiero que algo pase con 30% de probabilidad pongo
	 * if (simulacion.tomarChance(30)) { ... } 
	 */ 	
	method tomarChance(porcentaje) = 0.randomUpTo(100) < porcentaje

	method agregarManzana(manzana) { manzanas.add(manzana) }
	
	method debeInfectarsePersona(persona, cantidadContagiadores) {
		const chanceDeContagio = if (persona.respetaCuarentena()) 
			self.chanceDeContagioConCuarentena()
			else 
			self.chanceDeContagioSinCuarentena()
		return (1..cantidadContagiadores).any({n => self.tomarChance(chanceDeContagio) })	
	}
	
	method presentarSintomas() {
		return self.tomarChance(self.chanceDePresentarSintomas())
	}

	method crearManzana() {
		
		const nuevaManzana = new Manzana()
		(1..self.personasPorManzana()).forEach({
			m => nuevaManzana.personaEnManzana([new Persona()])
		}) 
		
		cantidadPersonas += nuevaManzana.cantidadDePersonasEnLaManzana()
		
		return nuevaManzana
	}
	
	method agregarInfectado() {
		const personaInfectada = new Persona()
		personaInfectada.infectarse()
		manzanas.anyOne().personaEnManzana([personaInfectada])
		cantidadPersonas += 1
	}
	
	method evaluarInfectados() {
		return manzanas.sum({m=> m.cantidadDeInfectados()})
	}
	
	method evaluarSintomas() {
		return manzanas.sum({m=> m.cantidadConSintomas()})
	}
	
	
	method siguienteDia(){
		self.diaActual(self.diaActual()+1)
		manzanas.forEach({m=>m.pasarUnDia()})
	}
	
}

object agenteDeSalud {
	var position
	var property image = "indicador.png"
	
	method position(x,y){
		position = game.at(x,y)}
	
	method position(){return position}
	
	method moveteArriba(){
		position = position.up(1)
	}
	method moveteAbajo(){
		position = position.down(1)
	}
	
	method moveteIzquierda(){
		position = position.left(1)
	}
	
	method moveteDerecha(){
		position = position.right(1)
	}
	
	method aislarAInfectados() {}
}

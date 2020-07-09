import personas.*
import simulacion.*
import wollok.game.*

class Manzana {
	var property personas = []
	var property position
	
	method personaEnManzana(persona) {personas.addAll(persona)}
	
	method sacarPersonaManzana(persona){
		personas.remove(persona)
	}
	
	method image() {
		// reeemplazarlo por los distintos colores de acuerdo a la cantidad de infectados
		// también vale reemplazar estos dibujos horribles por otros más lindos
		return if( self.cantidadDeInfectados() == 0 )
		{
			"blanco.png"
		} else if (self.cantidadDeInfectados().between(1,3))
		{
			"amarillo.png"
		} else if (self.cantidadDeInfectados().between(4,7))
		{
			"naranja.png"
		} else if (self.cantidadDeInfectados().between(8,personas.size() - 1))
		{
			"naranjaOscuro.png"
		}
		else if (self.cantidadDeInfectados() == personas.size()) //FALTABA EL SI ESTABAN todos INFECTADOS
		{
			"rojo.png"
		}
	}
	//Cantidad de peronas que hay en la manzana
	method cantidadDePersonasEnLaManzana(){
		return personas.size()
	}
	//Para saber cuantos infectados hay
	method cantidadDeInfectados(){
		return personas.count({ p => p.estaInfectada()})
	}
	
	method cantidadConSintomas() {
		return personas.count({ p => p.presentaSintomas()})
	}
	
	// este les va a servir para el movimiento
	method esManzanaVecina(manzana) {
		return manzana.position().distance(position) == 1
	}

	method pasarUnDia() {
		self.trasladoDeUnHabitante()
		self.simulacionContagiosDiarios()
		self.terminoLaEnfermedad()	
	}
	
	method personaSeMudaA(persona, manzanaDestino) {
		self.sacarPersonaManzana(persona)
		manzanaDestino.personaEnManzana([persona])
	}
	//Este es para saber las personas que estan infectadas y ademas no estan aisladas
	method cantidadContagiadores() {
		// reemplazar por la cantidad de personas infectadas que no estan aisladas
		return personas.count({p=> p.estaInfectada() and not p.estaAislada()}) //MODIFICADO Nico
	}
	
	method noInfectades() {
		return personas.filter({ pers => not pers.estaInfectada() })
	} 
	
	method infectades() {
		return personas.filter({ pers => pers.estaInfectada() })
	} 
	
	method aislarATodesConSintomas() {
		const infectades = personas.filter({p=> p.estaInfectada() and p.presentaSintomas()})
		infectades.forEach({p=> p.estaAislada(true)})
	}
	
	method convencerManzana() {
		personas.forEach({p=> p.estaAislada(true)})
	}
	
	method terminoLaEnfermedad() {
		const curados = self.infectades().filter({ p=>
			simulacion.diaActual() - p.diaQueSeInfecto() == simulacion.duracionInfeccion()
			})
		curados.forEach({c=>c.estaInfectada(false)})
		curados.forEach({c=>c.presentaSintomas(false)})
		
	}	
	
	method simulacionContagiosDiarios() { 
		const cantidadContagiadores = self.cantidadContagiadores()
		if (cantidadContagiadores > 0) {
			self.noInfectades().forEach({ persona => 
				if (simulacion.debeInfectarsePersona(persona, cantidadContagiadores)) {
					persona.infectarse()
					persona.presentaSintomas(simulacion.presentarSintomas())
				}
			})
		}
	}
	
	method trasladoDeUnHabitante() {
		const quienesSePuedenMudar = personas.filter({ pers => not pers.estaAislada() })
		if (quienesSePuedenMudar.size() > 2) {
			const viajero = quienesSePuedenMudar.anyOne()
			const destino = simulacion.manzanas().filter({ manz => self.esManzanaVecina(manz) }).anyOne()
			self.personaSeMudaA(viajero, destino)			
		}
	}
}

//Hice el metodo cantidadContagiadores, cantidadDeInfectados
//cantidadDePersonasEnLaManzana, image 

// Modifique Image y cantidadContagiadores. Implemente personaSeMudaA. 5/7 Nico

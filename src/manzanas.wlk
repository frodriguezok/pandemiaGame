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
		else if (self.cantidadDeInfectados() == personas.size())
		{
			"rojo.png"
		}
	}

	method cantidadDePersonasEnLaManzana(){
		return personas.size()
	}

	method cantidadDeInfectados(){
		return personas.count({ p => p.estaInfectada()})
	}

	method cantidadConSintomas() {
		return personas.count({ p => p.presentaSintomas()})
	}
	
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
	
	method cantidadContagiadores() {
		return personas.count({p=> p.estaInfectada() and not p.estaAislada()})
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

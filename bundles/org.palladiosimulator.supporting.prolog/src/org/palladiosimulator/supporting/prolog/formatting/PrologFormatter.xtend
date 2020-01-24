package org.palladiosimulator.supporting.prolog.formatting

import com.google.inject.Inject
import org.eclipse.xtext.formatting2.AbstractFormatter2
import org.eclipse.xtext.formatting2.IFormattableDocument
import org.palladiosimulator.supporting.prolog.model.prolog.Program
import org.palladiosimulator.supporting.prolog.services.PrologGrammarAccess

class PrologFormatter extends AbstractFormatter2 {

	@Inject extension PrologGrammarAccess

	def dispatch void format(Program model, extension IFormattableDocument document) {
		// TODO: format HiddenRegions around keywords, attributes, cross references, etc. 
//		for (Greeting greetings : model.getGreetings()) {
//			greetings.format;
//		}
	}

}

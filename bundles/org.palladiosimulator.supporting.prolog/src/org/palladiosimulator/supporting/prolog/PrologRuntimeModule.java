/*
 * generated by Xtext 2.19.0
 */
package org.palladiosimulator.supporting.prolog;

import org.eclipse.xtext.conversion.IValueConverterService;
import org.eclipse.xtext.formatting2.IFormatter2;
import org.palladiosimulator.supporting.prolog.converter.PrologValueConverterService;
import org.palladiosimulator.supporting.prolog.formatting.PrologFormatter;

/**
 * Use this class to register components to be used at runtime / without the Equinox extension registry.
 */
public class PrologRuntimeModule extends AbstractPrologRuntimeModule {
	
	public Class<? extends IFormatter2> bindIFormatter2() {
		return PrologFormatter.class;
	}

	@Override
	public Class<? extends IValueConverterService> bindIValueConverterService() {
		return PrologValueConverterService.class;
	}

}

package org.palladiosimulator.supporting.prolog.api.impl;

import org.eclipse.xtext.serializer.ISerializer;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.ServiceScope;
import org.palladiosimulator.supporting.prolog.PrologStandaloneSetup;
import org.palladiosimulator.supporting.prolog.api.PrologAPI;
import org.palladiosimulator.supporting.prolog.parser.antlr.PrologParser;
import org.palladiosimulator.supporting.prolog.ui.internal.PrologActivator;

import com.google.inject.Injector;

@Component(scope = ServiceScope.SINGLETON)
public class PrologAPIImpl implements PrologAPI {

    private Injector injector;

    public PrologAPIImpl() {
        injector = createInjector();
    }
    
    private Injector createInjector() {
        Injector result = null;

        // try runtime singleton
        try {
            PrologActivator activator = PrologActivator.getInstance();
            if (activator != null) {
                result = activator.getInjector(PrologActivator.ORG_PALLADIOSIMULATOR_SUPPORTING_PROLOG_PROLOG);
            }
        } catch (NoClassDefFoundError err) {
            // UI not available or no runtime available
        }
        
        // try standalone
        if (result == null) {
            result = new PrologStandaloneSetup().createInjectorAndDoEMFRegistration();
        }

        return result;
    }

    @Override
    public PrologParser getParser() {
        return injector.getInstance(PrologParser.class);
    }

    @Override
    public ISerializer getSerializer() {
        return injector.getInstance(ISerializer.class);
    }

}

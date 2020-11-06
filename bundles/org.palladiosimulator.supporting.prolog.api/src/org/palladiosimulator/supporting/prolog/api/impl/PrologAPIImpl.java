package org.palladiosimulator.supporting.prolog.api.impl;

import java.util.Optional;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IConfigurationElement;
import org.eclipse.core.runtime.IExtensionRegistry;
import org.eclipse.core.runtime.Platform;
import org.eclipse.xtext.serializer.ISerializer;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.ServiceScope;
import org.palladiosimulator.supporting.prolog.PrologStandaloneSetup;
import org.palladiosimulator.supporting.prolog.api.PrologAPI;
import org.palladiosimulator.supporting.prolog.api.PrologInjectorProvider;
import org.palladiosimulator.supporting.prolog.parser.antlr.PrologParser;

import com.google.inject.Injector;

@Component(scope = ServiceScope.SINGLETON)
public class PrologAPIImpl implements PrologAPI {

    private static final String EP_ID = "org.palladiosimulator.supporting.prolog.api.injectorprovider";
    private static final String EP_ATTR = "class";
    private Injector injector;

    public PrologAPIImpl() {
        injector = createInjector();
    }

    private Injector createInjector() {
        Injector result = null;

        // try runtime extension point
        if (Platform.isRunning()) {
            IExtensionRegistry reg = Platform.getExtensionRegistry();
            IConfigurationElement[] elements = reg.getConfigurationElementsFor(EP_ID);
            for (var element : elements) {
                try {
                    result = Optional.ofNullable(element.createExecutableExtension(EP_ATTR))
                        .filter(PrologInjectorProvider.class::isInstance)
                        .map(PrologInjectorProvider.class::cast)
                        .map(PrologInjectorProvider::get)
                        .orElse(null);
                    if (result != null) {
                        break;
                    }
                } catch (CoreException e) {
                    // just ignore a broken extension and try the next one
                }
            }
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

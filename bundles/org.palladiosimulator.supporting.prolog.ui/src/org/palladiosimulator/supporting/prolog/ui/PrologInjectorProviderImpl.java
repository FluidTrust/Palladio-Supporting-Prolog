package org.palladiosimulator.supporting.prolog.ui;

import org.palladiosimulator.supporting.prolog.api.PrologInjectorProvider;

import com.google.inject.Inject;
import com.google.inject.Injector;

public class PrologInjectorProviderImpl implements PrologInjectorProvider {

    @Inject
    private Injector injector;

    @Override
    public Injector get() {
        return injector;
    }

}

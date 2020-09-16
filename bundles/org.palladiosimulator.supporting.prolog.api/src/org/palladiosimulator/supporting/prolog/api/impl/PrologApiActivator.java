package org.palladiosimulator.supporting.prolog.api.impl;

import org.eclipse.core.runtime.Plugin;
import org.osgi.framework.BundleContext;

public class PrologApiActivator extends Plugin {

    private static PrologApiActivator instance;

    @Override
    public void start(BundleContext context) throws Exception {
        super.start(context);
        setInstance(this);
    }

    @Override
    public void stop(BundleContext context) throws Exception {
        setInstance(null);
        super.stop(context);
    }

    public static PrologApiActivator getInstance() {
        return instance;
    }

    public static void setInstance(PrologApiActivator instance) {
        PrologApiActivator.instance = instance;
    }

}

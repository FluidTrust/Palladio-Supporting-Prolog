package org.palladiosimulator.supporting.prolog;

import org.eclipse.core.runtime.Plugin;
import org.osgi.framework.BundleContext;

public class Activator extends Plugin {

	private static Activator instance;
	
	@Override
	public void start(BundleContext context) throws Exception {
		super.start(context);
		setInstance(this);
	}

	@Override
	public void stop(BundleContext context) throws Exception {
		super.stop(context);
		setInstance(null);
	}
	
	private static void setInstance(Activator instance) {
		Activator.instance = instance;
	}
	
	public static Activator getInstance() {
		return Activator.instance;
	}

}

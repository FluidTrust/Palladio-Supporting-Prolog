package org.palladiosimulator.supporting.prolog;

import java.util.Map;
import java.util.Optional;

import org.apache.log4j.Logger;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IConfigurationElement;
import org.eclipse.core.runtime.IExecutableExtension;
import org.eclipse.core.runtime.IExecutableExtensionFactory;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.Platform;
import org.eclipse.core.runtime.Status;
import org.osgi.framework.Bundle;

import com.google.inject.Guice;
import com.google.inject.Injector;

public class PrologExecutableExtensionFactory implements IExecutableExtension, IExecutableExtensionFactory {

	public static final String GUICEKEY = "guicekey";
	protected Logger log = Logger.getLogger(getClass());
	protected String clazzName;
	protected IConfigurationElement config;

	@Override
	@SuppressWarnings({ "unchecked" })
	public void setInitializationData(IConfigurationElement config, String propertyName, Object data)
		throws CoreException {
		if (data instanceof String) {
			clazzName = (String) data;
		} else if (data instanceof Map<?, ?>) {
			clazzName = ((Map<String, String>)data).get(GUICEKEY);
		}
		if (clazzName == null) {
			throw new IllegalArgumentException("couldn't handle passed data : "+data);
		}
		this.config = config;
	}
	
	@Override
	public Object create() throws CoreException {
		try {
			Class<?> clazz;
			Optional<Bundle> bundle = getBundle();
			if (bundle.isPresent()) {
				// if running in platform
				clazz = getBundle().get().loadClass(clazzName);
			} else {
				// if running standalone
				clazz = Class.forName(clazzName);
			}
			final Injector injector = getInjector();
			if (injector == null) {
				throw handleCreationError(null);
			}
			final Object result = injector.getInstance(clazz);
			if (result instanceof IExecutableExtension)
				((IExecutableExtension) result).setInitializationData(config, null, null);
			return result;
		} catch (VirtualMachineError | CoreException e) {
			throw e;
		} catch (Throwable e) {
			throw handleCreationError(e);
		}
	}
	
	/**
	 * In the case that the EEF fails to create an injector or an instance of the desired class
	 * this method is called to produce a more user friendly error message.
	 * @since 2.13
	 */
	protected CoreException handleCreationError(Throwable cause) {
		String message;
		String contributor = config.getDeclaringExtension().getContributor().getName();
		Bundle bundle = Platform.getBundle(contributor);
		if (cause != null && ! (cause instanceof NullPointerException)) {
			message = cause.getMessage() + " (occurred in " + getClass().getName() + ")";
		} else {
			message = "Could not create the Injector for " + getClass().getName() + ".";
		}

		if (bundle.getState() != Bundle.ACTIVE) {
			message += "\nBundle " + bundle.getSymbolicName() + " was not activated.\n"
				+ "Please check that all dependencies could be resolved and 'Bundle-ActivationPolicy: lazy' is configured in the bundle's MANIFEST.MF. "
				+ "Check also the error log.";
		}
		if (cause instanceof NullPointerException) {
			message += "\nA NullPointerException occurred. This also indicates that bundle "+bundle.getSymbolicName()
				+ " was compiled with an outdated version of Xtext. Please consider to regenerate the DSL implementation "
				+ " with a current version.\n"
				+ "Your currently installed version of Xtext is "
				+ Platform.getBundle("org.eclipse.xtext.ui").getVersion() + ".";
		}

		return new CoreException(
				new Status(IStatus.ERROR, bundle.getSymbolicName(), message, cause));
	}
	
	protected Optional<Bundle> getBundle() {
		return Optional.ofNullable(Activator.getInstance()).map(Activator::getBundle);
	}
	
	protected Injector getInjector() {
		return Guice.createInjector(new PrologRuntimeModule());
	}

}

package org.palladiosimulator.supporting.prolog.tests

import com.google.inject.Inject
import org.eclipse.xtext.serializer.ISerializer
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.junit.jupiter.api.^extension.ExtendWith
import org.eclipse.emf.common.util.URI

@ExtendWith(InjectionExtension)
@InjectWith(PrologInjectorProvider)
class PrologFormattingTest {
	
	@Inject extension ISerializer
	
	protected def testSameAsExpected(String fileName) {
		
	}
	
	protected def readModel(String filename) {
		val fileUri = URI.createFileURI("testdata/" + filename)
		
	}
	
}
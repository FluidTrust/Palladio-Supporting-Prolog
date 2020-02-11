package org.palladiosimulator.supporting.prolog.tests

import com.google.common.base.Strings
import com.google.inject.Inject
import java.io.File
import java.nio.charset.StandardCharsets
import java.util.Collections
import org.apache.commons.io.FileUtils
import org.apache.commons.io.IOUtils
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.xtext.serializer.ISerializer
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.junit.jupiter.api.^extension.ExtendWith

@ExtendWith(InjectionExtension)
@InjectWith(PrologInjectorProvider)
class PrologFormattingTest {
	
	@Inject extension ISerializer
	
	protected def testSameAsExpected(String fileName) {
		val model = fileName.readModel
		val actual = model.serialize
		val expected = fileName.readText
	}
	
	protected def readModel(String filename) {
		val modelText = filename.readText
		val modelInputStream = IOUtils.toInputStream(modelText, StandardCharsets.UTF_8)
		
		val rs = new ResourceSetImpl
		val fileUri = URI.createFileURI("testdata/" + filename)
		val modelResource = rs.createResource(fileUri)
		modelResource.load(modelInputStream, Collections.emptyMap)
		return modelResource.contents.iterator.next
	}
	
	protected def readText(String filename) {
		return FileUtils.readFileToString(new File(filename), StandardCharsets.UTF_8)
	}
	
	private static def uglifyMinimalSpaces(String text) {
		return text.replaceAll("\\s+(?=([^\"]*\"[^\"]*\")*[^\"]*$)", " ")
	}
	
	private static def uglifyManySpaces(String text) {
		return text.replaceAll("\\s+(?=([^\"]*\"[^\"]*\")*[^\"]*$)", Strings.repeat(" ", 10))
	}
	
}